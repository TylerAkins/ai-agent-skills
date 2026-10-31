# Packaging reference

Validate the canonical collection and build host packages without installing them.
For normal setup, use the [README](../README.md#install); for destination and update
behavior, use the [installer reference](installer-reference.md).

## Package contents

Every target contains the full `skills/` tree with its supporting resources and
`LICENSE`. Host targets add the following:

| Target | Additional contents | Use |
| --- | --- | --- |
| `portable` | Root `plugin.json` | Codex desktop and Copilot plugin payloads. |
| `skills` | None | Skills-only payload for OpenCode, Gemini CLI, Muse Code, and Antigravity. |
| `claude` | `.claude-plugin/plugin.json`, canonical `agents/` | Claude Code plugin and native agent payload. |
| `cursor` | `.cursor-plugin/plugin.json`, `rules/`, adapted `agents/` | Cursor plugin with routing and read-only agent declarations. |
| `codex` | Root `plugin.json`, TOML `agents/` | Codex native agent payload alongside skills. |
| `opencode` | Markdown `agents/` | OpenCode native agent payload alongside skills. |
| `native-agents` | Host-specific subdirectories under `agents/` | Cursor, Copilot, Gemini CLI, and Antigravity agents. |
| `copilot` | Same contents as `portable` | Legacy source-build target; not a separate current release asset. |

The release workflow builds seven archives, excluding the legacy `copilot` alias.
Skill-only installers select only `skills/`; agent-only installers select only the
matching `agents/` payload. An archive containing both does not mean both are
installed by every flavor.

Repository instructions, README/docs, tooling, credentials, and the discovery
symlink are excluded. Do not install the source checkout as a plugin symlink.
Keep portable, Claude, and Cursor manifest names and versions aligned.

## Validate and build

Use the Go version in [go.mod](../go.mod). From the repository root:

```sh
go test -race ./...
go vet ./...
go run ./cmd/skillpack
```

The source validator checks skill frontmatter, names, local file links,
registration in the README/router, manifest consistency, and canonical agent
contracts. It does not check every heading anchor, render the docs, or exercise a
host model. See [contributor checks](../CONTRIBUTING.md#validate-your-change) for
document, installer, shell, and workflow validation.

Build every target into a new directory outside the checkout. Output parents must
exist; the target output directories must not. The packager refuses overwrite and
validates each completed package.

**macOS / Linux (Bash)**

```sh
package_root=$(mktemp -d)
for target in portable skills claude cursor codex opencode native-agents copilot; do
  go run ./cmd/skillpack -target "$target" -out "$package_root/$target" || exit 1
done
```

**Windows (PowerShell 7.4+)**

```powershell
$packageRoot = Join-Path ([IO.Path]::GetTempPath()) ([Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $packageRoot | Out-Null
foreach ($target in @('portable', 'skills', 'claude', 'cursor', 'codex', 'opencode', 'native-agents', 'copilot')) {
    go run ./cmd/skillpack -target $target -out (Join-Path $packageRoot $target)
    if ($LASTEXITCODE -ne 0) { throw "Package build failed: $target" }
}
```

To validate an existing package, pass its root and target without `-out`:

```sh
go run ./cmd/skillpack -root /absolute/path/to/package -target portable
```

This command inspects the package; it does not install it. For release archives and
checksums, follow [release preparation](releases.md).

## Verify in each host

Choose a representative task for the changed skill or agent. Confirm discovery,
request the workflow, and inspect the result and visible skill/delegation activity.
Include handoff, checks, and review when they are part of the workflow. Do not
exercise unrelated Jira writes, deployment, or delivery just to test discovery.

Record host/version, skill and target revisions, request, observed artifacts,
actual checks, and missing prerequisites. A package build proves structure; an
installer test proves file placement; an agent listing proves registration.
None alone proves the model loaded or followed a skill.

## Skill activation limits

Hosts can expose names/descriptions for native model selection. Load a clear
matching skill directly; use `using-skills` for ambiguous or multi-workflow work.
Selection and instruction following remain model behavior.

Do not add persistent routing instructions when native selection already serves
the same purpose. If a documented host gap needs a supported instruction mechanism,
keep it conditional and preserve user settings. Never install this repository's
`AGENTS.md` as global user instructions. A link in a plan gives the executor a
path to a skill; it is not evidence that the skill ran.

## Distribution and marketplaces

Packages and release assets do not create marketplace listings. The shell helper
can prepare a local Codex desktop catalog; Copilot staging still needs a separately
configured marketplace. Publishing/submission is a separately authorized action.

Use the [host compatibility guide](host-compatibility.md) for discovery, official
host references, and native-agent restrictions. Check the target host's current
manifest requirements before adding another distribution format.

## Implementation map

| Contract | Source |
| --- | --- |
| Validation and package assembly | [Collection packager](../internal/collection/collection.go) |
| Agent adaptation and parser validation | [Agent packager](../internal/collection/agents.go) |
| CLI options | [skillpack command](../cmd/skillpack/main.go) |
| Required CI jobs and package builds | [Validation workflow](../.github/workflows/validate.yml) |
| Archives and release creation | [Release workflow](../.github/workflows/release.yml) |
