package collection

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func fixture(t *testing.T) string {
	t.Helper()
	root := t.TempDir()
	files := map[string]string{
		".claude-plugin/plugin.json":        `{"name":"demo","version":"0.1.0","description":"Demo"}`,
		"plugin.json":                       `{"$schema":"` + Schema + `","name":"demo","version":"0.1.0","description":"Demo"}`,
		".cursor-plugin/plugin.json":        `{"name":"demo","version":"0.1.0","description":"Demo","skills":"./skills/","rules":"./rules/","agents":"./agents/"}`,
		"skills/demo/SKILL.md":              "---\nname: demo\ndescription: Demonstrate a contract.\n---\nRead [details](references/details.md).\n",
		"skills/demo/references/details.md": "# Details\nUse the real reference.\n",
		"skills/using-skills/SKILL.md":      "---\nname: using-skills\ndescription: Route tasks.\n---\nRead [demo](../demo/SKILL.md).\n",
		"rules/routing.mdc":                 "---\ndescription: Route tasks.\nalwaysApply: true\n---\nUse demo.\n",
		"agents/reviewer.md":                "---\nname: reviewer\ndescription: Review code.\n---\nRemain read-only.\n",
		"README.md":                         "[demo](skills/demo/SKILL.md)\n[router](skills/using-skills/SKILL.md)\n",
		"AGENTS.md":                         "# Instructions\n",
		"LICENSE":                           "MIT\n",
	}
	for p, s := range files {
		path := filepath.Join(root, p)
		if err := os.MkdirAll(filepath.Dir(path), 0755); err != nil {
			t.Fatal(err)
		}
		if err := os.WriteFile(path, []byte(s), 0644); err != nil {
			t.Fatal(err)
		}
	}
	return root
}

func TestBuildPreservesDependenciesAndSeparatesHosts(t *testing.T) {
	root := fixture(t)
	for _, target := range []string{"cursor", "codex", "claude", "copilot", "opencode", "skills", "portable"} {
		t.Run(target, func(t *testing.T) {
			out := filepath.Join(t.TempDir(), "package")
			if err := Build(root, out, target); err != nil {
				t.Fatal(err)
			}
			for _, p := range []string{"skills/demo/SKILL.md", "skills/demo/references/details.md", "LICENSE"} {
				a, _ := os.ReadFile(filepath.Join(root, p))
				b, err := os.ReadFile(filepath.Join(out, p))
				if err != nil || string(a) != string(b) {
					t.Fatalf("dependency changed/missing: %s", p)
				}
			}
			if _, err := os.Stat(filepath.Join(out, "AGENTS.md")); !os.IsNotExist(err) {
				t.Fatal("repo instructions shipped")
			}
			absent := "plugin.json"
			if target != "cursor" {
				absent = ".cursor-plugin"
			}
			if target == "claude" || target == "opencode" || target == "skills" {
				absent = "plugin.json"
			}
			if _, err := os.Stat(filepath.Join(out, absent)); !os.IsNotExist(err) {
				t.Fatal("mixed host formats")
			}
			expected := map[string][]string{
				"cursor":   {".cursor-plugin", "LICENSE", "agents", "rules", "skills"},
				"codex":    {"LICENSE", "plugin.json", "skills"},
				"copilot":  {"LICENSE", "plugin.json", "skills"},
				"portable": {"LICENSE", "plugin.json", "skills"},
				"claude":   {".claude-plugin", "LICENSE", "agents", "skills"},
				"opencode": {"LICENSE", "skills"},
				"skills":   {"LICENSE", "skills"},
			}
			entries, err := os.ReadDir(out)
			if err != nil {
				t.Fatal(err)
			}
			var got []string
			for _, entry := range entries {
				got = append(got, entry.Name())
			}
			if strings.Join(got, ",") != strings.Join(expected[target], ",") {
				t.Fatalf("wrong host components: %v", got)
			}
			if err := Build(root, out, target); err == nil {
				t.Fatal("overwrote existing output")
			}
		})
	}
}

