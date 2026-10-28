# Installer Reference

Optional installation modes, version selection, customization conflicts, and recovery.
The commands below run from a checkout of this repository.

## Prerequisites and Checkout

Install your host app and Git first. For macOS/Linux, you also need Bash, curl,
tar, shasum, and jq. On macOS, install jq with `brew install jq` if you use Homebrew;
on Linux, install missing tools through your package manager. For Windows, use
[PowerShell 7.4+](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows).
Go is required only for source builds.

**macOS / Linux**

```sh
git clone https://github.com/TylerAkins/ai-agent-skills.git
cd ai-agent-skills
```

**Windows**

```powershell
git clone https://github.com/TylerAkins/ai-agent-skills.git
Set-Location ai-agent-skills
```

Already cloned? Open that checkout and run `git pull --ff-only` instead.

## Shared Release Archives

The installer uses the release's `SHA256SUMS` to choose its archive. Codex/Copilot
skills and plugin flavors prefer `portable`; OpenCode skills flavors prefer `skills`.
Agent-only flavors select their host archive: `codex`, `opencode`, or `claude`.
When a shared archive is absent, skills and plugin flavors select the legacy host
archive. Other hosts retain their archive selection.
Download, checksum, and archive-validation failures stop before replacement;
there is no fallback after a listed shared archive fails.

Run `git pull --ff-only` in your installer checkout before consuming consolidated
releases. Older helpers expect separate Codex, Copilot, and OpenCode archives and
must be updated or pinned to a compatible older release. Flavor names, destinations,
merge/replacement controls, and host activation steps remain the same.

## Replacement and Backups

Plugin updates replace the selected directory after confirmation and print the backup
path. Failed downloads/checksums leave the installation unchanged; a failed Codex
catalog commit restores the previous plugin. Pulling the repo gets installer fixes;
the default install/update still fetches the latest stable published release.

For existing skills-only or agents-only destinations, choose `--merge` (`-Merge`
in PowerShell) or `--replace` (`-Replace`). Merge replaces incoming skill folders
or agent files and preserves unrelated entries. Replace replaces the whole
destination, including unrelated files.
Both can replace local customizations within their scope. Use `--yes` / `-Yes` only
to confirm the selected operation without a prompt.

An ordinary install refuses an existing target without an explicit mode. Plugin
`update` selects replacement automatically; skills-only and agents-only updates
need a mode.
Backups remain in `.ai-agent-skills-backups/backup.*` beside the installation parent.
Compare or restore the printed backup, and remove it yourself when no longer useful.

## Alternate Installations

Run these from the checkout prepared above. Project directories must already
exist; replace the example paths with your own.

### Specialized agent installations

The Open Skills CLI installs skills, not these subagent definitions. Cursor and
Claude Code plugin installs already include the four agents; the Codex desktop
plugin does not.

For native installs, use an agent flavor alongside the corresponding skills flavor.
Releases with agent bundles contain four subagent definitions per supported host;
older archives may not.
Substitute `claude` or `codex` for `opencode` in the agent flavor names below.
Use `claude-project` or `codex-skills` for the corresponding project skills:

```sh
bash scripts/install-ai-agent-skills.sh --flavor opencode-agents-global
bash scripts/install-ai-agent-skills.sh --flavor opencode-agents-project --project /absolute/path/to/project
bash scripts/install-ai-agent-skills.sh update --flavor opencode-agents-global --merge
bash scripts/install-ai-agent-skills.sh update --flavor opencode-agents-project --project /absolute/path/to/project --merge
```

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor opencode-agents-global
./scripts/install-ai-agent-skills.ps1 -Flavor opencode-agents-project -Project 'C:/path/to/project'
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor opencode-agents-global -Merge
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor opencode-agents-project -Project 'C:/path/to/project' -Merge
```

| Host | Global agents | Project agents | Matching skill flavors |
| --- | --- | --- | --- |
| OpenCode v2 and connected OpenChamber | `~/.config/opencode/agents` | `.opencode/agents` | `opencode-global`, `opencode-project` |
| Claude Code | `~/.claude/agents` or `$CLAUDE_CONFIG_DIR/agents` | `.claude/agents` | `claude-global`, `claude-project` (or the `claude` plugin) |
| Codex | `~/.codex/agents` | `.codex/agents` | `codex-global`, `codex-skills` |

Agent-only installs touch only the selected `agents` directory. An existing
directory requires explicit `--merge` / `-Merge` or `--replace` / `-Replace`,
even on updates. Merge preserves unknown files but replaces the four same-named
definitions. Compare locally modified definitions before consenting. Every
replacement saves a backup. Do not use replace if the directory has unrelated
agents. Plugin updates use the existing whole-plugin replacement and backup
policy; native skills-only installs remain skills-only.

Verify agent registration in the host after installation. In the project, run
`opencode --standalone api get /api/agent`; check `@agent-` autocomplete and
the delegation trace in Claude Code, or inspect Codex agent activity after an
explicit request. For OpenChamber, use the OpenCode server's filesystem and
location, especially for remote servers.
Listing an agent establishes discovery; only a visible delegation establishes
invocation. Neither proves skill use. See
[host differences](host-compatibility.md#specialized-subagents).

<details>
<summary><strong>Codex project skills or a separate marketplace</strong></summary>

**Project skills without a marketplace**

```sh
bash scripts/install-ai-agent-skills.sh --flavor codex-skills --project /absolute/path/to/project
```

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor codex-skills -Project 'C:/path/to/project'
```

