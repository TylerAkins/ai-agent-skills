# ai-agent-skills

A shared collection of engineering skills for Cursor and Codex. The skills cover
planning, implementation, testing, review, delivery, and operational work, with
explicit authorization boundaries and concise technical writing.

## Use with Cursor

Clone this repository and open it in Cursor:

```sh
git clone https://github.com/TylerAkins/ai-agent-skills.git
cd ai-agent-skills
```

The checked-in `.cursor/skills` symlink points to `skills/`. [AGENTS.md](AGENTS.md)
provides instructions for work in this repository. Read
[using-skills](skills/using-skills/SKILL.md) for the routing guidance.

For another project, copy the complete `skills/` directory into that project's
`.cursor/skills/`, or install the complete collection in your user-level skill
location. Keep sibling skills together: relative links do not install dependencies.
Preserve each skill's `references/` directory. Avoid overwriting existing skills
without comparing them first.

Cursor's documented discovery locations include `.cursor/skills/` and
`~/.cursor/skills/`. See [Cursor's skill documentation](https://cursor.com/docs/skills).
The repository symlink requires a checkout that preserves symlinks. On systems
that do not, copy the collection into `.cursor/skills/` instead. Discovery and
invocation in a live Cursor session have not yet been validated for this collection.

## Codex and Other Agents

The canonical skills are in `skills/`, with a `SKILL.md` entry point and optional
references in each folder. Install the complete collection into a skill location
supported by your host. This repository currently has no automated installer or
plugin package. OpenCode integration has not been validated.

## Skills

| Skill | Purpose |
| --- | --- |
| [anti-ai-writing](skills/anti-ai-writing/SKILL.md) | Concise prose, strict style rules, and publication approval. |
| [using-skills](skills/using-skills/SKILL.md) | Select relevant skills without forcing a full lifecycle. |
| [decision-partner](skills/decision-partner/SKILL.md) | Clarify goals and challenge consequential assumptions. |
| [agent-planning](skills/agent-planning/SKILL.md) | Investigate requirements and produce verifiable tasks. |
| [api-design](skills/api-design/SKILL.md) | Define compatible interfaces, errors, authorization, and retries. |
| [writing-clean-simple-code](skills/writing-clean-simple-code/SKILL.md) | Implement and refactor with clear ownership and justified abstractions. |
| [frontend-engineering](skills/frontend-engineering/SKILL.md) | Build responsive, accessible interfaces and verify interactions. |
| [root-cause-debug](skills/root-cause-debug/SKILL.md) | Diagnose supported causes and verify repairs. |
| [test-authoring](skills/test-authoring/SKILL.md) | Write meaningful behavioral and regression coverage. |
| [code-review](skills/code-review/SKILL.md) | Review local code, plans, and GitHub PRs against evidence. |
| [address-feedback](skills/address-feedback/SKILL.md) | Verify PR feedback, repair supported issues, and draft replies. |
| [review-lense](skills/review-lense/SKILL.md) | Predict reviewer preferences without substituting for correctness review. |
| [git-delivery](skills/git-delivery/SKILL.md) | Prepare scoped commits, pushes, and concise PR descriptions. |
| [jira-tickets](skills/jira-tickets/SKILL.md) | Read issues and preserve explicit ADF formatting for authorized writes. |
| [ci-cd-workflows](skills/ci-cd-workflows/SKILL.md) | Build reliable checks and secure delivery pipelines. |
| [safe-migrations](skills/safe-migrations/SKILL.md) | Transition consumers and data with verified recovery limits. |
| [release-readiness](skills/release-readiness/SKILL.md) | Assess a specific release and coordinate authorized rollout. |
| [technical-documentation](skills/technical-documentation/SKILL.md) | Write verified guides, references, READMEs, and decision records. |

## Boundaries and Validation

Skills guide work; they do not grant permission to commit, push, publish, deploy,
or contact others. External review drafts require exact-text approval. GitHub
reviews and approvals are preserved, including stale reviews; skills must never
dismiss them or enable automatic dismissal. Re-review requests require authorization.

Structural validation and link checks do not establish behavioral reliability.
Most skills have not yet been tested in live Cursor workflows. A focused Codex
planning probe was performed; it does not establish performance across the collection.

## Maintaining the Collection

Edit canonical files under `skills/`, update affected relative links, and keep
[using-skills](skills/using-skills/SKILL.md) aligned with available skills. Preserve
the Jira writing reference's tested ADF instructions unless a formatting change is
explicitly requested and validated. Follow [AGENTS.md](AGENTS.md) when changing this repo.

## License

[MIT](LICENSE).
