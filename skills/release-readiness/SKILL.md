---
name: release-readiness
description: >-
  Assess a specific release, prepare staged rollout and recovery, and verify
  production outcomes. Use when asked whether a change is ready to ship, to prepare
  a launch, or to conduct an authorized rollout. Readiness assessment does not
  authorize deployment, feature activation, rollback, or external announcements.
---

# Release Readiness

Never dismiss reviews or approvals or configure automatic stale-review dismissal
to clear a release gate. Preserve history; request re-review only when authorized.

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting plans or reports.
Coordinate the release using existing project procedures. Keep checks proportional
to the product and risk; do not impose web-only checks on libraries or fixed rollout
percentages and waiting periods on every service.

## Identify the Release and Authorization

Resolve the repository, source revision, artifact/version and digest when available,
target environment, changes being released, and intended user exposure. Distinguish
deploying code, enabling behavior, publishing a package, and retiring old behavior.
Inspect repository instructions, release runbooks, CI evidence, configuration,
environment protections, and relevant incidents.

Establish the requested actions and preserve existing authorization. Planning or
assessment does not authorize live changes. Before requesting missing execution
approval, prepare the concrete candidate, destination, rollout, and recovery plan.
Do not treat a general launch request as permission to bypass protections, make
unrelated infrastructure changes, or send unseen announcements.

## Assess Readiness Against Evidence

Identify applicable acceptance criteria, required checks and reviews, compatibility
obligations, and operational prerequisites. Verify evidence belongs to the candidate
and intended environment. A green build or prior release does not prove the current
release is ready. Reassess coverage after material changes.

Check relevant failure modes, security and tenant boundaries, performance/capacity,
accessibility for affected user interfaces, configuration, credentials, and critical
user flows. Use actual project budgets and requirements. State missing evidence
instead of inventing universal thresholds or declaring all checklist items mandatory.

Use [ci-cd-workflows](../ci-cd-workflows/SKILL.md) for pipeline mechanics,
[safe-migrations](../safe-migrations/SKILL.md) for data or contract transitions,
[test-authoring](../test-authoring/SKILL.md) for coverage gaps, and
[code-review](../code-review/SKILL.md) for required candidate review.
These procedures support readiness; invoking them does not establish completion.

Record the candidate and target, each applicable required gate and its actual
result, and any missing or failed evidence. Reuse check results only when they cover
the same candidate and the conditions they claim to verify; rerun affected checks
after material changes. Apply the project's requirements rather than imposing a
clean worktree, a test count, or a generic command list on every release. Record a
supported disposition: ready for the identified next stage, blocked by named
requirements, or incomplete because evidence is unavailable. Keep readiness
separate from permission to execute and from final production success.

## Prepare Rollout and Recovery

Define ordered stages with the artifact, target cohort, responsible owner, verification,
advance/hold/abort criteria, and recovery action. Follow configured SLO and error-budget
policy when present; do not invent one or override an exhausted-budget policy.
If missing policy creates a consequential decision, surface it before dependent work.

Choose direct, canary, staged, or flag-controlled exposure according to risk and
existing infrastructure. A feature flag is optional machinery, not a substitute
for compatible deployment. When used, verify both states, cohort selection, kill
switch limitations, owner, and cleanup conditions.

For canaries, compare relevant errors, latency, resource use, and business outcomes
with a representative baseline. Check telemetry freshness, sample size, traffic mix,
and background or delayed effects. Select observation windows based on usage cycles
and available signal. No traffic or missing telemetry cannot demonstrate success.

Prepare actionable recovery steps tied to the deployed artifact and state. Distinguish
flag disablement, traffic reversal, code rollback, and data restoration or forward
repair. Confirm prerequisites, permissions, expected recovery time when measured,
and irreversible boundaries. Rehearse safely when authorized; label untested procedures.
Do not claim that reverting a commit or deploying an old binary reverses data changes.

## Execute Only the Authorized Stages

Immediately before execution, recheck candidate identity, current environment state,
required evidence, protections, and authorization. Stop if changes invalidate the plan
or require an unresolved decision. Preserve prior approval for unchanged supported
actions; obtain approval only for genuinely added scope or materially changed actions.

Use existing deployment mechanisms and promote the verified artifact. Record actual
run, version, environment, cohort, and status. Verify deployment success separately
from user exposure and application health. Advance only when the stage's evidence
supports its criteria; do not auto-expand a canary merely because the job passed.

If criteria fail, hold progression and follow authorized recovery. Without recovery
authorization, report the concrete required action and continue safe diagnosis.
Use [root-cause-debug](../root-cause-debug/SKILL.md) for investigation. Do not retry
ambiguous deployment or publication results until checking whether the action succeeded.

## Verify Outcomes and Close the Release

Check critical behavior, observability, relevant service metrics, and compatibility
after exposure. A health endpoint alone cannot establish that the user flow works.
Track known issues and delayed-effect checks with an owner and handoff. If a requested
observation period extends beyond this run, use authorized monitoring or an explicit
handoff; do not claim the period completed or imply unattended monitoring exists.

Report what was assessed, deployed, enabled, published, or recovered, citing actual
evidence and remaining limits. Keep required release notes proportional and accurate.
External announcements require approved text and destinations. Git actions and PRs
use authorized [git-delivery](../git-delivery/SKILL.md). Cleanup of flags or retired
paths follows its own scope and readiness, not an arbitrary post-launch deadline.

## Anti-Rationalization Guardrails

| Model Rationalization | Enforced Rule |
| --- | --- |
| CI passed, so the release is ready. | Tie required checks, reviews, compatibility, and operational evidence to the identified artifact and target stage before declaring readiness. |
| The deployment job succeeded, so the rollout succeeded. | Verify user exposure and stage health against the agreed criteria before advancing or reporting success. |
