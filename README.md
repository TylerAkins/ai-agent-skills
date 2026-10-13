# ai-agent-skills

Version-controlled engineering workflows for AI coding agents, built for Cursor
first and shared with Codex. Keep reusable skills for planning, implementation,
testing, review, and delivery in one repository instead of rebuilding them per project.

## Install in a Project

For the bundled Cursor plugin or portable Codex plugin, follow
[local plugin setup](docs/plugins.md). Cursor's package adds a routing rule and
independent reviewer; Codex's package contains the shared skills and references.
The copy-based skill installation below remains available without Go.

You need Git and a version of Cursor or Codex that supports Agent Skills.
Clone this collection, then copy its skill folders into your project's
`.agents/skills/` directory, which both hosts support.

For macOS or Linux, run this from the directory where you want the collection checkout.
Replace `/path/to/your-project` with your existing project directory:

```sh
git clone https://github.com/TylerAkins/ai-agent-skills.git
cd ai-agent-skills
mkdir -p /path/to/your-project/.agents/skills
cp -Ri skills/. /path/to/your-project/.agents/skills/
```

The interactive copy prompts before overwriting existing files. Compare conflicting
skills before replacing them. On Windows, copy the folders inside `skills` into
`<your-project>/.agents/skills` with your file manager, reviewing any conflicts.

Copy the complete collection and each skill's supporting files. Skills reference
siblings, so installing one folder alone may leave required guidance unavailable.
For updates, compare and copy the updated folders again; copied files do not sync.
Do not copy this repo's `AGENTS.md` into your project as an installation step.

### Cursor

Open the target project in Cursor and start a new Agent chat. Open Customize, then
Skills, and check for the installed names. Type `/` and select a skill to invoke it explicitly;
Agent can also choose relevant skills from your request. See
[Cursor's skill documentation](https://cursor.com/docs/skills).

Cursor also supports `.cursor/skills/` for project installation and
`~/.cursor/skills/` for local user-level installation. Project installation keeps
the collection alongside the code and avoids relying on user-level files on another machine.

### Codex

Open the target project in Codex and start a new session. In the CLI or IDE extension, type `$`
to select a skill explicitly. In the desktop app, use the available skill selector,
or name the skill in your request. Codex can also select relevant guidance. For example, use
`$agent-planning` with a feature request. See
[Codex's skill documentation](https://developers.openai.com/codex/skills/)
for discovery and user-level installation options.

OpenCode integration is planned but unvalidated. Plugin manifests and a Go packager
are available; automated installation and marketplace publication are not yet provided.

## Try It

Select the named skill in your host, then provide a request such as:

- `agent-planning`: “Plan this feature from the ticket. Identify dependencies and verification. Do not implement it yet.”
- `code-review`: “Review this branch against main for regressions and missing requirements. Keep the candidate unchanged.”
- `root-cause-debug`: “Reproduce this failure, establish its cause, and fix it with regression coverage.”

[using-skills](skills/using-skills/SKILL.md) describes how the workflows fit together.
Skills preserve the scope of your request. Commits, pushes, external replies, and
production actions need authorization; GitHub reviews and approvals are never dismissed.

## Skills

### From Jira to Build

In the target project's Agent chat, use `jira-tickets` to read the issue in intake
mode. Switch to Plan mode and use `agent-planning` to investigate the repository
and define tasks. The generated plan includes an explicit `implement-plan` execution
handoff. Check that it is present when reviewing the plan, then request Build.
Keep the issue context and accepted plan in the same chat, or provide
them explicitly when starting a separate one.

Implementation includes relevant coding/domain skills, meaningful verification,
and final independent `code-review` unless you explicitly skip it. Supported findings
are repaired and material changes re-reviewed. If independent review is unavailable,
the agent reports that gate incomplete. Build does not authorize commits or pushes.

This describes the intended skill handoff; it is not an automated integration or
a guarantee that every host follows the embedded handoff. If the executor misses
it, explicitly select `implement-plan` and supply the accepted plan.

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

## Working on This Repository

Edit canonical files under `skills/` and follow [AGENTS.md](AGENTS.md). The checked-in
`.cursor/skills` symlink exposes those files when maintaining this repository in Cursor;
it is not needed for the copy-based installation described above.

Keep relative links and the skill list current. Structural checks do not establish
behavioral reliability; validate changes on representative tasks in the target host.

Run `go test -race ./...`, `go vet ./...`, and `go run ./cmd/skillpack` for collection
checks. Build fresh host packages with the commands in [plugin setup](docs/plugins.md).

## License

[MIT](LICENSE).