Start a new Codex session in that project and describe the task normally. To update, add
`update` before `--flavor` in Bash, or `-Action Update` in PowerShell, plus
`--merge` / `-Merge` to preserve unrelated skills.

**A separate marketplace root**

```sh
bash scripts/install-ai-agent-skills.sh --flavor codex-marketplace --marketplace-root "$HOME/codex-marketplace"
```

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor codex-marketplace -MarketplaceRoot "$env:USERPROFILE/codex-marketplace"
```

Add that full root path as a plugin marketplace source in the app, then install
its plugin. Update with the same root using `update` / `-Action Update`, confirm
replacement, and refresh/reinstall the host's cached plugin if needed.

</details>

<details>
<summary><strong>Native global skill directories for Cursor, Codex, and Claude Code</strong></summary>

These flavors install only canonical skills to each host's own discovery path. They
do not install a plugin or change host instructions/settings.

**Bash**

```sh
bash scripts/install-ai-agent-skills.sh --flavor cursor-global
bash scripts/install-ai-agent-skills.sh --flavor codex-global
bash scripts/install-ai-agent-skills.sh --flavor claude-global
bash scripts/install-ai-agent-skills.sh --flavor claude-project --project /absolute/path/to/project
```

**PowerShell**

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor cursor-global
./scripts/install-ai-agent-skills.ps1 -Flavor codex-global
./scripts/install-ai-agent-skills.ps1 -Flavor claude-global
./scripts/install-ai-agent-skills.ps1 -Flavor claude-project -Project 'C:/path/to/project'
```

Cursor uses `~/.cursor/skills`, Codex uses `~/.agents/skills`, and Claude Code
uses `~/.claude/skills` or the project's `.claude/skills`. Claude's global flavor
honors an absolute `CLAUDE_CONFIG_DIR` when set. Codex's global directory is shared with other
compatible agents. To update any flavor, use `update` /
`-Action Update` and `--merge` / `-Merge` with the same target. Start a new session
or reload skills according to the host's current instructions.

</details>

<details>
<summary><strong>OpenCode in one project</strong></summary>

```sh
bash scripts/install-ai-agent-skills.sh --flavor opencode-project --project /absolute/path/to/project
```

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor opencode-project -Project 'C:/path/to/project'
```

Start a new OpenCode session in that project and describe the task normally. To update, add
`update` / `-Action Update` and `--merge` / `-Merge` to the same command.

</details>

<details>
<summary><strong>Gemini CLI or Muse Code in one project</strong></summary>

```sh
bash scripts/install-ai-agent-skills.sh --flavor gemini-project --project /absolute/path/to/project
bash scripts/install-ai-agent-skills.sh --flavor muse-project --project /absolute/path/to/project
```

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor gemini-project -Project 'C:/path/to/project'
./scripts/install-ai-agent-skills.ps1 -Flavor muse-project -Project 'C:/path/to/project'
```

Choose the command for your host. To update, use `update` / `-Action Update` and
`--merge` / `-Merge` with the same project path. Gemini uses `.gemini/skills`;
Muse uses `.agents/skills`, which is also read by other compatible agents.
Muse and Codex project flavors share a destination; use explicit merge when one
is already installed rather than trying a second ordinary install.

