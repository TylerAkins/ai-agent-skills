# Install and Update

Install each host separately using published release bundles. Use the Bash helper on macOS/Linux or the PowerShell helper on Windows.
Go and the GitHub CLI are not required for release installs.

[Cursor](#cursor) | [Codex](#codex) | [Claude Code](#claude-code) ·
[Copilot](#github-copilot) | [OpenCode](#opencode) | [Updates](#update)

## Get the Installer

### macOS and Linux

You need Git, Bash, curl, tar, shasum, and jq. macOS includes Bash, curl, tar,
and shasum. Install Git if missing; with Homebrew, use `brew install jq` for jq.
On Linux, install missing tools through your package manager.

Open Terminal in the folder where you want to keep the checkout:

```sh
git clone https://github.com/TylerAkins/ai-agent-skills.git
cd ai-agent-skills
```

Already cloned? Open that checkout and run `git pull --ff-only`.
Run the commands below from the checkout. The helper does not install host apps
or dependencies. For a project path, supply an existing absolute directory.

### Windows

Install [PowerShell 7.4 or newer](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows) and Git.
Open PowerShell 7, then obtain the checkout:

```powershell
git clone https://github.com/TylerAkins/ai-agent-skills.git
Set-Location ai-agent-skills
```

If already cloned, open that checkout and run `git pull --ff-only`.
The Windows helper uses built-in HTTPS, JSON, SHA-256, and archive support.
Windows PowerShell 5.1 is not supported. Bash, jq, and Go are not needed.

Choose one command below, then follow the matching host's activation instructions:

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor cursor
./scripts/install-ai-agent-skills.ps1 -Flavor codex-desktop
./scripts/install-ai-agent-skills.ps1 -Flavor codex-marketplace -MarketplaceRoot "$env:USERPROFILE/codex-marketplace"
./scripts/install-ai-agent-skills.ps1 -Flavor claude
./scripts/install-ai-agent-skills.ps1 -Flavor copilot-staging
./scripts/install-ai-agent-skills.ps1 -Flavor copilot-skills -Project 'C:/path/to/project'
./scripts/install-ai-agent-skills.ps1 -Flavor codex-skills -Project 'C:/path/to/project'
./scripts/install-ai-agent-skills.ps1 -Flavor opencode-project -Project 'C:/path/to/project'
./scripts/install-ai-agent-skills.ps1 -Flavor opencode-global
```

Project paths must exist. The same destination table applies on Windows, where
`~` means your user-profile folder. These commands do not install the host apps
or activate plugins automatically. The remaining Bash command examples are for
macOS/Linux; Windows uses the PowerShell flavor commands above.

## Cursor

```sh
bash scripts/install-ai-agent-skills.sh --flavor cursor
```

In Cursor, run **Developer: Reload Window** from the Command Palette
(`Cmd+Shift+P` on Mac or `Ctrl+Shift+P` on Windows). Open **Customize** and check for the plugin, skills,
routing rule, and reviewer. Start a new Agent chat and select `/agent-planning`.

Local imports must be allowed by your account/team policy. A marketplace plugin
with the same name can take precedence. See [Cursor plugin loading](https://cursor.com/docs/plugins).

## Codex

```sh
bash scripts/install-ai-agent-skills.sh --flavor codex-desktop
```

Quit and reopen ChatGPT/Codex. Open **Plugins**, choose your personal marketplace,
and install **ai-agent-skills**. Start a new chat and request `agent-planning`.
The helper prepares the plugin and merges its entry into the personal marketplace;
you complete activation in the app. Other plugins and the marketplace name are retained.

For a separate marketplace root:

```sh
bash scripts/install-ai-agent-skills.sh --flavor codex-marketplace --marketplace-root "$HOME/codex-marketplace"
```

In the app, add that full root path as a plugin marketplace source, then install
its plugin. See [OpenAI local marketplaces](https://developers.openai.com/plugins/build/plugins).

For project skills without a marketplace:

```sh
bash scripts/install-ai-agent-skills.sh --flavor codex-skills --project /absolute/path/to/project
```

Start a new Codex session in that project and select or request a skill.

## Claude Code

```sh
bash scripts/install-ai-agent-skills.sh --flavor claude
claude --plugin-dir "$HOME/.local/share/ai-agent-skills/claude"
```

Invoke `/ai-agent-skills:agent-planning` in that session. No shell aliases or
marketplace activation are configured. See [Claude plugins](https://code.claude.com/docs/en/plugins).

## GitHub Copilot

For project skills available in the new Copilot app:

```sh
bash scripts/install-ai-agent-skills.sh --flavor copilot-skills --project /absolute/path/to/project
```

Open the project, start a new session, and inspect **Customize > Skills**.
See [Copilot app customization](https://docs.github.com/en/copilot/how-tos/github-copilot-app/customize-github-copilot-app).

To stage a portable plugin for a later marketplace setup:

```sh
bash scripts/install-ai-agent-skills.sh --flavor copilot-staging
```

Staging does not activate the plugin. Copilot requires a configured marketplace
under **Customize > Plugins**; this collection does not provide it yet.
See [Copilot plugins](https://docs.github.com/en/copilot/concepts/agents/about-plugins).

## OpenCode

Choose project installation or installation across your projects:

```sh
bash scripts/install-ai-agent-skills.sh --flavor opencode-project --project /absolute/path/to/project
```

```sh
bash scripts/install-ai-agent-skills.sh --flavor opencode-global
```

Start a new session and ask OpenCode to use `agent-planning`. These install skills,
not an OpenCode runtime plugin. See [OpenCode skills](https://opencode.ai/docs/skills/).

## Update

On Windows, from the checkout:

```powershell
git pull --ff-only
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor cursor
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor codex-desktop
```

Choose the command for your installed host. For existing project skills, specify
`-Merge` or `-Replace`, for example:

```powershell
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor codex-skills -Project 'C:/path/to/project' -Merge
```

On macOS/Linux:

From the checkout, pull installer changes and update the same flavor:

```sh
git pull --ff-only
bash scripts/install-ai-agent-skills.sh update --flavor cursor
```

For Codex desktop, use:

```sh
bash scripts/install-ai-agent-skills.sh update --flavor codex-desktop
```

Confirm replacement and reload/reopen the host. Check the loaded version and start
a new session. If Codex still uses an old cached copy, refresh/reinstall the plugin.

Plugin updates replace the selected directory and print a backup path. Failed
downloads/checksums leave it unchanged; a failed catalog commit restores the plugin.
Existing skills-only destinations require an explicit choice:

```sh
bash scripts/install-ai-agent-skills.sh update --flavor codex-skills --project /absolute/path/to/project --merge
```

- `--merge` replaces incoming skill folders but preserves unknown folders.
- `--replace` replaces the entire destination, including unrelated skills.

Both can replace local customizations within their scope. Use `--yes` only to
confirm your selected operation without a prompt. An ordinary install refuses an
existing target without a mode; plugin `update` selects replacement automatically.

Backups remain in `.ai-agent-skills-backups/backup.*` beside the installation
parent. Compare or restore the printed backup if needed, and remove it yourself
when no longer useful.

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
| `codex-desktop` | `~/.codex/plugins/ai-agent-skills` |
| `codex-marketplace` | `$ROOT/plugins/ai-agent-skills` |
| `claude` | `~/.local/share/ai-agent-skills/claude` |
| `copilot-staging` | `~/.local/share/ai-agent-skills/copilot` |
| `copilot-skills` | `$PROJECT/.github/skills` |
| `codex-skills` | `$PROJECT/.agents/skills` |
| `opencode-project` | `$PROJECT/.opencode/skills` |
| `opencode-global` | `~/.config/opencode/skills` |
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

On Windows:

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor cursor -FromSource -Version v1.0.1
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor cursor -FromSource -Ref main
```

The following Bash examples are for macOS/Linux:

Source mode requires Git and stable Go >= 1.27.1. It clones the selected release tag
temporarily and uses the Go packager. Unreleased main must be selected explicitly:

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
| Copilot | `.github/skills/` |
| OpenCode | `.opencode/skills/` |

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
