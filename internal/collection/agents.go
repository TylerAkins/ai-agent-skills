package collection

import (
	"bytes"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"github.com/BurntSushi/toml"
	"gopkg.in/yaml.v3"
)

var agentNames = []string{"architecture-advisor", "dependency-investigator", "independent-reviewer", "root-cause-investigator"}

type agentDefinition struct {
	Name        string   `yaml:"name"`
	Description string   `yaml:"description"`
	Tools       string   `yaml:"tools"`
	Skills      []string `yaml:"skills"`
	Body        string   `yaml:"-"`
}

func readAgents(root string) ([]agentDefinition, error) {
	entries, err := os.ReadDir(filepath.Join(root, "agents"))
	if err != nil {
		return nil, err
	}
	if len(entries) != len(agentNames) {
		return nil, fmt.Errorf("expected four canonical agents, got %d", len(entries))
	}
	var agents []agentDefinition
	for _, name := range agentNames {
		path := filepath.Join(root, "agents", name+".md")
		b, err := os.ReadFile(path)
		if err != nil {
			return nil, err
		}
		content := strings.ReplaceAll(string(b), "\r\n", "\n")
		parts := strings.SplitN(content, "\n---\n", 2)
		if len(parts) != 2 || !strings.HasPrefix(parts[0], "---\n") {
			return nil, fmt.Errorf("%s: invalid frontmatter", path)
		}
		var a agentDefinition
		decoder := yaml.NewDecoder(strings.NewReader(strings.TrimPrefix(parts[0], "---\n")))
		decoder.KnownFields(true)
		if err := decoder.Decode(&a); err != nil {
			return nil, err
		}
		a.Body = strings.TrimSpace(parts[1])
		if a.Name != name || a.Description == "" || a.Body == "" || a.Tools == "" {
			return nil, fmt.Errorf("%s: invalid agent definition", path)
		}
		if strings.Contains(a.Tools, "Bash") || strings.Contains(a.Tools, "Write") || strings.Contains(a.Tools, "Edit") || strings.Contains(a.Tools, "Agent") {
			return nil, fmt.Errorf("%s: agent must not have write or delegation tools", path)
		}
		for _, skill := range a.Skills {
			if _, err := os.Stat(filepath.Join(root, "skills", skill, "SKILL.md")); err != nil {
				return nil, fmt.Errorf("%s: missing skill %s: %w", path, skill, err)
			}
		}
		agents = append(agents, a)
	}
	return agents, nil
}

func renderAgent(a agentDefinition, target string) []byte {
	switch target {
	case "cursor":
		return []byte(fmt.Sprintf("---\nname: %s\ndescription: %q\nreadonly: true\n---\n\n%s\n", a.Name, a.Description, a.Body))
	case "copilot":
		return []byte(fmt.Sprintf("---\nname: %s\ndescription: %q\ntools: [read, search]\n---\n\n%s\n", a.Name, a.Description, a.Body))
	case "gemini":
		return []byte(fmt.Sprintf("---\nname: %s\ndescription: %q\nkind: local\ntools:\n  - read_file\n  - grep_search\n---\n\n%s\n", a.Name, a.Description, a.Body))
	case "antigravity":
		return []byte(fmt.Sprintf("---\nname: %s\ndescription: %q\ntools:\n  - view_file\n  - grep_search\nsubagent: true\nmainAgent: false\ncommandExecutionPolicy: sandbox\n---\n\n%s\n", a.Name, a.Description, a.Body))
	case "opencode":
		// Last-match-wins permissions block edits and command execution, while
		// leaving native read, search, web, and skill tools available.
		return []byte(fmt.Sprintf("---\ndescription: %q\nmode: subagent\npermissions:\n  - action: edit\n    resource: \"*\"\n    effect: deny\n  - action: shell\n    resource: \"*\"\n    effect: deny\n  - action: subagent\n    resource: \"*\"\n    effect: deny\n---\n\n%s\n", a.Description, a.Body))
	case "codex":
		// Codex does not offer a per-custom-agent sandbox. Disabling its shell
		// tool narrows one capability; parent permissions still apply.
		return []byte(fmt.Sprintf("name = %q\ndescription = %q\ndeveloper_instructions = %q\n\n[features]\nshell_tool = false\nrequest_permissions_tool = false\n", a.Name, a.Description, a.Body))
	default:
		panic("unsupported agent target")
	}
}

