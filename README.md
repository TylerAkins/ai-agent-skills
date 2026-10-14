# ai-agent-skills

21 shared engineering skills for Cursor, Codex, Claude Code, GitHub Copilot,
OpenCode, Gemini CLI, Muse Code, and Google Antigravity. Plan, build, test, review,
and prepare delivery with consistent workflows and explicit authorization.

## Install

Choose a distribution path:

| Path | Requirements | Installs |
| --- | --- | --- |
| Open Skills CLI (`npx skills`) | Node.js/npm and Git; no manual clone | Skill folders and supporting resources for supported agents |
| Native shell installers | Bash and platform tools, or PowerShell; no Node.js or Go | Release bundles, including host routing/reviewer configuration where supported |

### Open Skills CLI

Run from your target project directory:

```sh
npx skills add TylerAkins/ai-agent-skills
```

Select your agents and skills interactively. To list skills or select one by name:

```sh
npx skills add TylerAkins/ai-agent-skills --list
npx skills add TylerAkins/ai-agent-skills --skill test-authoring

# Install globally for all projects/workspaces
npx skills add TylerAkins/ai-agent-skills -g

# Update installed skills to the latest revision
npx skills update
```

Skills link to other skills in this collection. Install the collection when you
need those workflows; a single skill retains its own `references/` resources but
does not install sibling skills automatically. See the
[Open Skills CLI documentation](https://github.com/vercel-labs/skills) for supported
agents, global installation, and updates.

### Native Shell Installers

Expand your host below for installation, activation, and updates. These installers
use Bash on macOS/Linux or PowerShell on Windows with the prerequisites below;
they do not require a Node.js runtime or additional language package installation.

Install the host app and Git first. On **macOS/Linux**, you also need Bash, curl,
tar, shasum, and jq. macOS includes Bash, curl, tar, and shasum; with Homebrew,
install jq using `brew install jq`. On Linux, use your package manager for missing tools.
On **Windows**, use [PowerShell 7.4+](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows),
not Windows PowerShell 5.1. No Bash or jq is needed on Windows.

Clone once, then run your host's commands below from this checkout.

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

For an existing checkout, skip cloning. Before updating, run `git pull --ff-only`
once, then use your host's update command below. Skills-only updates use merge to
preserve unrelated skill folders; plugin updates replace the plugin with a backup.

<a id="cursor"></a>
<details>
<summary><strong>Cursor</strong></summary>

### Install on macOS / Linux

```sh
bash scripts/install-ai-agent-skills.sh --flavor cursor
```

### Install on Windows

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor cursor
```

### Activate and check

Run **Developer: Reload Window** from Cursor's Command Palette
(`Cmd+Shift+P` on Mac, `Ctrl+Shift+P` on Windows/Linux). Open **Customize** and
check for **ai-agent-skills**, its skills, routing rule, and reviewer. Start a new
Agent chat and request `agent-planning`.

Local plugin imports must be allowed by your account/team. A marketplace copy
with the same name can take precedence. See [Cursor plugins](https://cursor.com/docs/plugins).

### Update

Run from this checkout:

**macOS / Linux**

```sh
bash scripts/install-ai-agent-skills.sh update --flavor cursor
```

**Windows**

```powershell
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor cursor
```

Confirm replacement, reload Cursor, and start a new chat.

</details>

<a id="codex"></a>
<details>
<summary><strong>Codex</strong></summary>

### Install on macOS / Linux

```sh
bash scripts/install-ai-agent-skills.sh --flavor codex-desktop
```

### Install on Windows

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor codex-desktop
```

### Activate and check

Quit and reopen ChatGPT/Codex. In **Plugins**, select your personal marketplace
and install **ai-agent-skills**. Start a new chat and request `agent-planning`.

The helper installs files in `~/.codex/plugins/ai-agent-skills` and merges an entry
into `~/.agents/plugins/marketplace.json`, preserving other plugins and metadata.
You complete activation in the app. It does not register a CLI marketplace.
See [OpenAI local marketplaces](https://developers.openai.com/plugins/build/plugins).

### Update

Run from this checkout:

**macOS / Linux**

```sh
bash scripts/install-ai-agent-skills.sh update --flavor codex-desktop
```

**Windows**

```powershell
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor codex-desktop
```

Confirm replacement, refresh/reinstall the plugin in Codex if its cached copy stays old,
and start a new chat.

For project skills or a separate marketplace root, see
[alternate installations](docs/installer-reference.md#alternate-installations).

</details>

<a id="claude-code"></a>
<details>
<summary><strong>Claude Code</strong></summary>

### Install on macOS / Linux

```sh
bash scripts/install-ai-agent-skills.sh --flavor claude
```

### Install on Windows

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor claude
```

### Activate and check

Launch Claude Code with the installed plugin directory.

**macOS / Linux**

```sh
claude --plugin-dir "$HOME/.local/share/ai-agent-skills/claude"
```

**Windows**

```powershell
claude --plugin-dir "$env:USERPROFILE/.local/share/ai-agent-skills/claude"
```

Invoke `/ai-agent-skills:agent-planning` in that session. Use `--plugin-dir` when
launching later sessions too; the helper does not configure a persistent marketplace.
See [Claude plugins](https://code.claude.com/docs/en/plugins).

### Update

Run from this checkout:

**macOS / Linux**

```sh
bash scripts/install-ai-agent-skills.sh update --flavor claude
```

**Windows**

```powershell
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor claude
```

Confirm replacement, then launch a new Claude Code session with `--plugin-dir` as above.

</details>

<a id="github-copilot"></a>
<details>
<summary><strong>GitHub Copilot</strong></summary>

Replace the example project path below with your existing project directory.

### Install on macOS / Linux

```sh
bash scripts/install-ai-agent-skills.sh --flavor copilot-skills --project /absolute/path/to/project
```

### Install on Windows

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor copilot-skills -Project 'C:/path/to/project'
```

### Activate and check

The helper installs this collection into that project's `.github/skills` folder.

Open the project in the Copilot app, start a new session, and check
**Customize > Skills**. Request `agent-planning` in chat. See
[Copilot app customization](https://docs.github.com/en/copilot/how-tos/github-copilot-app/customize-github-copilot-app).

### Update

Run from this checkout:

**macOS / Linux**

```sh
bash scripts/install-ai-agent-skills.sh update --flavor copilot-skills --project /absolute/path/to/project --merge
```

**Windows**

```powershell
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor copilot-skills -Project 'C:/path/to/project' -Merge
```

Merge replaces this collection's skill folders and preserves unrelated skills. Start a new host session.

A portable plugin can also be staged, but staging does not activate it or create
a marketplace. See [alternate installations](docs/installer-reference.md#alternate-installations).

</details>

<a id="opencode"></a>
<details>
<summary><strong>OpenCode</strong></summary>

### Install on macOS / Linux

```sh
bash scripts/install-ai-agent-skills.sh --flavor opencode-global
```

### Install on Windows

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor opencode-global
```

### Activate and check

Skills are installed in `~/.config/opencode/skills` for use across your projects.
Start a new OpenCode session and request `agent-planning`.
This is a skills installation. See [OpenCode skills](https://opencode.ai/docs/skills/).

### Update

Run from this checkout:

**macOS / Linux**

```sh
bash scripts/install-ai-agent-skills.sh update --flavor opencode-global --merge
```

**Windows**

```powershell
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor opencode-global -Merge
```

Merge replaces this collection's skill folders and preserves unrelated skills. Start a new host session.

For installation in one project only, see
[alternate installations](docs/installer-reference.md#alternate-installations).

</details>

<a id="gemini"></a>
<details>
<summary><strong>Gemini CLI</strong></summary>

### Install on macOS / Linux

```sh
bash scripts/install-ai-agent-skills.sh --flavor gemini-global
```

### Install on Windows

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor gemini-global
```

### Activate and check

Skills are installed in `~/.gemini/skills` for use across projects.
In Gemini CLI, run `/skills reload` and `/skills list`. Request `agent-planning`. See [Gemini CLI skills](https://geminicli.com/docs/cli/using-agent-skills/).

### Update

Run from this checkout:

```sh
bash scripts/install-ai-agent-skills.sh update --flavor gemini-global --merge
```

```powershell
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor gemini-global -Merge
```

Merge replaces this collection's skill folders and preserves unrelated skills.
Reload the host's skills after updating. For project installation, see
[alternate installations](docs/installer-reference.md#alternate-installations).

</details>

<a id="muse"></a>
<details>
<summary><strong>Muse Code</strong></summary>

### Install on macOS / Linux

```sh
bash scripts/install-ai-agent-skills.sh --flavor muse-global
```

### Install on Windows

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor muse-global
```

### Activate and check

Skills are installed in `~/.agents/skills` for use across projects.
In Muse Code, run `/skills reload`, then check `muse skills list` from a terminal.
Invoke `/agent-planning` in the session. See [Muse Code skills](https://meta-models.github.io/muse-code-sdk/next/guides/extend/skills/).

### Update

Run from this checkout:

```sh
bash scripts/install-ai-agent-skills.sh update --flavor muse-global --merge
```

```powershell
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor muse-global -Merge
```

Merge replaces this collection's skill folders and preserves unrelated skills.
Reload the host's skills after updating. For project installation, see
[alternate installations](docs/installer-reference.md#alternate-installations).

</details>

<a id="antigravity"></a>
<details>
<summary><strong>Google Antigravity</strong></summary>

### Install on macOS / Linux

```sh
bash scripts/install-ai-agent-skills.sh --flavor antigravity-global
```

### Install on Windows

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor antigravity-global
```

The global flavor installs to `~/.gemini/config/skills` for the Antigravity app
and standalone IDE. For the CLI, use `antigravity-cli-global` instead; it installs
to `~/.gemini/antigravity-cli/skills`. These are separate installations.

### Activate and check

Start a new session and invoke `/agent-planning`. In the standalone IDE, inspect
active skills through the agent side panel's **Customizations** menu. See
[Antigravity skill locations and invocation](https://antigravity.google/docs/skills).
File placement alone does not establish that the host loaded a skill.

### Update

Run from this checkout:

```sh
bash scripts/install-ai-agent-skills.sh update --flavor antigravity-global --merge
```

```powershell
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor antigravity-global -Merge
```

Use `antigravity-cli-global` in the update command for the CLI installation.
Merge preserves unrelated skills and replaces this collection's skill folders.
Start a new session after updating. For project installation, see
[alternate installations](docs/installer-reference.md#alternate-installations).

</details>

The `.agents/skills` directory used by Muse and Antigravity project installations
is shared with other agents that discover it.
Installing or updating there changes the collection those agents read too.
The new flavors require a release containing `ai-agent-skills-skills`; older
releases do not include that archive. For an unpublished local checkout, use
[manual installation](docs/installer-reference.md#source-builds-and-manual-installation).

Release installs use checksum-verified bundles and retain backups when replacing
existing files. Updates can replace local customizations. See
[installer controls and troubleshooting](docs/installer-reference.md) for pinned versions,
conflict handling, manual installation, and recovery.

## Use

Select a skill in your host or name it in your request:

```text
Use agent-planning to plan this feature. Do not implement it yet.
Use code-review to review this branch against main without changing the code.
Use root-cause-debug to reproduce and fix this failure with regression coverage.
```

For Jira-to-Build work:

1. Use `jira-tickets` to read the issue in intake mode.
2. Switch to Plan mode and use `agent-planning`. Review the plan and its `implement-plan` handoff.
3. Request Build in the same chat, or supply the issue context and accepted plan in a new one.

Implementation includes relevant skills, verification, and independent `code-review`
unless you explicitly skip it. Unavailable review is reported incomplete. If the
host misses the handoff, request `implement-plan` explicitly. Jira/GitHub connections
must be configured separately. This is an instructed workflow, not host automation.

Build does not authorize commits, pushes, external replies, or deployment.
GitHub reviews and approvals are never dismissed.

## Skills

<details>
<summary><strong>Browse all 21 skills</strong></summary>

### Clarify and Plan

| Skill | Purpose |
| --- | --- |
| [decision-partner](skills/decision-partner/SKILL.md) | Clarify goals and challenge consequential assumptions. |
| [agent-planning](skills/agent-planning/SKILL.md) | Investigate requirements and produce verifiable tasks. |
| [implement-plan](skills/implement-plan/SKILL.md) | Build an accepted plan, verify behavior, and obtain final independent review. |
| [api-design](skills/api-design/SKILL.md) | Define compatible interfaces, errors, authorization, and retries. |

### Build and Verify

| Skill | Purpose |
| --- | --- |
| [writing-clean-simple-code](skills/writing-clean-simple-code/SKILL.md) | Implement and refactor with clear ownership and justified abstractions. |
| [frontend-engineering](skills/frontend-engineering/SKILL.md) | Build responsive, accessible interfaces and verify interactions. |
| [root-cause-debug](skills/root-cause-debug/SKILL.md) | Diagnose supported causes and verify repairs. |
| [writing-optimized-sql](skills/writing-optimized-sql/SKILL.md) | Write and tune SQL across major engines with correctness and performance evidence. |
| [test-authoring](skills/test-authoring/SKILL.md) | Write meaningful behavioral and regression coverage. |

### Review and Collaborate

| Skill | Purpose |
| --- | --- |
| [code-review](skills/code-review/SKILL.md) | Review local code, plans, and GitHub PRs against evidence. |
| [address-feedback](skills/address-feedback/SKILL.md) | Verify PR feedback, repair supported issues, and draft replies. |
| [review-lense](skills/review-lense/SKILL.md) | Predict reviewer preferences without substituting for correctness review. |
| [jira-tickets](skills/jira-tickets/SKILL.md) | Read issues and preserve explicit ADF formatting for authorized writes. |

### Deliver and Operate

| Skill | Purpose |
| --- | --- |
| [git-delivery](skills/git-delivery/SKILL.md) | Prepare scoped commits, pushes, and concise PR descriptions. |
| [ci-cd-workflows](skills/ci-cd-workflows/SKILL.md) | Build reliable checks and secure delivery pipelines. |
| [safe-migrations](skills/safe-migrations/SKILL.md) | Transition consumers and data with verified recovery limits. |
| [release-readiness](skills/release-readiness/SKILL.md) | Assess a specific release and coordinate authorized rollout. |

### Write and Coordinate

| Skill | Purpose |
| --- | --- |
| [anti-ai-writing](skills/anti-ai-writing/SKILL.md) | Concise prose, strict style rules, and publication approval. |
| [skill-authoring](skills/skill-authoring/SKILL.md) | Author, evaluate, and register engineering skills with verified packages. |
| [technical-documentation](skills/technical-documentation/SKILL.md) | Write verified guides, references, READMEs, and decision records. |
| [using-skills](skills/using-skills/SKILL.md) | Select relevant skills without forcing a full lifecycle. |

</details>

## Contributing

[Report a bug or request a skill](https://github.com/TylerAkins/ai-agent-skills/issues/new/choose).
[CONTRIBUTING.md](CONTRIBUTING.md) covers editing, tests, and PR conventions;
[AGENTS.md](AGENTS.md) contains repository instructions.

Maintainers: [package builds](docs/plugins.md) and [release preparation](docs/releases.md).
Installer tests establish file placement, not that a host loaded or followed a skill.

## License

[MIT](LICENSE).
