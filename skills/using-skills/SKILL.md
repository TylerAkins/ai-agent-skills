---
name: using-skills
description: >-
  Select and combine this collection's skills for a task without redundant workflows.
  Use when choosing a workflow, coordinating multi-stage work, or resolving overlap
  between skills. Load only relevant procedures and preserve task authorization.
---

# Using Skills

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before human-facing text.
Choose the primary skill from the requested outcome. Load supporting skills only
when their procedure is needed; do not read every skill or force a full lifecycle.
Follow explicit user requests and repository instructions. Skill links route work;
they do not install dependencies, authorize new actions, or spawn agents.

| Task | Primary skill |
| --- | --- |
| Clarify goals or challenge assumptions | [decision-partner](../decision-partner/SKILL.md) |
| Investigate and produce a plan | [agent-planning](../agent-planning/SKILL.md) |
| Build an accepted plan through verification and final review | [implement-plan](../implement-plan/SKILL.md) |
| Implement or simplify code | [writing-clean-simple-code](../writing-clean-simple-code/SKILL.md) |
| Diagnose and repair unexpected behavior | [root-cause-debug](../root-cause-debug/SKILL.md) |
| Write behavioral tests | [test-authoring](../test-authoring/SKILL.md) |
| Design shared contracts | [api-design](../api-design/SKILL.md) |
| Write documentation or decision records | [technical-documentation](../technical-documentation/SKILL.md) |
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

When skills reference each other, reuse already-loaded guidance and evidence rather
than recursively restarting workflows. In testing/debugging, retain the current
reproduction and task scope. Do not re-run unchanged verified work solely because
a handoff occurred; reopen coverage after relevant changes or new contradictory evidence.

If a required skill or tool is unavailable, state the limitation and use a scoped
fallback when possible. Never claim a missing procedure, independent review, live
check, or deployment occurred. Use delegation only when permitted and useful,
with raw intent and the exact candidate; do not create personas merely to route tasks.
