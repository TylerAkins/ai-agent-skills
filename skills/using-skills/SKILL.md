---
name: using-skills
description: >-
  Route ambiguous or multi-workflow engineering requests to the right ai-agent-skills
  procedures. Use when a task spans several workflows or no single skill clearly
  applies. For a clear single-skill request, load that skill directly instead.
---

# Using Skills

## 1. Choose the workflow

Choose the applicable branch using the host's native skill selection:

- If one skill clearly matches, load its full instructions and follow them before
  acting. Do not use this router for a clear single-skill task, load every skill,
  or force a full lifecycle.
- If work spans workflows or no single primary skill clearly applies, choose the
  primary procedure from the routing table, then load only supporting procedures
  that materially apply. An explicit user skill selection takes precedence as the
  primary workflow.
- If the collection or a selected skill is unavailable, say so and use a scoped
  fallback. Do not claim to have used a skill based only on its name, description,
  or plan link.

Follow user requests and repository instructions. Skill links route work; they do
not install dependencies, authorize actions, or spawn agents. Read
[anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting human-facing text.

| Task | Primary skill |
| --- | --- |
| Clarify goals or challenge assumptions | [decision-partner](../decision-partner/SKILL.md) |
| Investigate and produce a plan | [agent-planning](../agent-planning/SKILL.md) |
| Build an accepted plan through verification and final review | [implement-plan](../implement-plan/SKILL.md) |
| Implement or simplify code | [writing-clean-simple-code](../writing-clean-simple-code/SKILL.md) |
| Diagnose and repair unexpected behavior | [root-cause-debug](../root-cause-debug/SKILL.md) |
| Write, review, or optimize SQL queries and procedures | [writing-optimized-sql](../writing-optimized-sql/SKILL.md) |
| Write behavioral tests | [test-authoring](../test-authoring/SKILL.md) |
| Design shared contracts | [api-design](../api-design/SKILL.md) |
| Author, refine, or package agent skills | [skill-authoring](../skill-authoring/SKILL.md) |
| Explain concepts, code, documents, or decisions simply | [explain-it](../explain-it/SKILL.md) |
| Design or substantially revise a README | [readme-design](../readme-design/SKILL.md) |
| Write source-derived technical guides, references, or decision records | [technical-documentation](../technical-documentation/SKILL.md) |
| Build or improve UI | [frontend-engineering](../frontend-engineering/SKILL.md) |
| Review code, plans, or PRs | [code-review](../code-review/SKILL.md) |
| Address existing PR feedback | [address-feedback](../address-feedback/SKILL.md) |
| Predict a reviewer's preferences | [review-lense](../review-lense/SKILL.md) |
| Commit, push, or prepare PR descriptions | [git-delivery](../git-delivery/SKILL.md) |
| Read or write Jira issues | [jira-tickets](../jira-tickets/SKILL.md) |
| Build or debug CI/CD pipelines | [ci-cd-workflows](../ci-cd-workflows/SKILL.md) |
| Transition consumers, contracts, or data | [safe-migrations](../safe-migrations/SKILL.md) |
| Assess or conduct a specific release | [release-readiness](../release-readiness/SKILL.md) |

Keep each skill's boundary: planning does not implement; review does not repair;
preference prediction does not establish correctness; CI configuration does not
establish release readiness; a draft does not authorize publication. The calling
workflow resumes already-authorized work after a supporting skill finishes.

For an accepted Plan-to-Build request, use implement-plan as the coordinator;
writing-clean-simple-code and domain skills support it rather than replacing its
verification and final independent review gates. Jira intake supplies source intent,
agent-planning supplies tasks, and implement-plan verifies execution against both.
The generated plan must contain the execution handoff, not just a chat reminder,
so native Build and separate-session execution can carry the coordinator instruction.
When authoring a plan, identify only the skills that materially apply, link each one
from the plan's location, map it to the task or decision it supports, and state the
specific guidance the executor should use. Keep the implement-plan coordinator
instruction distinct from task-specific skills. Tell the executor to read each linked
skill before its task; do not assume host discovery or skill aliases will activate it.
If a linked skill is unavailable, surface that limit and use a scoped fallback without
claiming the skill was applied.

When skills reference each other, reuse already-loaded guidance and evidence rather
than recursively restarting workflows. In testing/debugging, retain the current
reproduction and task scope. Do not re-run unchanged verified work solely because
a handoff occurred; reopen coverage after relevant changes or new contradictory evidence.

If a required skill or tool is unavailable, state the limitation and use a scoped
fallback when possible. Never claim a missing procedure, independent review, live
check, or deployment occurred. Use delegation only when permitted and useful,
with raw intent and the exact candidate; do not create personas merely to route tasks.
