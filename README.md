# ai-agent-skills

Shared engineering workflows for Cursor, Codex, Claude Code, GitHub Copilot, and
OpenCode. The collection includes 19 skills for planning, implementation, testing,
review, documentation, and delivery.

## Quick Start: Cursor

### macOS

You need Git and jq. If you use Homebrew and need jq, run `brew install jq`.
Go is not required for release installs.

From the folder where you want to keep the checkout:

```sh
git clone https://github.com/TylerAkins/ai-agent-skills.git
cd ai-agent-skills
bash scripts/install-ai-agent-skills.sh --flavor cursor
```

In Cursor, run **Developer: Reload Window** from the Command Palette
(`Cmd+Shift+P`). Open **Customize** and check for **ai-agent-skills**, its skills,
routing rule, and reviewer. Local plugin imports must be allowed by your account
or team; a marketplace copy with the same name can take precedence.

Already installed? From the checkout:

```sh
git pull --ff-only
bash scripts/install-ai-agent-skills.sh update --flavor cursor
```

Confirm replacement, then reload Cursor. Updates keep a backup and download the
latest published release. Pulling the checkout gets fixes to the installer itself.

For **Codex, Claude Code, Copilot, OpenCode, project skills, or Linux**, follow
[install and update](docs/install.md). Windows has a PowerShell installer; the
guide includes its prerequisites and commands.

### Windows

Use [PowerShell 7.4 or newer](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows) and Git:

```powershell
git clone https://github.com/TylerAkins/ai-agent-skills.git
Set-Location ai-agent-skills
./scripts/install-ai-agent-skills.ps1 -Flavor cursor
```

Reload Cursor and check **Customize** as described in the Mac quick start.
For updates, run `./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor cursor`.
The Windows helper uses built-in download, JSON, and checksum support; no jq or Go
is needed for release installation.

## Use a Skill

Select a skill in your host or name it in your request:

- `agent-planning`: Plan this feature, including dependencies and verification. Do not implement it yet.
- `code-review`: Review this branch against main for regressions. Keep the code unchanged.
- `root-cause-debug`: Reproduce this failure, find its cause, and fix it with regression coverage.

Use [using-skills](skills/using-skills/SKILL.md) when you need help selecting a
workflow. Jira and GitHub connections must be configured separately in your host.

### From Jira to Build

1. Use `jira-tickets` to read the issue in intake mode.
2. Switch to Plan mode and use `agent-planning`. Review the plan and its `implement-plan` handoff.
3. Request Build in the same chat, or supply the issue context and accepted plan in a new one.

Implementation includes relevant skills, verification, and final independent
`code-review` unless you explicitly skip it. If review is unavailable, the gate is
reported incomplete. If the host misses the handoff, request `implement-plan`
explicitly. This is an instructed workflow, not an automated host integration.

Skills preserve authorization. Build does not authorize commits, pushes, external
replies, or deployment. GitHub reviews and approvals are never dismissed.

## Skills

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
| [technical-documentation](skills/technical-documentation/SKILL.md) | Write verified guides, references, READMEs, and decision records. |
| [using-skills](skills/using-skills/SKILL.md) | Select relevant skills without forcing a full lifecycle. |

## Contribute

Use the [issue forms](https://github.com/TylerAkins/ai-agent-skills/issues/new/choose)
for bugs or skill requests. See [CONTRIBUTING.md](CONTRIBUTING.md) for editing,
checks, and PR conventions, and [AGENTS.md](AGENTS.md) for repository instructions.

[Packaging reference](docs/plugins.md) covers host bundles and maintainer checks.
[Release preparation](docs/releases.md) explains draft releases and distribution.
Installer tests and structural checks do not establish live host behavior.

## License

[MIT](LICENSE).