In Gemini CLI, run `/skills reload` and `/skills list`. In Muse Code, reload with
`/skills reload` and check `muse skills list --source project` in a workspace you
have trusted through the host's prompt. The installer does not grant workspace
trust. See [Gemini skill management](https://geminicli.com/docs/cli/using-agent-skills/)
and [Muse skill discovery](https://meta-models.github.io/muse-code-sdk/next/guides/extend/skills/).

Both hosts use the `ai-agent-skills-skills` release archive. Releases predating
this archive cannot supply these flavors. Use a release containing it, explicit
source mode after the change reaches remote `main`, or manual installation from
a local checkout. Global flavors and their activation
steps are in the [README](../README.md#install).

</details>

<details>
<summary><strong>Google Antigravity in one project</strong></summary>

```sh
bash scripts/install-ai-agent-skills.sh --flavor antigravity-project --project /absolute/path/to/project
```

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor antigravity-project -Project 'C:/path/to/project'
```

The app, standalone IDE, and CLI discover project skills in `.agents/skills`.
This shares a destination with Codex and Muse project flavors. For an existing
installation, use explicit `--merge` / `-Merge`; for updates, also use `update` /
`-Action Update`. Start a new Antigravity session and describe the task normally;
the agent selects matching skills when relevant.
See [Antigravity skills](https://antigravity.google/docs/skills).

Global installation differs by surface: `antigravity-global` targets the app/IDE,
while `antigravity-cli-global` targets the CLI. See the
[README](../README.md#antigravity) for global install and update commands.
All Antigravity flavors use the shared `ai-agent-skills-skills` archive and need
a release containing it. Use manual installation for an unpublished local checkout.

</details>

<details>
<summary><strong>GitHub Copilot project skills</strong></summary>

```sh
bash scripts/install-ai-agent-skills.sh --flavor copilot-skills --project /absolute/path/to/project
```

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor copilot-skills -Project 'C:/path/to/project'
```

The project must exist. Skills are copied into `.github/skills` for that repository.
For updates, add `update` / `-Action Update` and `--merge` / `-Merge`. Open the
project in the Copilot app, start a new session, and check **Customize > Skills**.
For use across projects, choose `copilot-global`, which installs to
`~/.copilot/skills`. Personal skills are local; the cloud agent needs skills in
its repository. See [Copilot skills](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/add-skills).

</details>

<details>
<summary><strong>Copilot plugin staging</strong></summary>

```sh
bash scripts/install-ai-agent-skills.sh --flavor copilot-staging
```

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor copilot-staging
```

This prepares files only. Copilot requires a configured marketplace under
**Customize > Plugins**; this collection does not provide one yet. See
[Copilot plugins](https://docs.github.com/en/copilot/concepts/agents/about-plugins).
To refresh staged files, use `update` / `-Action Update` and confirm replacement.

</details>

## Options and Destinations

PowerShell options mirror the Bash controls: `-Version`, `-FromSource`, `-Ref`,
`-Project`, `-MarketplaceRoot`, `-Replace`, `-Merge`, `-Yes`, and `-DryRun`.
Use `-Flavor list` to list choices. `-HomeDirectory` redirects user-level files
for isolated staging/testing; hosts will not automatically discover that alternate
profile's personal marketplace.

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor cursor -Version v1.0.1
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor cursor -DryRun
```

Default installs use the latest stable published release, excluding drafts.
An older checkout can download a newer release; pull the repo for installer fixes.

```sh
bash scripts/install-ai-agent-skills.sh --flavor list
bash scripts/install-ai-agent-skills.sh --flavor cursor --version v1.0.1
bash scripts/install-ai-agent-skills.sh --flavor cursor --dry-run
```

Choose a published tag for `--version`. Dry runs make no downloads or writes,
but existing targets still need the appropriate update/mode. Without a flavor,
an interactive terminal lists the choices and asks you to select one.

| Flavor | Destination |
| --- | --- |
| `cursor` | `~/.cursor/plugins/local/ai-agent-skills` |
| `cursor-global` | `~/.cursor/skills` |
| `codex-desktop` | `~/.codex/plugins/ai-agent-skills` |
| `codex-marketplace` | `$ROOT/plugins/ai-agent-skills` |
| `codex-global` | `~/.agents/skills` |
| `codex-agents-global` | `~/.codex/agents` |
| `codex-agents-project` | `$PROJECT/.codex/agents` |
| `claude` | `~/.local/share/ai-agent-skills/claude` |
| `claude-global` | `~/.claude/skills` or `$CLAUDE_CONFIG_DIR/skills` |
| `claude-project` | `$PROJECT/.claude/skills` |
| `claude-agents-global` | `~/.claude/agents` or `$CLAUDE_CONFIG_DIR/agents` |
| `claude-agents-project` | `$PROJECT/.claude/agents` |
| `copilot-staging` | `~/.local/share/ai-agent-skills/copilot` |
| `copilot-skills` | `$PROJECT/.github/skills` |
| `copilot-global` | `~/.copilot/skills` |
| `codex-skills` | `$PROJECT/.agents/skills` |
| `opencode-project` | `$PROJECT/.opencode/skills` |
| `opencode-global` | `~/.config/opencode/skills` |
| `opencode-agents-global` | `~/.config/opencode/agents` |
| `opencode-agents-project` | `$PROJECT/.opencode/agents` |
| `gemini-project` | `$PROJECT/.gemini/skills` |
| `gemini-global` | `~/.gemini/skills` |
| `muse-project` | `$PROJECT/.agents/skills` |
| `muse-global` | `~/.agents/skills` |
| `antigravity-project` | `$PROJECT/.agents/skills` |
| `antigravity-global` | `~/.gemini/config/skills` (app/IDE) |
| `antigravity-cli-global` | `~/.gemini/antigravity-cli/skills` (CLI) |
| `list` | No installation |

Project paths must exist and be absolute; marketplace roots must be absolute.
Symlink destinations/parents are refused; Windows also rejects junctions. Use physical paths.
Codex desktop uses `~/.agents/plugins/marketplace.json`; custom marketplaces use
`$ROOT/.agents/plugins/marketplace.json`. Neither flavor registers the CLI marketplace
or edits Codex configuration.

Downloads are verified against release SHA256SUMS before extraction. Those checksums
come from the same release source, not signed provenance. File installation does
not establish that the host loaded or followed a skill.

## Source Builds and Manual Installation

Source mode requires Git and stable Go >= 1.27.1. It clones the selected release tag
temporarily and uses the Go packager. Unreleased main must be selected explicitly:

**Windows**

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor cursor -FromSource -Version v1.0.1
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor cursor -FromSource -Ref main
```

**macOS / Linux**

```sh
bash scripts/install-ai-agent-skills.sh --flavor cursor --from-source --version v1.0.1
bash scripts/install-ai-agent-skills.sh update --flavor cursor --from-source --ref main
```

Automatic toolchain downloads are disabled. Missing/old Go produces an install hint.
Use the same project and replacement controls. See [packaging reference](plugins.md)
for maintainer builds.

For manual skills installation on any platform, copy
all folders inside this checkout's `skills/` to your project's skills directory:

| Host | Project directory |
| --- | --- |
| Cursor or Codex | `.agents/skills/` |
| Cursor | `.cursor/skills/` |
| Claude Code | `.claude/skills/` |
| Copilot | `.github/skills/` |
| OpenCode | `.opencode/skills/` |
| Gemini CLI | `.gemini/skills/` |
| Muse Code | `.agents/skills/` |
| Antigravity app, IDE, or CLI | `.agents/skills/` |

Keep sibling skills and supporting resources together, compare conflicts, and do
not copy the repository's `AGENTS.md` as installation instructions. Manual copies
use checkout content, do not sync updates, and omit plugin-specific rules/agents.
See [Cursor skills](https://cursor.com/docs/skills) and
[Codex skill locations](https://developers.openai.com/codex/skills/).

## Troubleshooting and Uninstall

| Problem | What to do |
| --- | --- |
| PowerShell version is too old | Open PowerShell 7.4+ (`pwsh`), rather than Windows PowerShell 5.1. |
| Windows execution policy blocks the script | Check your device/organization policy. The helper does not change execution policy. |
| jq is missing | Install it, for example with `brew install jq` on Mac, then retry. |
| Destination exists | Use `update`; skills-only flavors also need `--merge` or `--replace`. |
| Cursor plugin is missing | Reload and check local-import policy or marketplace precedence. |
| Old skills are still loaded | Refresh/reinstall the cached plugin, reopen the app, and start a new session. |
| Download fails | Check connectivity, rate limits, and published assets. Try a known `--version`. |
| Invalid marketplace JSON | Repair/restore it; the helper refuses to replace an invalid catalog. |
| Duplicate skills appear | Choose one active source; compare customized copies before retiring them. |

Configure authenticated Jira/GitHub connections separately. The helper does not
publish listings or create a Copilot marketplace.

To uninstall, disable/uninstall the host plugin, then remove only its destination
from the table. For Codex, also remove its `ai-agent-skills` marketplace entry while
preserving other plugins. For merged skills, remove only this collection's folders;
deleting the whole skills directory would delete unrelated skills too.
