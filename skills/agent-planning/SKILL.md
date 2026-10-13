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
   fixes where feasible. Identify independent review needs without claiming review
   occurred or automatically spawning agents.

### Task Template

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
    already authorized, hand the plan back to the calling delivery workflow and
    continue authorized work there without asking for approval again. An unresolved
    decision blocks only dependent work. Creating a plan does not itself authorize
    implementation, commits, pushes, or publication.
