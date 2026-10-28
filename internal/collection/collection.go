package collection

import (
	"encoding/json"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"

	"gopkg.in/yaml.v3"
)

const Schema = "https://agent-plugins.org/schemas/1.0.0/plugin.schema.json"

type Manifest struct {
	Schema      string `json:"$schema"`
	Name        string `json:"name"`
	Version     string `json:"version"`
	Description string `json:"description"`
	Skills      string `json:"skills"`
	Rules       string `json:"rules"`
	Agents      string `json:"agents"`
}

var nameRE = regexp.MustCompile(`^[a-z0-9]+(?:-[a-z0-9]+)*$`)
var versionRE = regexp.MustCompile(`^[0-9]+\.[0-9]+\.[0-9]+(?:-[0-9A-Za-z.-]+)?$`)
var definitionRE = regexp.MustCompile(`^\s{0,3}\[([^\]]+)\]:\s*<?([^ >]+)>?`)
var referenceRE = regexp.MustCompile(`\[([^\]]+)\]\[([^\]]*)\]`)
var linkRE = regexp.MustCompile(`\[[^\]]*\]\(([^)]+)\)`)

func manifest(root, path string) (Manifest, error) {
	var m Manifest
	b, err := os.ReadFile(filepath.Join(root, path))
	if err != nil {
		return m, err
	}
	if err = json.Unmarshal(b, &m); err != nil {
		return m, fmt.Errorf("%s: %w", path, err)
	}
	if !nameRE.MatchString(m.Name) || !versionRE.MatchString(m.Version) || strings.TrimSpace(m.Description) == "" {
		return m, fmt.Errorf("%s: invalid identity metadata", path)
	}
	return m, nil
}

func metadata(path string) (map[string]any, error) {
	b, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	lines := strings.Split(strings.ReplaceAll(string(b), "\r\n", "\n"), "\n")
	if len(lines) < 3 || lines[0] != "---" {
		return nil, fmt.Errorf("%s: missing frontmatter", path)
	}
	end := 1
	for end < len(lines) && lines[end] != "---" {
		end++
	}
	if end == len(lines) {
		return nil, fmt.Errorf("%s: unclosed frontmatter", path)
	}
	var fields map[string]any
	if err = yaml.Unmarshal([]byte(strings.Join(lines[1:end], "\n")), &fields); err != nil {
		return nil, fmt.Errorf("%s: %w", path, err)
	}
	if strings.TrimSpace(strings.Join(lines[end+1:], "\n")) == "" {
		return nil, fmt.Errorf("%s: empty instructions", path)
	}
	return fields, nil
}

func safeFiles(root string) error {
	return filepath.WalkDir(root, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if d.Type()&os.ModeSymlink != 0 {
			return fmt.Errorf("symlink is not allowed in package components: %s", path)
		}
		if !d.IsDir() && !d.Type().IsRegular() {
			return fmt.Errorf("non-regular package file: %s", path)
		}
		return nil
	})
}

func links(root, path string) error {
	b, err := os.ReadFile(path)
	if err != nil {
		return err
	}
	definitions := map[string]string{}
	for _, line := range strings.Split(string(b), "\n") {
		if m := definitionRE.FindStringSubmatch(line); m != nil {
			definitions[strings.ToLower(strings.TrimSpace(m[1]))] = m[2]
		}
	}
	fenced := false
	for _, line := range strings.Split(string(b), "\n") {
		t := strings.TrimSpace(line)
		if strings.HasPrefix(t, "```") || strings.HasPrefix(t, "~~~") {
			fenced = !fenced
			continue
		}
		if fenced {
			continue
		}
		matches := linkRE.FindAllStringSubmatch(line, -1)
		if m := definitionRE.FindStringSubmatch(line); m != nil {
			matches = append(matches, []string{m[0], m[2]})
		}
		for _, m := range referenceRE.FindAllStringSubmatch(line, -1) {
			id := m[2]
			if id == "" {
				id = m[1]
			}
			target, ok := definitions[strings.ToLower(strings.TrimSpace(id))]
			if !ok {
				return fmt.Errorf("%s: undefined link reference %s", path, id)
			}
			matches = append(matches, []string{m[0], target})
		}
		for _, match := range matches {
			target := strings.Trim(match[1], "<>")
			if target == "url" && strings.Contains(line, "e.g.") || strings.HasPrefix(target, "#") || strings.Contains(target, "://") {
				continue
			}
			target = strings.Split(target, "#")[0]
			resolved := filepath.Clean(filepath.Join(filepath.Dir(path), filepath.FromSlash(target)))
			rel, err := filepath.Rel(root, resolved)
			if err != nil || rel == ".." || strings.HasPrefix(rel, ".."+string(filepath.Separator)) {
				return fmt.Errorf("%s: link escapes collection: %s", path, target)
			}
			if _, err = os.Stat(resolved); err != nil {
				return fmt.Errorf("%s: missing link %s", path, target)
			}
		}
	}
	return nil
}

