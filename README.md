# ai-agent-skills

**Shared engineering workflows for the coding agent you use.**

[![Collection validation](https://github.com/TylerAkins/ai-agent-skills/actions/workflows/validate.yml/badge.svg)](https://github.com/TylerAkins/ai-agent-skills/actions/workflows/validate.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

Plan a change, investigate a failure, review code, or prepare a pull request.
These 23 skills give AI coding agents concrete procedures for checking their work
and respecting the actions you authorized.

[Install](#install) · [Use the skills](#use-the-skills) · [Browse workflows](#browse-the-skills) · [Documentation](#documentation)

```text
Use agent-planning to plan this feature. Do not implement it yet.
Use root-cause-debug to reproduce and fix this failure.
Use code-review to review my changes against main without editing files.
```

## Install

| Choose a method | What you get |
| --- | --- |
| [Open Skills CLI](#open-skills-cli) | Select skills for a supported host, locally or globally. |
| [Native shell installer](#native-shell-installer) | Explicit host destinations, plugins, and optional native subagents. |
| [Manual copy](docs/installer-reference.md#source-builds-and-manual-installation) | Skills from your local checkout, including unpublished changes. |

Install your coding host first. The collection provides instructions and supporting
resources, not a model or authenticated service connections. Choose one active
installation per host to avoid duplicate skills.

### Open Skills CLI

Requires Node.js 22.20+, npm, and Git. Run from the project where you want skills:

```sh
npx skills add TylerAkins/ai-agent-skills
```

Choose your host and skills interactively. Add `-g` for a user-wide installation,
or `--skill test-authoring` to select one skill. Inspect available skills with
`npx skills add TylerAkins/ai-agent-skills --list`.

Start a new host session if the skills do not appear, then try one of the requests
above. To update, run the command for your original scope:

```sh
# Project installation
npx skills update -p
# Global installation
npx skills update -g
```

These commands update installed skills in the selected scope, including skills
from other sources. To add newly introduced skills, run `skills add` again.
The [CLI](https://github.com/vercel-labs/skills) installs skills and supporting
resources; it does not install this collection's optional subagent definitions.

### Native shell installer

**Prepare once.** Install Git. On macOS/Linux, use Bash with curl, tar, shasum, and
jq. On Windows, use PowerShell 7.4+; Go, Bash, and jq are not needed for release
installs. Clone the installer and run subsequent commands from that checkout:

```sh
git clone https://github.com/TylerAkins/ai-agent-skills.git
cd ai-agent-skills
```

In PowerShell, use `Set-Location ai-agent-skills` for the second command.
Default installs download the latest published release, not this checkout's
unpublished edits. [Manual copy and source builds](docs/installer-reference.md#source-builds-and-manual-installation)
explain the alternatives.

**Choose a flavor below.** Each section contains install, activation, and update
steps. Project paths must already exist; replace `/absolute/path/to/project` or
`C:/path/to/project` with your actual path. For `codex-marketplace`, choose an
absolute marketplace root instead.

**Before updating**, run `git pull --ff-only` in the installer checkout. Update
skills and agents with merge to preserve unrelated names. Incoming names replace
matching local copies, so compare customizations first. Plugin updates replace
the whole selected plugin. Replacements keep backups; see [conflicts and recovery](docs/installer-reference.md#updates-and-customizations).
If a first install finds an existing shared directory, explicitly choose merge
for skills/agents or inspect the conflict before proceeding.

[Skills and plugins](#skills-and-plugins) · [Optional subagents](#optional-subagents) · [Plugin staging](#plugin-staging)

#### Skills and plugins

<details>
<summary>Antigravity app/IDE: global skills (<code>antigravity-global</code>)</summary>

Destination: `~/.gemini/config/skills`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor antigravity-global
# Update
bash scripts/install-ai-agent-skills.sh update --flavor antigravity-global --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor antigravity-global
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor antigravity-global -Merge
```

**Activate and verify:** Start a new session in the matching app, IDE, or CLI. In the app/IDE, inspect skills in **Customizations**; in the CLI, use `/skills reload` and invoke `/code-review`.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Antigravity CLI: global skills (<code>antigravity-cli-global</code>)</summary>

Destination: `~/.gemini/antigravity-cli/skills`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor antigravity-cli-global
# Update
bash scripts/install-ai-agent-skills.sh update --flavor antigravity-cli-global --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor antigravity-cli-global
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor antigravity-cli-global -Merge
```

**Activate and verify:** Start a new session in the matching app, IDE, or CLI. In the app/IDE, inspect skills in **Customizations**; in the CLI, use `/skills reload` and invoke `/code-review`.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Antigravity: project skills (<code>antigravity-project</code>)</summary>

Destination: `$PROJECT/.agents/skills`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor antigravity-project --project /absolute/path/to/project
# Update
bash scripts/install-ai-agent-skills.sh update --flavor antigravity-project --project /absolute/path/to/project --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor antigravity-project -Project 'C:/path/to/project'
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor antigravity-project -Project 'C:/path/to/project' -Merge
```

**Activate and verify:** Start a new session in the matching app, IDE, or CLI. In the app/IDE, inspect skills in **Customizations**; in the CLI, use `/skills reload` and invoke `/code-review`.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Claude Code: plugin (<code>claude</code>)</summary>

Destination: `~/.local/share/ai-agent-skills/claude`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor claude
# Update
bash scripts/install-ai-agent-skills.sh update --flavor claude
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor claude
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor claude
```

**Activate and verify:** Launch each session with `claude --plugin-dir "$HOME/.local/share/ai-agent-skills/claude"` in Bash or `claude --plugin-dir "$env:USERPROFILE/.local/share/ai-agent-skills/claude"` in PowerShell. Confirm `/ai-agent-skills:code-review` is available.

After updating, repeat activation and refresh/reinstall the plugin if its cached copy is stale.

</details>

<details>
<summary>Claude Code: global skills (<code>claude-global</code>)</summary>

Destination: `~/.claude/skills` (or `$CLAUDE_CONFIG_DIR/skills`).

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor claude-global
# Update
bash scripts/install-ai-agent-skills.sh update --flavor claude-global --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor claude-global
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor claude-global -Merge
```

**Activate and verify:** Start a new Claude Code session in the relevant project and invoke `/code-review`. Global native installs honor an absolute `CLAUDE_CONFIG_DIR` when set.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Claude Code: project skills (<code>claude-project</code>)</summary>

Destination: `$PROJECT/.claude/skills`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor claude-project --project /absolute/path/to/project
# Update
bash scripts/install-ai-agent-skills.sh update --flavor claude-project --project /absolute/path/to/project --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor claude-project -Project 'C:/path/to/project'
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor claude-project -Project 'C:/path/to/project' -Merge
```

**Activate and verify:** Start a new Claude Code session in the relevant project and invoke `/code-review`. Global native installs honor an absolute `CLAUDE_CONFIG_DIR` when set.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Codex desktop: personal plugin (<code>codex-desktop</code>)</summary>

Destination: `~/.codex/plugins/ai-agent-skills`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor codex-desktop
# Update
bash scripts/install-ai-agent-skills.sh update --flavor codex-desktop
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor codex-desktop
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor codex-desktop
```

**Activate and verify:** Quit and reopen the desktop app. In **Plugins**, select the personal marketplace and install `ai-agent-skills`. Confirm its skills are available; no CLI marketplace is registered.

After updating, repeat activation and refresh/reinstall the plugin if its cached copy is stale.

</details>

<details>
<summary>Codex desktop: separate marketplace (<code>codex-marketplace</code>)</summary>

Destination: `$MARKETPLACE_ROOT/plugins/ai-agent-skills`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor codex-marketplace --marketplace-root "$HOME/ai-agent-marketplace"
# Update
bash scripts/install-ai-agent-skills.sh update --flavor codex-marketplace --marketplace-root "$HOME/ai-agent-marketplace"
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor codex-marketplace -MarketplaceRoot "$env:USERPROFILE/ai-agent-marketplace"
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor codex-marketplace -MarketplaceRoot "$env:USERPROFILE/ai-agent-marketplace"
```

**Activate and verify:** Add the full marketplace root shown by the installer as a plugin marketplace source in the desktop app, then install `ai-agent-skills` and check its skills. No CLI marketplace is registered.

After updating, repeat activation and refresh/reinstall the plugin if its cached copy is stale.

</details>

<details>
<summary>Codex: global skills (<code>codex-global</code>)</summary>

Destination: `~/.agents/skills`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor codex-global
# Update
bash scripts/install-ai-agent-skills.sh update --flavor codex-global --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor codex-global
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor codex-global -Merge
```

**Activate and verify:** Start a new Codex session in the relevant project. Run `/skills` or use `$code-review` to confirm discovery.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Codex: project skills (<code>codex-skills</code>)</summary>

Destination: `$PROJECT/.agents/skills`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor codex-skills --project /absolute/path/to/project
# Update
bash scripts/install-ai-agent-skills.sh update --flavor codex-skills --project /absolute/path/to/project --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor codex-skills -Project 'C:/path/to/project'
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor codex-skills -Project 'C:/path/to/project' -Merge
```

**Activate and verify:** Start a new Codex session in the relevant project. Run `/skills` or use `$code-review` to confirm discovery.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>GitHub Copilot: personal skills (<code>copilot-global</code>)</summary>

Destination: `~/.copilot/skills`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor copilot-global
# Update
bash scripts/install-ai-agent-skills.sh update --flavor copilot-global --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor copilot-global
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor copilot-global -Merge
```

**Activate and verify:** Open the target project in your Copilot host and start a new session. Request `code-review` and inspect skill activity. Cloud agents need repository-hosted skills; local personal files do not reach them automatically.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>GitHub Copilot: project skills (<code>copilot-skills</code>)</summary>

Destination: `$PROJECT/.github/skills`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor copilot-skills --project /absolute/path/to/project
# Update
bash scripts/install-ai-agent-skills.sh update --flavor copilot-skills --project /absolute/path/to/project --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor copilot-skills -Project 'C:/path/to/project'
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor copilot-skills -Project 'C:/path/to/project' -Merge
```

**Activate and verify:** Open the target project in your Copilot host and start a new session. Request `code-review` and inspect skill activity. Cloud agents need repository-hosted skills; local personal files do not reach them automatically.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Cursor: plugin (<code>cursor</code>)</summary>

Destination: `~/.cursor/plugins/local/ai-agent-skills`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor cursor
# Update
bash scripts/install-ai-agent-skills.sh update --flavor cursor
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor cursor
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor cursor
```

**Activate and verify:** Reload the window and check **Customize** for the plugin, skills, routing rule, and agents. Local plugin imports must be allowed by your account/team. CLI sessions can use `agent --plugin-dir "$HOME/.cursor/plugins/local/ai-agent-skills"` (PowerShell: replace `$HOME` with `$env:USERPROFILE`).

After updating, repeat activation and refresh/reinstall the plugin if its cached copy is stale.

</details>

<details>
<summary>Cursor: global skills (<code>cursor-global</code>)</summary>

Destination: `~/.cursor/skills`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor cursor-global
# Update
bash scripts/install-ai-agent-skills.sh update --flavor cursor-global --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor cursor-global
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor cursor-global -Merge
```

**Activate and verify:** Start a new session and check **Customize > Skills**. Request `code-review` and inspect skill activity.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Gemini CLI: global skills (<code>gemini-global</code>)</summary>

Destination: `~/.gemini/skills`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor gemini-global
# Update
bash scripts/install-ai-agent-skills.sh update --flavor gemini-global --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor gemini-global
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor gemini-global -Merge
```

**Activate and verify:** Run `/skills reload` and `/skills list` in Gemini CLI. Request `code-review`; approve access to the skill directory when prompted.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Gemini CLI: project skills (<code>gemini-project</code>)</summary>

Destination: `$PROJECT/.gemini/skills`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor gemini-project --project /absolute/path/to/project
# Update
bash scripts/install-ai-agent-skills.sh update --flavor gemini-project --project /absolute/path/to/project --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor gemini-project -Project 'C:/path/to/project'
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor gemini-project -Project 'C:/path/to/project' -Merge
```

**Activate and verify:** Run `/skills reload` and `/skills list` in Gemini CLI. Request `code-review`; approve access to the skill directory when prompted.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Muse Code: global skills (<code>muse-global</code>)</summary>

Destination: `~/.agents/skills`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor muse-global
# Update
bash scripts/install-ai-agent-skills.sh update --flavor muse-global --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor muse-global
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor muse-global -Merge
```

**Activate and verify:** Run `/skills reload`, then `muse skills list`. Project skills require a trusted workspace; the installer does not grant that trust.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Muse Code: project skills (<code>muse-project</code>)</summary>

Destination: `$PROJECT/.agents/skills`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor muse-project --project /absolute/path/to/project
# Update
bash scripts/install-ai-agent-skills.sh update --flavor muse-project --project /absolute/path/to/project --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor muse-project -Project 'C:/path/to/project'
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor muse-project -Project 'C:/path/to/project' -Merge
```

**Activate and verify:** Run `/skills reload`, then `muse skills list`. Project skills require a trusted workspace; the installer does not grant that trust.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>OpenCode: global skills (<code>opencode-global</code>)</summary>

Destination: `~/.config/opencode/skills`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor opencode-global
# Update
bash scripts/install-ai-agent-skills.sh update --flavor opencode-global --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor opencode-global
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor opencode-global -Merge
```

**Activate and verify:** Start a new OpenCode session in the relevant project. Request `code-review` and inspect the `skill` tool activity.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>OpenCode: project skills (<code>opencode-project</code>)</summary>

Destination: `$PROJECT/.opencode/skills`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor opencode-project --project /absolute/path/to/project
# Update
bash scripts/install-ai-agent-skills.sh update --flavor opencode-project --project /absolute/path/to/project --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor opencode-project -Project 'C:/path/to/project'
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor opencode-project -Project 'C:/path/to/project' -Merge
```

**Activate and verify:** Start a new OpenCode session in the relevant project. Request `code-review` and inspect the `skill` tool activity.

After updating, repeat the discovery check in a fresh session.

</details>

#### Optional subagents

Four investigation agents are available: `independent-reviewer`,
`root-cause-investigator`, `dependency-investigator`, and `architecture-advisor`.
Native agent flavors install agent definitions only; install matching skills
separately. The Claude and Cursor plugins already include the agents. The Codex
desktop plugin does not. See [host capabilities and read-only limits](docs/host-compatibility.md#specialized-subagents).

<details>
<summary>Antigravity: global agents (<code>antigravity-agents-global</code>)</summary>

Destination: `~/.gemini/config/agents`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor antigravity-agents-global
# Update
bash scripts/install-ai-agent-skills.sh update --flavor antigravity-agents-global --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor antigravity-agents-global
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor antigravity-agents-global -Merge
```

**Activate and verify:** Open `/agents` in Antigravity and find `independent-reviewer`. Install the matching skill flavor separately; listing an agent confirms discovery, not delegation.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Antigravity: project agents (<code>antigravity-agents-project</code>)</summary>

Destination: `$PROJECT/.agents/agents`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor antigravity-agents-project --project /absolute/path/to/project
# Update
bash scripts/install-ai-agent-skills.sh update --flavor antigravity-agents-project --project /absolute/path/to/project --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor antigravity-agents-project -Project 'C:/path/to/project'
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor antigravity-agents-project -Project 'C:/path/to/project' -Merge
```

**Activate and verify:** Open `/agents` in Antigravity and find `independent-reviewer`. Install the matching skill flavor separately; listing an agent confirms discovery, not delegation.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Claude Code: global agents (<code>claude-agents-global</code>)</summary>

Destination: `~/.claude/agents` (or `$CLAUDE_CONFIG_DIR/agents`).

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor claude-agents-global
# Update
bash scripts/install-ai-agent-skills.sh update --flavor claude-agents-global --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor claude-agents-global
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor claude-agents-global -Merge
```

**Activate and verify:** Start a new Claude Code session and check `@agent-` autocomplete for `independent-reviewer`. Install the matching skill flavor separately; listing an agent confirms discovery, not delegation.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Claude Code: project agents (<code>claude-agents-project</code>)</summary>

Destination: `$PROJECT/.claude/agents`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor claude-agents-project --project /absolute/path/to/project
# Update
bash scripts/install-ai-agent-skills.sh update --flavor claude-agents-project --project /absolute/path/to/project --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor claude-agents-project -Project 'C:/path/to/project'
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor claude-agents-project -Project 'C:/path/to/project' -Merge
```

**Activate and verify:** Start a new Claude Code session and check `@agent-` autocomplete for `independent-reviewer`. Install the matching skill flavor separately; listing an agent confirms discovery, not delegation.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Codex: global agents (<code>codex-agents-global</code>)</summary>

Destination: `~/.codex/agents`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor codex-agents-global
# Update
bash scripts/install-ai-agent-skills.sh update --flavor codex-agents-global --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor codex-agents-global
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor codex-agents-global -Merge
```

**Activate and verify:** Start a new Codex session and explicitly request `independent-reviewer`; inspect the agent activity. Install the matching skill flavor separately; listing an agent confirms discovery, not delegation.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Codex: project agents (<code>codex-agents-project</code>)</summary>

Destination: `$PROJECT/.codex/agents`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor codex-agents-project --project /absolute/path/to/project
# Update
bash scripts/install-ai-agent-skills.sh update --flavor codex-agents-project --project /absolute/path/to/project --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor codex-agents-project -Project 'C:/path/to/project'
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor codex-agents-project -Project 'C:/path/to/project' -Merge
```

**Activate and verify:** Start a new Codex session and explicitly request `independent-reviewer`; inspect the agent activity. Install the matching skill flavor separately; listing an agent confirms discovery, not delegation.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>GitHub Copilot: global agents (<code>copilot-agents-global</code>)</summary>

Destination: `~/.copilot/agents`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor copilot-agents-global
# Update
bash scripts/install-ai-agent-skills.sh update --flavor copilot-agents-global --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor copilot-agents-global
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor copilot-agents-global -Merge
```

**Activate and verify:** Select `independent-reviewer` in the host agent picker or request delegation to it. Install the matching skill flavor separately; listing an agent confirms discovery, not delegation.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>GitHub Copilot: project agents (<code>copilot-agents-project</code>)</summary>

Destination: `$PROJECT/.github/agents`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor copilot-agents-project --project /absolute/path/to/project
# Update
bash scripts/install-ai-agent-skills.sh update --flavor copilot-agents-project --project /absolute/path/to/project --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor copilot-agents-project -Project 'C:/path/to/project'
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor copilot-agents-project -Project 'C:/path/to/project' -Merge
```

**Activate and verify:** Select `independent-reviewer` in the host agent picker or request delegation to it. Install the matching skill flavor separately; listing an agent confirms discovery, not delegation.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Cursor: global agents (<code>cursor-agents-global</code>)</summary>

Destination: `~/.cursor/agents`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor cursor-agents-global
# Update
bash scripts/install-ai-agent-skills.sh update --flavor cursor-agents-global --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor cursor-agents-global
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor cursor-agents-global -Merge
```

**Activate and verify:** Start a new session and look for `independent-reviewer` in the subagent tools. Install the matching skill flavor separately; listing an agent confirms discovery, not delegation.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Cursor: project agents (<code>cursor-agents-project</code>)</summary>

Destination: `$PROJECT/.cursor/agents`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor cursor-agents-project --project /absolute/path/to/project
# Update
bash scripts/install-ai-agent-skills.sh update --flavor cursor-agents-project --project /absolute/path/to/project --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor cursor-agents-project -Project 'C:/path/to/project'
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor cursor-agents-project -Project 'C:/path/to/project' -Merge
```

**Activate and verify:** Start a new session and look for `independent-reviewer` in the subagent tools. Install the matching skill flavor separately; listing an agent confirms discovery, not delegation.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Gemini CLI: global agents (<code>gemini-agents-global</code>)</summary>

Destination: `~/.gemini/agents`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor gemini-agents-global
# Update
bash scripts/install-ai-agent-skills.sh update --flavor gemini-agents-global --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor gemini-agents-global
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor gemini-agents-global -Merge
```

**Activate and verify:** Inspect `/agents` and invoke `@independent-reviewer` in Gemini CLI. Install the matching skill flavor separately; listing an agent confirms discovery, not delegation.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>Gemini CLI: project agents (<code>gemini-agents-project</code>)</summary>

Destination: `$PROJECT/.gemini/agents`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor gemini-agents-project --project /absolute/path/to/project
# Update
bash scripts/install-ai-agent-skills.sh update --flavor gemini-agents-project --project /absolute/path/to/project --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor gemini-agents-project -Project 'C:/path/to/project'
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor gemini-agents-project -Project 'C:/path/to/project' -Merge
```

**Activate and verify:** Inspect `/agents` and invoke `@independent-reviewer` in Gemini CLI. Install the matching skill flavor separately; listing an agent confirms discovery, not delegation.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>OpenCode: global agents (<code>opencode-agents-global</code>)</summary>

Destination: `~/.config/opencode/agents`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor opencode-agents-global
# Update
bash scripts/install-ai-agent-skills.sh update --flavor opencode-agents-global --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor opencode-agents-global
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor opencode-agents-global -Merge
```

**Activate and verify:** Start a new OpenCode session. Run `opencode --standalone api get /api/agent` in the target project to check registration, then request `independent-reviewer`. Install the matching skill flavor separately; listing an agent confirms discovery, not delegation.

After updating, repeat the discovery check in a fresh session.

</details>

<details>
<summary>OpenCode: project agents (<code>opencode-agents-project</code>)</summary>

Destination: `$PROJECT/.opencode/agents`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor opencode-agents-project --project /absolute/path/to/project
# Update
bash scripts/install-ai-agent-skills.sh update --flavor opencode-agents-project --project /absolute/path/to/project --merge
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor opencode-agents-project -Project 'C:/path/to/project'
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor opencode-agents-project -Project 'C:/path/to/project' -Merge
```

**Activate and verify:** Start a new OpenCode session. Run `opencode --standalone api get /api/agent` in the target project to check registration, then request `independent-reviewer`. Install the matching skill flavor separately; listing an agent confirms discovery, not delegation.

After updating, repeat the discovery check in a fresh session.

</details>

#### Plugin staging

<details>
<summary>GitHub Copilot: plugin staging only (<code>copilot-staging</code>)</summary>

Destination: `~/.local/share/ai-agent-skills/copilot`.

**macOS / Linux (Bash)**

```sh
# Install
bash scripts/install-ai-agent-skills.sh --flavor copilot-staging
# Update
bash scripts/install-ai-agent-skills.sh update --flavor copilot-staging
```

**Windows (PowerShell 7.4+)**

```powershell
# Install
./scripts/install-ai-agent-skills.ps1 -Flavor copilot-staging
# Update
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor copilot-staging
```

**Activate and verify:** This stages files only. It does not activate a plugin: a compatible Copilot marketplace must be configured separately. Prefer a native skill flavor for immediate use; see [Copilot plugins](https://docs.github.com/en/copilot/concepts/agents/about-plugins).

Updates refresh the staged files; marketplace activation remains separate.

</details>

Installing files or seeing a skill in a list does not prove that the agent followed
it. Check the visible skill/delegation activity and the result. For options, source
builds, conflict recovery, and uninstall, use the [installer reference](docs/installer-reference.md).

## Use the skills

Describe the task normally, or name a skill when you want a specific workflow.
For a substantial change, plan first and authorize implementation after reviewing
that plan:

```text
Use agent-planning to plan this change with acceptance criteria and verification.
Implement the accepted plan using implement-plan, including independent review.
```

The workflows ask the agent to inspect source, verify behavior, and report gaps.
They are instructions, not enforced runtime controls. A feature request does not
authorize commits, pushes, external messages, or deployment. If independent review
is required but unavailable, the agent reports it as incomplete.

Follow the [planned-change walkthrough](docs/workflow-example.md) for a concrete
example, or browse the skills below for a focused task.

## Browse the skills

<details>
<summary><strong>Browse all 23 skills</strong></summary>

### Plan and design

| Skill | Use it to |
| --- | --- |
| [decision-partner](skills/decision-partner/SKILL.md) | Clarify goals and challenge consequential assumptions. |
| [agent-planning](skills/agent-planning/SKILL.md) | Investigate requirements and produce verifiable tasks. |
| [api-design](skills/api-design/SKILL.md) | Define compatible interfaces, errors, authorization, and retries. |

### Build and verify

| Skill | Use it to |
| --- | --- |
| [implement-plan](skills/implement-plan/SKILL.md) | Build an accepted plan, verify behavior, and obtain final independent review. |
| [writing-clean-simple-code](skills/writing-clean-simple-code/SKILL.md) | Implement and refactor with clear responsibilities. |
| [frontend-engineering](skills/frontend-engineering/SKILL.md) | Build responsive, accessible interfaces and verify interactions. |
| [root-cause-debug](skills/root-cause-debug/SKILL.md) | Diagnose failures and verify supported repairs. |
| [writing-optimized-sql](skills/writing-optimized-sql/SKILL.md) | Write and tune SQL across major engines. |
| [test-authoring](skills/test-authoring/SKILL.md) | Write behavioral and regression coverage. |

### Review and collaborate

| Skill | Use it to |
| --- | --- |
| [code-review](skills/code-review/SKILL.md) | Review code, plans, and pull requests against evidence. |
| [address-feedback](skills/address-feedback/SKILL.md) | Verify pull request feedback, repair supported issues, and draft replies. |
| [review-lense](skills/review-lense/SKILL.md) | Predict reviewer preferences without substituting for correctness review. |
| [jira-tickets](skills/jira-tickets/SKILL.md) | Read Jira issues and preserve ADF formatting for authorized writes. |

### Deliver and operate

| Skill | Use it to |
| --- | --- |
| [git-delivery](skills/git-delivery/SKILL.md) | Prepare authorized commits, pushes, and pull request descriptions. |
| [ci-cd-workflows](skills/ci-cd-workflows/SKILL.md) | Build and debug secure delivery pipelines. |
| [safe-migrations](skills/safe-migrations/SKILL.md) | Transition APIs, services, and data with verified recovery. |
| [release-readiness](skills/release-readiness/SKILL.md) | Assess a release and prepare an authorized rollout. |

### Explain and document

| Skill | Use it to |
| --- | --- |
| [explain-it](skills/explain-it/SKILL.md) | Explain unfamiliar material in plain language. |
| [anti-ai-writing](skills/anti-ai-writing/SKILL.md) | Draft concise prose that follows destination rules. |
| [technical-documentation](skills/technical-documentation/SKILL.md) | Write technical guides and references from verified sources. |
| [readme-design](skills/readme-design/SKILL.md) | Design a clear project entrypoint with deliberate GitHub Markdown. |
| [skill-authoring](skills/skill-authoring/SKILL.md) | Author, evaluate, and package agent skills. |
| [using-skills](skills/using-skills/SKILL.md) | Route ambiguous or multi-workflow tasks. |

</details>

## Documentation

| Your next task | Guide |
| --- | --- |
| Configure, update, troubleshoot, or remove an installation | [Installer reference](docs/installer-reference.md) |
| Check host discovery, subagents, and evidence limits | [Host compatibility](docs/host-compatibility.md) |
| Follow a change from planning through review | [Workflow walkthrough](docs/workflow-example.md) |
| Validate or build host packages | [Packaging reference](docs/plugins.md) |
| Prepare and verify a draft release | [Release guide](docs/releases.md) |
| Contribute a skill or tooling change | [Contributing](CONTRIBUTING.md) |
