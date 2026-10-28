# Packaging Reference

For quick-start installation choices, see the [README](../README.md#install).
For host activation and update steps, see the [installer reference](installer-reference.md#activate-an-installation).
This page is for maintainers inspecting or building host packages.

## Implementation map

| Behavior | Source of truth |
| --- | --- |
| Package validation and assembly | [Collection packager](../internal/collection/collection.go) |
| Host-specific agent conversion | [Agent packager](../internal/collection/agents.go) |
| Packager command options | [skillpack command](../cmd/skillpack/main.go) |
| Continuous validation | [Validation workflow](../.github/workflows/validate.yml) |
| Release package targets | [Release workflow](../.github/workflows/release.yml) |

The package tables and commands below describe those files. Update this page when
their targets or validation behavior changes.

## Package Contents

Every target contains the complete `skills/` collection and supporting resources.

| Release target | Hosts | Additional components |
| --- | --- | --- |
| `cursor` | Cursor | `.cursor-plugin/plugin.json`, `rules/`, `agents/`, LICENSE |
| `claude` | Claude Code | `.claude-plugin/plugin.json`, `agents/`, LICENSE |
| `portable` | Codex, Copilot | Root `plugin.json`, LICENSE |
| `skills` | OpenCode, Gemini CLI, Muse Code, Antigravity | LICENSE; no plugin manifest |
| `opencode` | OpenCode native agents | OpenCode Markdown `agents/`, LICENSE; no plugin manifest |
| `codex` | Codex native agents | Root `plugin.json`, Codex TOML `agents/`, LICENSE |
| `native-agents` | Cursor, Copilot, Gemini CLI, Antigravity native agents | Canonical-format subdirectories under `agents/`, LICENSE; no plugin manifest |

The release workflow prepares these seven `.tar.gz` archives. Installer flavors
select host-specific destinations and activation steps. The `copilot` build target
remains available for older source-build consumers and has the same contents as
`portable`. The `codex` and `opencode` targets now add native agents to their
respective skills packages.

Cursor includes a native-first routing rule and four canonical agent prompts;
Claude includes those prompts with tool allowlists. OpenCode, Codex, Cursor,
Copilot, Gemini CLI, and Antigravity use deterministic host-specific adaptations.
Native agent installation and read-only limits are listed in the [host compatibility matrix](host-compatibility.md#specialized-subagents).

Repository `AGENTS.md`, tooling, credentials, and the `.cursor/skills` discovery
symlink are excluded. Do not symlink this checkout into Cursor's local-plugin
folder; external targets are skipped.

## Validate and Build

Use the Go version in `go.mod`. From the checkout:

```sh
go test -race ./...
go vet ./...
go run ./cmd/skillpack
```

Build into new directories outside the checkout:

```sh
package_root=$(mktemp -d)
for host in cursor claude portable skills opencode codex native-agents; do
  go run ./cmd/skillpack -target "$host" -out "$package_root/$host"
done
```

The output directories must not exist. The packager refuses overwrite and validates
each generated package. Checks cover metadata, local links, inventories, package
contracts, and parser-backed agent formats, not live delegation.

For a temporary source checkout and local installation, use
[installer source mode](installer-reference.md#source-builds-and-manual-installation).
For release assets, use [release preparation](releases.md).

## Verify in Each Host

For a changed skill or agent, choose a representative task that exercises the
changed behavior in each affected host. Confirm discovery, invoke the workflow,
and check any linked resources or host-specific controls involved in that task.
For multi-step workflows, include the relevant handoff, verification, review, and
authorization boundaries. Do not run unrelated Jira, deployment, or delivery steps
just to exercise a different workflow.

Record the host and version, prompt, observed result, and missing checks. File
placement, package validation, and installer tests do not establish that an agent
followed its instructions.

## Skill Activation Limits

Supported hosts expose skill names and descriptions to the agent and document
model-mediated selection for relevant requests. Selection and instruction following
remain model behavior, not an enforced runtime gate. Native selection should load a
clear matching skill directly. `using-skills` is for ambiguous or multi-workflow
requests, not a mandatory step for every engineering task. A link in a plan proves
only that the executor has a path to the skill. It does not prove the skill was
loaded or used.

Do not add a persistent router where native selection already covers the same work.
If an officially documented host lacks native skill selection and a supported
instruction mechanism can address it, add only a short conditional instruction that
preserves user-defined settings. Keep detailed procedures in the canonical skills.
Do not copy this repository's `AGENTS.md` as generic installed instructions. Verify
the host, surface, and model behavior separately from structural installation tests.

## Host References and Distribution

- [Cursor plugins](https://cursor.com/docs/plugins) and [manifest reference](https://cursor.com/docs/reference/plugins)
- [OpenAI local plugins and marketplaces](https://developers.openai.com/plugins/build/plugins)
- [Claude plugins](https://code.claude.com/docs/en/plugins) and [manifest reference](https://code.claude.com/docs/en/plugins-reference)
- [Copilot plugin formats](https://docs.github.com/en/copilot/concepts/agents/about-plugins)
- [OpenCode skills](https://opencode.ai/docs/skills/)
- [Gemini CLI skills](https://geminicli.com/docs/cli/using-agent-skills/)
- [Antigravity skills](https://antigravity.google/docs/skills)
- [Muse Code skills](https://meta-models.github.io/muse-code-sdk/next/guides/extend/skills/)
- [OpenChamber skills](https://docs.openchamber.dev/skills)

See the [host compatibility matrix](host-compatibility.md) for the complete host,
surface, installation, and invocation audit, including third-party clients.

Packaging and release assets do not create marketplace listings. Cursor submissions
go through [the publisher form](https://cursor.com/marketplace/publish).
Codex, Claude, and Copilot have separate marketplace formats; OpenCode, Gemini CLI,
Muse Code, and Antigravity consume skill folders directly. Publishing or registering
a marketplace remains a separate authorized action.