// Validate checks source or generated package contracts, not agent behavior.
func Validate(root, target string) ([]string, error) {
	root, err := filepath.Abs(root)
	if err != nil {
		return nil, err
	}
	if target != "source" && !packageTarget(target) {
		return nil, fmt.Errorf("unknown target %q", target)
	}
	mpath := "plugin.json"
	if target == "cursor" {
		mpath = ".cursor-plugin/plugin.json"
	}
	if target == "claude" {
		mpath = ".claude-plugin/plugin.json"
	}
	var m Manifest
	if target != "opencode" && target != "skills" {
		m, err = manifest(root, mpath)
		if err != nil {
			return nil, err
		}
	}
	components := []string{"skills"}
	if target == "source" || target == "cursor" {
		c, err := manifest(root, ".cursor-plugin/plugin.json")
		if err != nil {
			return nil, err
		}
		if c.Skills != "./skills/" || c.Rules != "./rules/" || c.Agents != "./agents/" {
			return nil, fmt.Errorf("Cursor component paths must refer to canonical directories")
		}
		if target == "source" && (m.Name != c.Name || m.Version != c.Version) {
			return nil, fmt.Errorf("manifest identity/version drift")
		}
		components = append(components, "rules", "agents", ".cursor-plugin")
	}
	if (target == "source" || target == "codex" || target == "copilot" || target == "portable") && m.Schema != Schema {
		return nil, fmt.Errorf("portable manifest schema missing or unsupported")
	}
	if target == "source" || target == "claude" {
		c, err := manifest(root, ".claude-plugin/plugin.json")
		if err != nil {
			return nil, err
		}
		if c.Name != m.Name || c.Version != m.Version {
			return nil, fmt.Errorf("Claude manifest identity/version drift")
		}
		if c.Schema != "" || c.Skills != "" || c.Agents != "" || c.Rules != "" {
			return nil, fmt.Errorf("Claude manifest must use default component discovery")
		}
		components = append(components, ".claude-plugin")
		if target == "claude" {
			components = append(components, "agents")
		}
	}
	if target == "opencode" || target == "codex" {
		components = append(components, "agents")
	}
	for _, component := range components {
		if err = safeFiles(filepath.Join(root, component)); err != nil {
			return nil, err
		}
	}
	entries, err := os.ReadDir(filepath.Join(root, "skills"))
	if err != nil {
		return nil, err
	}
	names := []string{}
	for _, entry := range entries {
		if !entry.IsDir() {
			return nil, fmt.Errorf("unexpected skill entry: %s", entry.Name())
		}
		path := filepath.Join(root, "skills", entry.Name(), "SKILL.md")
		fields, err := metadata(path)
		if err != nil {
			return nil, err
		}
		name, ok := fields["name"].(string)
		if !ok || name != entry.Name() || !nameRE.MatchString(name) || len(name) > 64 {
			return nil, fmt.Errorf("%s: name must match folder", path)
		}
		desc, ok := fields["description"].(string)
		if !ok || strings.TrimSpace(desc) == "" || len([]rune(desc)) > 1024 {
			return nil, fmt.Errorf("%s: description must contain 1–1024 characters", path)
		}
		names = append(names, name)
	}
	if len(names) == 0 {
		return nil, fmt.Errorf("no skills found")
	}
	for _, component := range components {
		err = filepath.WalkDir(filepath.Join(root, component), func(path string, d fs.DirEntry, err error) error {
			if err != nil {
				return err
			}
			if d.IsDir() {
				return nil
			}
			if strings.HasSuffix(path, ".md") || strings.HasSuffix(path, ".mdc") {
				if err = links(root, path); err != nil {
					return err
				}
			}
			if (component == "agents" && (target == "source" || target == "cursor" || target == "claude" || target == "opencode")) || component == "rules" {
				fields, err := metadata(path)
				if err != nil {
					return err
				}
				if desc, ok := fields["description"].(string); !ok || strings.TrimSpace(desc) == "" {
					return fmt.Errorf("%s: missing description", path)
				}
				if component == "rules" {
					if _, ok := fields["alwaysApply"].(bool); !ok {
						return fmt.Errorf("%s: invalid alwaysApply", path)
					}
				}
				if component == "agents" && target != "opencode" {
					if name, ok := fields["name"].(string); !ok || !nameRE.MatchString(name) {
						return fmt.Errorf("%s: invalid agent name", path)
					}
				}
			}
			return nil
		})
		if err != nil {
			return nil, err
		}
	}
	if target == "source" {
		if _, err := readAgents(root); err != nil {
			return nil, err
		}
		for _, p := range []string{"README.md", "AGENTS.md"} {
			if err = links(root, filepath.Join(root, p)); err != nil {
				return nil, err
			}
		}
		readme, err := os.ReadFile(filepath.Join(root, "README.md"))
		if err != nil {
			return nil, err
		}
		router, err := os.ReadFile(filepath.Join(root, "skills/using-skills/SKILL.md"))
		if err != nil {
			return nil, err
		}
		for _, name := range names {
			if !strings.Contains(string(readme), "skills/"+name+"/SKILL.md") {
				return nil, fmt.Errorf("README missing skill %s", name)
			}
			if name != "using-skills" && !strings.Contains(string(router), "../"+name+"/SKILL.md") {
				return nil, fmt.Errorf("router missing skill %s", name)
			}
		}
	}
	if target == "opencode" || target == "codex" {
		if err := validateAdaptedAgents(root, target); err != nil {
			return nil, err
		}
	}
	sort.Strings(names)
	return names, nil
}

