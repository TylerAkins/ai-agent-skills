# ai-agent-skills

23 shared workflows for AI coding agents. Plan work, implement changes, investigate
failures, review code, and prepare delivery with explicit boundaries.

## Install

Choose how you want the skills delivered:

| Method | Best for | Requirements |
| --- | --- | --- |
| [Open Skills CLI](#open-skills-cli) | Installing selected skills into a supported coding host | Node.js 22.20+, npm, and Git |
| [Native shell installer](#native-shell-installer) | Host plugins, native skill directories, and optional subagents | Git; Bash on macOS/Linux or PowerShell 7.4+ on Windows |
| [Manual install](docs/installer-reference.md#source-builds-and-manual-installation) | Copying skills from a local checkout | Git and the host's skill directory |

### Open Skills CLI

Run from the project where you want the skills available:

```sh
npx skills add TylerAkins/ai-agent-skills
```

Choose the coding host and skills interactively. To list skills or install a
specific skill:

```sh
npx skills add TylerAkins/ai-agent-skills --list
npx skills add TylerAkins/ai-agent-skills --skill test-authoring
```

Install globally, update project skills, or update global skills with:

```sh
npx skills add TylerAkins/ai-agent-skills -g
npx skills update -p
npx skills update -g
```

This CLI installs skills and supporting resources. It does not install this
collection's optional subagents. The CLI chooses the host; the host decides
whether to select a skill automatically. See the [Open Skills CLI documentation](https://github.com/vercel-labs/skills)
for its supported hosts and options.

Run `npx skills update -p` to update project skills, or
`npx skills update -g` to update global skills. To add skills introduced since
the last install, run `npx skills add TylerAkins/ai-agent-skills` again and
select the skills you want.

### Native shell installer

The shell installer also installs host plugins, native skill directories, and
optional subagents. Install the target host app and Git first. List the available
flavors from a repository checkout:

**macOS / Linux (Bash)**

```sh
git clone https://github.com/TylerAkins/ai-agent-skills.git
cd ai-agent-skills
bash scripts/install-ai-agent-skills.sh --flavor list
```

**Windows (PowerShell 7.4+)**

```powershell
git clone https://github.com/TylerAkins/ai-agent-skills.git
Set-Location ai-agent-skills
./scripts/install-ai-agent-skills.ps1 -Flavor list
```

Choose a flavor, replace `cursor` with it, and run the matching example for your
operating system.

**macOS / Linux (Bash)**

```sh
bash scripts/install-ai-agent-skills.sh --flavor cursor
```

**Windows (PowerShell 7.4+)**

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor cursor
```

| Host and path | Flavor |
| --- | --- |
| Cursor plugin | `cursor` |
| Cursor native skills | `cursor-global` |
| Codex desktop plugin | `codex-desktop` |
| Codex native skills | `codex-global` |
| Claude Code plugin | `claude` |
| Claude Code native skills | `claude-global` |
| GitHub Copilot personal skills | `copilot-global` |
| OpenCode global skills | `opencode-global` |
| Gemini CLI global skills | `gemini-global` |
| Muse Code global skills | `muse-global` |
| Antigravity app or IDE | `antigravity-global` |
| Antigravity CLI | `antigravity-cli-global` |

On macOS and Linux, the installer needs Bash, curl, tar, shasum, and jq. On
Windows (PowerShell 7.4+), use the PowerShell installer. For project installs,
updates, agent-only flavors, destination details, conflicts, and recovery, see
the [installer reference](docs/installer-reference.md).

After installing, follow the [activation and update steps](docs/installer-reference.md#activate-an-installation).
The [host compatibility guide](docs/host-compatibility.md) explains discovery
behavior and its limits. File placement alone does not prove that a host loaded
or followed a skill.

#### Update a native installation

Run the installer again with `update` and the same flavor and project path.
Use `--merge` / `-Merge` for skills and agents so unrelated files are kept;
incoming names are refreshed and a backup is created. Plugin updates use the
plugin replacement flow and also create a backup.

**macOS / Linux (Bash)**

```sh
bash scripts/install-ai-agent-skills.sh update --flavor cursor-global --merge
```

**Windows (PowerShell 7.4+)**

```powershell
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor cursor-global -Merge
```

For a project flavor, repeat the same `--project` / `-Project` path used during
installation. To update the installer in a local checkout, run `git pull --ff-only`
there. `--from-source` / `-FromSource` builds a temporary checkout from the
selected release; add `--ref main` / `-Ref main` to build current main.

## Use the skills

Describe the task normally. Hosts with native selection can load a matching skill;
name one when you want a specific workflow:

```text
Use agent-planning to plan this feature. Do not implement it yet.
Use code-review to review this branch against main without changing the code.
Use root-cause-debug to reproduce and fix this failure with regression coverage.
```

For planned work, use `agent-planning` first and `implement-plan` after accepting
the plan. The implementation workflow includes verification and independent
review. If independent review is unavailable, that gate remains incomplete.
These are agent instructions, not enforced runtime controls. Work does not
authorize commits, pushes, external replies, or deployment.

See the [Cursor workflow example](docs/cursor-workflow.md) for a complete planned
change and the [host compatibility guide](docs/host-compatibility.md) for host
behavior and limitations.

## Optional subagents

Four read-only investigation agents handle focused work: `independent-reviewer`,
`root-cause-investigator`, `dependency-investigator`, and `architecture-advisor`.
Ask the main agent to use one, for example: “Use the independent-reviewer to
review my changes against main.” The host and model decide whether to delegate.

Cursor and Claude Code plugins include these agents. Codex desktop and the Open
Skills CLI do not. Native agent formats are available for Codex, OpenCode,
Cursor, GitHub Copilot, Gemini CLI, and Antigravity. Muse Code supports runtime
delegation, but its current documentation does not define persistent custom
agent files. Native installs require a separate agent flavor. See
[agent installation](docs/installer-reference.md#specialized-agent-installations)
and the [subagent compatibility guide](docs/host-compatibility.md#specialized-subagents).

| Host | Global agent flavor | Project agent flavor |
| --- | --- | --- |
| Cursor | `cursor-agents-global` | `cursor-agents-project` |
| GitHub Copilot CLI / repository agents | `copilot-agents-global` | `copilot-agents-project` |
| Gemini CLI | `gemini-agents-global` | `gemini-agents-project` |
| Antigravity | `antigravity-agents-global` | `antigravity-agents-project` |
| OpenCode | `opencode-agents-global` | `opencode-agents-project` |
| Claude Code | `claude-agents-global` | `claude-agents-project` |
| Codex | `codex-agents-global` | `codex-agents-project` |

Install the matching skills separately. For project flavors, pass the same
project path on macOS/Linux with `--project` or Windows with `-Project`.

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

| Guide | What it covers |
| --- | --- |
| [Installer reference](docs/installer-reference.md) | Installation modes, updates, options, destinations, and recovery. |
| [Host compatibility](docs/host-compatibility.md) | Skill discovery, subagents, and host-specific limitations. |
| [Cursor workflow example](docs/cursor-workflow.md) | Planning, implementation, verification, and independent review. |
| [Packaging reference](docs/plugins.md) | Package contents, validation, builds, and host checks. |
| [Release preparation](docs/releases.md) | Drafting and checking a release. |
| [GitHub Flavored Markdown specification](https://github.github.com/gfm/) | The formal specification for the Markdown dialect GitHub supports. |
