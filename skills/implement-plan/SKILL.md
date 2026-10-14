---
name: implement-plan
description: >-
  Execute an accepted implementation plan through scoped changes, meaningful
  verification, independent final review, and repairs. Use when asked to build or
  implement a plan, including a Plan-to-Build handoff. Preserve requirements and
  authorization; commit, push, and publication remain separate actions.
---

# Implement a Plan

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting text. Establish
implementation authorization from the user's request or host Build handoff. Do not
ask again for unchanged authorized work. A planning-only request does not authorize
implementation, and Build does not automatically authorize commits or remote actions.

## Establish Intent and Candidate

Read the accepted plan and its authoritative requirements, including accepted
decisions and unresolved choices. Use [jira-tickets](../jira-tickets/SKILL.md) in
intake mode when necessary issue context is missing. Inspect repository instructions,
branch/base, working changes, relevant execution paths, and dependency versions.
Preserve unrelated work and reuse suitable task context rather than restarting intake.

Verify plan paths, interfaces, contractual values, dependencies, and check commands
against the repository. Treat the plan as a proposal to reconcile, not proof of
correctness. Use [agent-planning](../agent-planning/SKILL.md) only for material gaps
or changes needing a revised plan. Do not rewrite user-protected plans; record
proposed changes separately. Pause only tasks dependent on unresolved intent or scope.

Confirm a suitable task branch before implementation in a Git repository, preserving
existing ancestry and changes. Follow repository branch conventions. Work on a
protected/shared integration branch only when the user specifically requests it;
resolve unsafe branch or isolation conditions before dependent edits.

## Implement and Verify Tasks

Execute tasks in dependency order using
[writing-clean-simple-code](../writing-clean-simple-code/SKILL.md). Load domain
procedures when needed: [api-design](../api-design/SKILL.md),
[frontend-engineering](../frontend-engineering/SKILL.md),
[safe-migrations](../safe-migrations/SKILL.md), or
[ci-cd-workflows](../ci-cd-workflows/SKILL.md). Do not load all skills or add scope
solely because a domain is mentioned.

Use [test-authoring](../test-authoring/SKILL.md) for independently justified behavioral
coverage. Run focused checks in verified package directories and confirm actual test
selection. Complete the Red-Green-Refactor assertion gate for behavioral code changes.
Investigate unexpected failures through [root-cause-debug](../root-cause-debug/SKILL.md), preserving
evidence and distinguishing introduced failures from unrelated ones.

Track actual task outcomes and material decisions in the existing plan or host task
artifact. Reconcile changes with requirements as evidence develops. Update affected
documentation through [technical-documentation](../technical-documentation/SKILL.md)
when the behavior or setup changes. Keep temporary diagnostics out of the final diff.

When committing is authorized, create local commits at coherent, verified checkpoints
using [git-delivery](../git-delivery/SKILL.md). Each commit should capture a complete,
reviewable change and pass applicable repository checks. Prefer checkpoints after
completed tasks or closely related task groups rather than a fixed time or file
count. Avoid accumulating unrelated completed tasks into one large commit. Preserve
unrelated work and do not commit incomplete work merely to reach a checkpoint.
Push only when separately authorized; local checkpoint commits do not require an
immediate push or replace final whole-candidate verification and independent review.

Before final review, inspect the complete candidate, including relevant untracked
files, for omissions, accidental changes, and contract mismatches. Run applicable
integration/build checks and browser verification for affected UI behavior. A completed
todo list or passing unrelated suite does not establish requirement coverage.

## Red-Green-Refactor Assertion Gate

For new behavior and bug repairs, the required state sequence is Red, Green, then
Refactor. Do not write production implementation before completing Red.

1. **Red:** Write the behavioral test and run the actual repository test runner
   against the unchanged implementation. Display the command, working directory,
   failing assertion output, and nonzero exit code before writing production code.
   Confirm the failure expresses the requested behavior. Syntax, import, setup,
   or unrelated failures do not satisfy Red; repair the test setup and rerun.
2. **Green:** Implement the behavior, run the selected tests and required surrounding
   checks, and display the actual runner output and exit code 0 with zero failures.
   Confirm the intended tests executed; zero selected tests cannot satisfy Green.
3. **Refactor:** Simplify only after Green. Rerun affected tests after refactoring
   and display the clean output and exit code 0 before declaring completion.

If execution is unavailable, stop dependent implementation and report the gate as
blocked with the missing prerequisite. Never fabricate output or weaken assertions.
For coverage of existing correct behavior or behavior-preserving refactoring,
record a passing baseline and demonstrate regression sensitivity in an isolated
copy before changing production code. Documentation-only changes use document
validation rather than an artificial failing behavioral test. A reproduction-only
request ends at observed Red and does not authorize a production repair.

## Independently Review the Complete Candidate

Final independent [code-review](../code-review/SKILL.md) is a required step unless
the user explicitly skips it. Use a fresh read-only reviewer when available and
permitted by the host. Supply repository instructions, source requirements and
accepted decisions, comparison base, and exact candidate including working/untracked
changes. Provide raw evidence, not author reasoning, the implementation plan as proof,
self-review conclusions, or suggested findings.

A task-level review does not replace whole-candidate review. If independent context
is unavailable or prohibited, perform a separate evidence-based assessment when useful,
disclose the limit, and leave independent review incomplete. An aborted, empty, or
partial attempt remains pending; do not reinterpret it as approval. Retry a failed
attempt when feasible without spawning redundant reviews of unchanged clean work.

Verify findings against actual triggers, consumers, and source contracts before
repairing. Make supported repairs within existing authorization. Resolve consequential
intent conflicts before dependent changes; retain unresolved or accepted deferred
findings explicitly. Rerun affected checks after repairs and independently re-review
the complete final candidate after material changes. A clean review covers only the
candidate and scope it actually assessed.

## Deliver Actual State

Reconcile requirements, final diff, checks, and review coverage. Report implemented
behavior, meaningful verification, remaining blockers, and unavailable checks/review.
Do not claim the required review gate is complete when only self-review occurred.
Preserve checkpoints across resumed work, validating them against current candidate
state rather than repeating unchanged verified work or trusting completion labels.

When explicitly authorized, use [git-delivery](../git-delivery/SKILL.md) for commits,
pushes, or PR preparation. Do not hide unmet required steps behind a delivery request;
report limits if the user asks to proceed despite them. Preserve approvals and review
history. Live deployment uses authorized
[release-readiness](../release-readiness/SKILL.md), not an automatic consequence of Build.

## Anti-Rationalization Guardrails

These rules govern phase transitions. Missing evidence leaves the gate incomplete;
do not substitute a declaration of confidence or silently waive a requirement.

| Model Rationalization | Enforced Rule |
| --- | --- |
| Implementing all steps in one giant batch saves tokens. | Execute dependency-ordered, independently verifiable tasks. Complete each task's checks before advancing to dependent work. |
| The fix is obvious, so failing tests can be skipped. | Investigate failures and complete the assertion gate. An expected outcome does not replace runner evidence. |
| I can leave debug code and logs for later. | Remove temporary diagnostics and inspect the complete diff before final review. Do not advance with cleanup deferred. |
| Local checkpoint commits require an immediate push. | Keep verified checkpoint commits local until pushing is separately authorized. |