func TestRejectInvalidCollection(t *testing.T) {
	cases := map[string]func(string){
		"missing reference": func(r string) { os.Remove(filepath.Join(r, "skills/demo/references/details.md")) },
		"name mismatch": func(r string) {
			os.WriteFile(filepath.Join(r, "skills/demo/SKILL.md"), []byte("---\nname: wrong\ndescription: Demo\n---\nBody\n"), 0644)
		},
		"duplicate YAML key": func(r string) {
			os.WriteFile(filepath.Join(r, "skills/demo/SKILL.md"), []byte("---\nname: demo\nname: demo\ndescription: Demo\n---\nBody\n"), 0644)
		},
		"symlink": func(r string) { os.Symlink("/etc/passwd", filepath.Join(r, "skills/demo/escape")) },
		"manifest drift": func(r string) {
			p := filepath.Join(r, "plugin.json")
			b, _ := os.ReadFile(p)
			os.WriteFile(p, []byte(strings.ReplaceAll(string(b), "0.1.0", "0.2.0")), 0644)
		},
		"Claude drift": func(r string) {
			os.WriteFile(filepath.Join(r, ".claude-plugin/plugin.json"), []byte(`{"name":"demo","version":"9.0.0","description":"Demo"}`), 0644)
		},
		"long description": func(r string) {
			os.WriteFile(filepath.Join(r, "skills/demo/SKILL.md"), []byte("---\nname: demo\ndescription: "+strings.Repeat("x", 1025)+"\n---\nBody\n"), 0644)
		},
		"inventory omission": func(r string) { os.WriteFile(filepath.Join(r, "README.md"), []byte("# Empty\n"), 0644) },
		"escaping link": func(r string) {
			os.WriteFile(filepath.Join(r, "skills/demo/references/details.md"), []byte("[outside](../../../../outside.md)\n"), 0644)
		},
	}
	for name, mutate := range cases {
		t.Run(name, func(t *testing.T) {
			root := fixture(t)
			mutate(root)
			if _, err := Validate(root, "source"); err == nil {
				t.Fatal("accepted invalid collection")
			}
		})
	}
}

func TestOutputCannotMutateSource(t *testing.T) {
	root := fixture(t)
	if err := Build(root, filepath.Join(root, "output"), "cursor"); err == nil {
		t.Fatal("accepted source output")
	}
	if _, err := os.Stat(filepath.Join(root, "output")); !os.IsNotExist(err) {
		t.Fatal("source output created")
	}
}

func TestSymlinkParentCannotBypassSourceGuard(t *testing.T) {
	root := fixture(t)
	alias := filepath.Join(t.TempDir(), "alias")
	if err := os.Symlink(root, alias); err != nil {
		t.Fatal(err)
	}
	if err := Build(root, filepath.Join(alias, "output"), "cursor"); err == nil {
		t.Fatal("accepted aliased source output")
	}
	if _, err := os.Stat(filepath.Join(root, "output")); !os.IsNotExist(err) {
		t.Fatal("mutated source through alias")
	}
}

func TestReferenceLinks(t *testing.T) {
	for _, content := range []string{"[missing][ref]\n\n[ref]: no-such-file.md\n", "[missing][undefined]\n"} {
		root := fixture(t)
		if err := os.WriteFile(filepath.Join(root, "skills/demo/references/details.md"), []byte(content), 0644); err != nil {
			t.Fatal(err)
		}
		if _, err := Validate(root, "source"); err == nil {
			t.Fatal("accepted broken reference link")
		}
	}
	root := fixture(t)
	if err := os.WriteFile(filepath.Join(root, "skills/demo/references/details.md"), []byte("[skill][entry]\n\n[entry]: ../SKILL.md\n"), 0644); err != nil {
		t.Fatal(err)
	}
	if _, err := Validate(root, "source"); err != nil {
		t.Fatal(err)
	}
}