// Build writes a new directory only, excluding repository instructions and tooling.
func Build(root, out, target string) error {
	if !packageTarget(target) {
		return fmt.Errorf("unknown package target %q", target)
	}
	if _, err := Validate(root, "source"); err != nil {
		return err
	}
	absRoot, err := filepath.EvalSymlinks(root)
	if err != nil {
		return err
	}
	absOut, err := filepath.Abs(out)
	if err != nil {
		return err
	}
	absRoot, err = filepath.Abs(absRoot)
	if err != nil {
		return err
	}
	parent, err := filepath.EvalSymlinks(filepath.Dir(absOut))
	if err != nil {
		return fmt.Errorf("resolve output parent: %w", err)
	}
	absOut = filepath.Join(parent, filepath.Base(absOut))
	// Paths on distinct Windows volumes cannot be inside one another.
	if strings.EqualFold(filepath.VolumeName(absRoot), filepath.VolumeName(absOut)) {
		rel, err := filepath.Rel(absRoot, absOut)
		if err != nil {
			return err
		}
		if rel == "." || !strings.HasPrefix(rel, ".."+string(filepath.Separator)) && rel != ".." {
			return fmt.Errorf("output must be outside source collection")
		}
	}
	if err = os.Mkdir(absOut, 0755); err != nil {
		return fmt.Errorf("output must be a new directory: %w", err)
	}
	success := false
	defer func() {
		if !success {
			os.RemoveAll(absOut)
		}
	}()
	components := []string{"skills", "LICENSE", "plugin.json"}
	if target == "cursor" {
		components = []string{"skills", "LICENSE", ".cursor-plugin", "rules", "agents"}
	}
	if target == "claude" {
		components = []string{"skills", "LICENSE", ".claude-plugin", "agents"}
	}
	if target == "opencode" || target == "skills" {
		components = []string{"skills", "LICENSE"}
	}
	if target == "opencode" || target == "codex" {
		components = append(components, "agents")
	}
	for _, component := range components {
		if component == "agents" && (target == "opencode" || target == "codex") {
			agents, err := readAgents(absRoot)
			if err != nil {
				return err
			}
			if err := os.MkdirAll(filepath.Join(absOut, component), 0755); err != nil {
				return err
			}
			for _, agent := range agents {
				ext := ".md"
				if target != "opencode" {
					ext = ".toml"
				}
				if err := os.WriteFile(filepath.Join(absOut, component, agent.Name+ext), renderAgent(agent, target), 0644); err != nil {
					return err
				}
			}
			continue
		}
		base := filepath.Join(absRoot, component)
		if err = safeFiles(base); err != nil {
			return err
		}
		err = filepath.WalkDir(base, func(path string, d fs.DirEntry, err error) error {
			if err != nil {
				return err
			}
			rel, err := filepath.Rel(absRoot, path)
			if err != nil {
				return err
			}
			dest := filepath.Join(absOut, rel)
			if d.IsDir() {
				return os.MkdirAll(dest, 0755)
			}
			b, err := os.ReadFile(path)
			if err != nil {
				return err
			}
			return os.WriteFile(dest, b, 0644)
		})
		if err != nil {
			return err
		}
	}
	if _, err = Validate(absOut, target); err != nil {
		return err
	}
	success = true
	return nil
}

func packageTarget(target string) bool {
	switch target {
	case "cursor", "codex", "claude", "copilot", "opencode", "skills", "portable":
		return true
	}
	return false
}