func writeAgentSet(root, out, target string) error {
	agents, err := readAgents(root)
	if err != nil {
		return err
	}
	formats := []string{target}
	if target == "native-agents" {
		formats = []string{"cursor", "copilot", "gemini", "antigravity"}
	}
	for _, format := range formats {
		dir := out
		if target == "native-agents" {
			dir = filepath.Join(out, format)
		}
		if err := os.MkdirAll(dir, 0755); err != nil {
			return err
		}
		for _, agent := range agents {
			ext := ".md"
			if target == "codex" {
				ext = ".toml"
			} else if format == "copilot" {
				ext = ".agent.md"
			}
			if err := os.WriteFile(filepath.Join(dir, agent.Name+ext), renderAgent(agent, format), 0644); err != nil {
				return err
			}
		}
	}
	return nil
}

func validateNativeAgentDir(dir, format string) error {
	entries, err := os.ReadDir(dir)
	if err != nil {
		return err
	}
	if len(entries) != len(agentNames) {
		return fmt.Errorf("expected four %s agents", format)
	}
	for _, name := range agentNames {
		ext := ".md"
		if format == "copilot" {
			ext = ".agent.md"
		}
		path := filepath.Join(dir, name+ext)
		fields, err := metadata(path)
		if err != nil {
			return err
		}
		if fields["name"] != name || fields["description"] == "" {
			return fmt.Errorf("invalid %s agent %s", format, name)
		}
		switch format {
		case "cursor":
			if fields["readonly"] != true {
				return fmt.Errorf("Cursor agent is not read-only: %s", name)
			}
		case "copilot":
			tools, ok := fields["tools"].([]any)
			if !ok || len(tools) != 2 || tools[0] != "read" || tools[1] != "search" {
				return fmt.Errorf("Copilot agent has unexpected tools: %s", name)
			}
		case "gemini":
			tools, ok := fields["tools"].([]any)
			if fields["kind"] != "local" || !ok || len(tools) != 2 || tools[0] != "read_file" || tools[1] != "grep_search" {
				return fmt.Errorf("Gemini agent has unexpected tools or kind: %s", name)
			}
		case "antigravity":
			tools, ok := fields["tools"].([]any)
			if fields["subagent"] != true || fields["mainAgent"] != false || fields["commandExecutionPolicy"] != "sandbox" || !ok || len(tools) != 2 || tools[0] != "view_file" || tools[1] != "grep_search" {
				return fmt.Errorf("Antigravity agent has unexpected capabilities: %s", name)
			}
		default:
			return fmt.Errorf("unknown native agent format %q", format)
		}
	}
	return nil
}

func validateAdaptedAgents(root, target string) error {
	entries, err := os.ReadDir(filepath.Join(root, "agents"))
	if err != nil {
		return err
	}
	if len(entries) != len(agentNames) {
		return fmt.Errorf("expected four %s agents", target)
	}
	for _, name := range agentNames {
		ext := ".md"
		if target == "codex" {
			ext = ".toml"
		}
		b, err := os.ReadFile(filepath.Join(root, "agents", name+ext))
		if err != nil {
			return err
		}
		if ext == ".toml" {
			var fields struct {
				Name                  string
				Description           string
				DeveloperInstructions string `toml:"developer_instructions"`
				Features              struct {
					ShellTool              bool `toml:"shell_tool"`
					RequestPermissionsTool bool `toml:"request_permissions_tool"`
				}
			}
			if _, err := toml.Decode(string(b), &fields); err != nil {
				return err
			}
			if fields.Name != name || fields.Description == "" || fields.DeveloperInstructions == "" || fields.Features.ShellTool || fields.Features.RequestPermissionsTool {
				return fmt.Errorf("invalid Codex agent %s", name)
			}
		} else {
			fields, err := metadata(filepath.Join(root, "agents", name+ext))
			if err != nil {
				return err
			}
			if fields["mode"] != "subagent" || fields["description"] == "" {
				return fmt.Errorf("invalid OpenCode agent %s", name)
			}
			var rules []struct{ Action, Resource, Effect string }
			raw, _ := yaml.Marshal(fields["permissions"])
			if err := yaml.Unmarshal(raw, &rules); err != nil {
				return err
			}
			sort.Slice(rules, func(i, j int) bool { return rules[i].Action < rules[j].Action })
			if len(rules) != 3 || rules[0].Action != "edit" || rules[1].Action != "shell" || rules[2].Action != "subagent" {
				return fmt.Errorf("missing OpenCode restrictions: %s", name)
			}
			for _, rule := range rules {
				if rule.Resource != "*" || rule.Effect != "deny" {
					return fmt.Errorf("weak OpenCode restriction: %s", name)
				}
			}
		}
		if !bytes.Contains(b, []byte("Do not")) && !bytes.Contains(b, []byte("do not")) {
			return fmt.Errorf("missing read-only instruction: %s", name)
		}
	}
	return nil
}
