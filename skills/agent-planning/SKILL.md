---
name: agent-planning
description: >-
  Investigate coding requirements and turn them into an ordered, verifiable
  implementation plan. Use when asked to plan a feature, ticket, or significant
  change, assess an approach, or break work into tasks. Does not implement the plan.
---

# Agent Planning

## Scope

Produce a plan grounded in requirements and repository evidence. Keep small,
understood changes brief; use explicit tasks for work with dependencies or risk.
Planning authorizes investigation and plan artifacts, not implementation,
commits, pushes, or external tracker updates.

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting the plan or
report. Use the project's planning conventions and Cursor's native plan artifact
when available. Otherwise, use a Markdown plan in the project's designated
location, or present it in chat when no saved artifact is needed. Do not overwrite
unrelated incomplete plans or edit user-protected plans; present proposed changes
separately.

## Investigate Before Planning

For Jira requirements, use [jira-tickets](../jira-tickets/SKILL.md) in intake mode.
For consequential unresolved intent, use [decision-partner](../decision-partner/SKILL.md).
For shared interface decisions, use [api-design](../api-design/SKILL.md). These are
supporting procedures, not mandatory stages; retain established intent and evidence.

1. Establish the intended behavior, scope, exclusions, and acceptance criteria from
   the user's requirements and accepted decisions. Cite their sources. Separate
   requirements from assumptions and unresolved decisions.
2. Read repository instructions and inspect existing working changes. Trace the
   actual execution path, producers, consumers, analogous code, tests, and relevant
   dependency versions. Verify unfamiliar APIs against those versions.
3. Identify affected contracts, authorization and tenant boundaries, migrations,
   concurrency concerns, and rollback risks where relevant. Preserve unrelated work.
4. Resolve uncertainty from evidence where possible. For a behavior-changing choice
   that requires user input, mark it as needing a decision and identify dependent
   tasks. Continue independent investigation without treating silence as acceptance.

## Break Work Into Verifiable Tasks

5. Describe the proposed approach and why it satisfies the requirements. Record
   consequential decisions, alternatives when useful, risks, and open questions.
6. Map dependencies and order tasks accordingly. Prefer complete, testable behavior
   slices. Investigate risky unknowns early, before tasks depend on them.
7. Give each task the information needed to implement and verify it:
   - Intended outcome and specific acceptance criteria.
   - Likely files, grounded in repository evidence.
   - Dependencies and shared interfaces or contractual values.
   - Relevant verification commands, package directories, and observable success criteria.
   Mark unverified paths, signatures, or commands explicitly. Avoid speculative code
   bodies and arbitrary task sizes; split tasks when they mix independent outcomes
   or cannot be verified meaningfully as a unit.
8. Include integration checks and review checkpoints proportional to the risk.
   For changed authorization, cover applicable allow/deny, wrong-user or tenant,
   missing-identity, and preserved behavior. Plan regression sensitivity for bug
   fixes where feasible. Include final independent whole-candidate review and
   affected verification/re-review after material repairs in the plan and executable
   todos, unless the user explicitly skips review. Identify unavailable review as
   a limit, not a completed step. Planning does not claim review occurred or spawn
   reviewers merely to schedule this later implementation gate.

### Task Template

Include an execution handoff in the generated plan itself, including native Cursor
plan artifacts. Do not leave it only in chat or these skill instructions. Use:

> Once implementation is authorized, execute this plan using `implement-plan`,
> including meaningful verification, final independent `code-review`, and affected
> checks and independent re-review after material repairs. Commit and push only
> when explicitly authorized. Report unavailable independent review as incomplete.

Carry any explicit review skip or existing Git authorization into the handoff
accurately. Include source requirement pointers and the final review/repair tasks
in the plan so a Build or separate-session executor receives the same contract.
The handoff is an instruction for later execution, not permission to start from
a planning-only request.

Use this structure when explicit tasks help. Adapt it to the project's native
plan format rather than creating a duplicate checklist.

```markdown
### Task 1: [Observable outcome]

Approach: [Concrete changes and relevant contracts]
Files: [Verified paths; label uncertain paths]
Depends on: [Task IDs or none]

Acceptance criteria:
- [ ] [Specific behavior, including relevant boundaries or failure cases]

Verification: [Command and working directory, or manual check]
Expected result: [What demonstrates success]
Needs decision: [Unresolved choice and what it blocks, or none]
```

## Reconcile and Deliver

9. Check the plan against source requirements and the inspected execution path.
   Look for omissions, conflicting values, mismatched producer/consumer contracts,
   and checks that cannot establish the intended behavior. Keep the plan body and
   any executable task list consistent; avoid maintaining duplicate task lists.
10. Revise contradictions before presenting the plan as ready. State unresolved
    decisions, blocked tasks, and verification limits. Distinguish checks already
    performed during investigation from checks proposed for implementation.
11. Deliver the plan with its current decisions and verification limits. For a
    planning-only request, stop without implementation. If implementation is
    already authorized, hand the accepted plan and source requirements to
    [implement-plan](../implement-plan/SKILL.md), which coordinates implementation,
    verification, and required final independent review without asking for approval
    again. This skill remains planning-only. An unresolved
    decision blocks only dependent work. Creating a plan does not itself authorize
    implementation, commits, pushes, or publication.
