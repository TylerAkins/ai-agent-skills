# Install and Update

On macOS or Linux, download or clone this repository and run the helper from its
checkout. Normal installs download published release bundles; Go is not required.
You need Bash, curl, tar, shasum, and jq. On macOS, install jq with `brew install jq`
if needed. The helper does not install apps or other tools for you.

```sh
bash scripts/install-ai-agent-skills.sh --flavor list
bash scripts/install-ai-agent-skills.sh --flavor cursor
```

Without a flavor, an interactive terminal shows the choices and asks you to choose.
The default version is the latest stable published release. Pin one with
`--version v1.0.0`. Run `--dry-run` to see paths without downloads or writes.

## Choose an Installation

| Flavor | Destination | Next step |
| --- | --- | --- |
| `cursor` | `~/.cursor/plugins/local/ai-agent-skills` | Reload Cursor; check Customize for the plugin, skills, rule, and reviewer. |
| `codex-desktop` | `~/.codex/plugins/ai-agent-skills` | Reopen ChatGPT/Codex; install from the personal marketplace in Plugins. |
| `codex-marketplace` | `$ROOT/plugins/ai-agent-skills` | Add the full ROOT path as a plugin marketplace source in the app. |
| `claude` | `~/.local/share/ai-agent-skills/claude` | Run Claude Code with `claude --plugin-dir` and that path. |
| `copilot-staging` | `~/.local/share/ai-agent-skills/copilot` | Staging only; a Copilot marketplace is still needed. |
| `copilot-skills` | `$PROJECT/.github/skills` | Start a new Copilot session and check Skills. |
| `codex-skills` | `$PROJECT/.agents/skills` | Start a new Codex session and select a skill. |
| `opencode-project` | `$PROJECT/.opencode/skills` | Start a new OpenCode session and request a skill. |
| `opencode-global` | `~/.config/opencode/skills` | Skills apply across OpenCode projects. |
| `list` | No installation | Show available flavors. |

Project flavors require `--project` with an existing absolute project path.
The custom marketplace flavor requires `--marketplace-root` with an absolute path.
Paths with symlink parents are refused; use the physical directory path.

```sh
bash scripts/install-ai-agent-skills.sh --flavor codex-desktop
bash scripts/install-ai-agent-skills.sh --flavor codex-marketplace --marketplace-root "$HOME/codex-marketplace"
bash scripts/install-ai-agent-skills.sh --flavor claude
bash scripts/install-ai-agent-skills.sh --flavor copilot-staging
bash scripts/install-ai-agent-skills.sh --flavor copilot-skills --project /absolute/path/to/project
bash scripts/install-ai-agent-skills.sh --flavor codex-skills --project /absolute/path/to/project
bash scripts/install-ai-agent-skills.sh --flavor opencode-project --project /absolute/path/to/project
bash scripts/install-ai-agent-skills.sh --flavor opencode-global
```

Codex desktop setup merges the collection's entry into
`~/.agents/plugins/marketplace.json`, preserving other entries and marketplace
metadata. Custom marketplace setup uses `$ROOT/.agents/plugins/marketplace.json`.
It does not enable plugins, edit Codex configuration, or register a CLI marketplace.
See [OpenAI local marketplace guidance](https://developers.openai.com/plugins/build/plugins).

Copilot staging does not register a marketplace or activate a plugin. See
[Copilot plugin guidance](https://docs.github.com/en/copilot/concepts/agents/about-plugins).
Windows scripts and all-home installation are not provided.

## Update Existing Files

```sh
bash scripts/install-ai-agent-skills.sh update --flavor cursor
bash scripts/install-ai-agent-skills.sh update --flavor codex-desktop --version v1.0.0
bash scripts/install-ai-agent-skills.sh update --flavor codex-skills --project /absolute/path/to/project --merge
```

Plugin updates replace the complete selected directory after confirmation.
Existing skills-only destinations require an explicit `--replace` or `--merge`,
even with `update`. Replace refreshes the whole skills directory, including
unrelated skills; merge replaces incoming skill folders but preserves unknown
folders. Both can overwrite local customizations in the selected scope.

Before replacement, the old directory is moved into a hidden
`.ai-agent-skills-backups/backup.*` directory beside the installation parent, with its path printed. Compare or restore it
if needed; remove it yourself when no longer useful. This is not an automatic
backup-retention service. Use `--yes` to confirm a selected operation in a
non-interactive session. Installing over an existing destination without a mode
fails rather than silently overwriting it.

Downloads are checked against the release's SHA256SUMS before extraction.
A failed download or checksum leaves the existing installation untouched. Catalog
updates are staged first; a failed catalog commit restores the previous plugin.
Checksums verify bytes against the same release source; they are not signed provenance.

Refresh/reinstall the host plugin after updating if it still loads a cached copy.
Quit and reopen the app, check the loaded version, and start a new session.
Successful file installation alone does not prove skill behavior.

## Build From Source

```sh
bash scripts/install-ai-agent-skills.sh --flavor cursor --from-source --version v1.0.0
bash scripts/install-ai-agent-skills.sh update --flavor cursor --from-source --ref main
```

Source mode clones the selected release tag into a temporary checkout and uses
the Go packager. Use `--ref main` explicitly to build unreleased main.
Git and stable Go >= 1.27.1 are required; the helper prints a download/install hint
if Go is missing or too old. Automatic Go toolchain downloads are disabled.
It never installs Go or edits shell configuration.
Use the same replacement and project flags as release installs.

## Uninstall and Troubleshoot

Disable/uninstall the plugin in its host, then remove only the destination listed
above. For Codex marketplace flavors, also remove the `ai-agent-skills` entry from
the relevant marketplace JSON while preserving other entries. For project or
global skills merged with other collections, remove only this collection's skill
folders; deleting the whole skills directory would also delete unrelated skills.

No `gh` CLI is required: the helper uses curl and the GitHub API. For network,
rate-limit, missing release, or missing asset errors, retry only after resolving
the cause or select a known published `--version`. If jq is missing, install it
before retrying. If a marketplace file is invalid, fix or restore it first.
For advanced host details and discovery restrictions, see [host setup](plugins.md).
