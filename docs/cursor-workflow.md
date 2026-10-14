# Cursor Workflow Example

Follow a planned feature from requirements through implementation, verification,
and independent review. Cursor is the example host. Other flavors may use different
controls or review tools while preserving the same skill contracts and authorization
boundaries. Small, understood changes can start with the relevant skill directly.

This guide describes the instructed workflow. A live Cursor validation run has not
been recorded, so it is not yet a verified end-to-end example.

## Before You Start

Install and activate the collection using the [Cursor setup instructions](../README.md#cursor).
Open your target repository in Cursor, check its instructions and existing changes,
and use a task branch suitable for implementation. Confirm that the installed
collection exposes its skills, routing rule, and independent reviewer.

Choose a small feature with observable acceptance criteria, such as rejecting blank
names in an existing form. Use the repository's actual test and build commands.
Jira is optional; reading an issue requires a configured connection.

## 1. Plan the Change

In Plan mode, describe the feature and request:

```text
Use agent-planning to plan this feature. Include acceptance criteria,
verification, and the implement-plan handoff. Do not implement yet.
```

For Jira work, first ask `jira-tickets` to read the issue in intake mode. Supply
the issue's requirements to planning without authorizing tracker writes.

Expect a plan grounded in the repository, with ordered tasks, acceptance criteria,
verification commands, unresolved decisions, and final independent review. The plan
itself must carry the `implement-plan` handoff so a later executor receives it.
Resolve decisions that would change the intended behavior before dependent work.

## 2. Authorize Implementation

Review the plan, then request Build in the same chat:

```text
Implement the accepted plan using implement-plan, including verification
and final independent code-review.
```

If starting a new chat, provide the source requirements, accepted plan, relevant
decisions, and authorization already given. If the host misses the handoff, name
`implement-plan` explicitly.

Expect scoped implementation and evidence from the actual repository checks.
For behavioral code changes, the workflow requires an observed failing behavioral
assertion before production implementation, followed by passing checks and affected
checks after refactoring. Documentation-only changes use document validation.

If a check fails, investigate the cause before advancing. An unrelated failure or
unavailable runner must be reported accurately; neither counts as passing evidence.

## 3. Review and Repair

The implementation workflow requests final independent `code-review` in fresh
context unless you explicitly skip it. The reviewer receives the source requirements,
repository instructions, comparison base, and exact candidate, including relevant
working and untracked files. Author reasoning and the plan are not proof of correctness.

Expect a read-only review with findings, coverage, and material limits. The reviewer
instructions do not create a tool sandbox. Confirm that Cursor can provide a fresh
reviewer context; merely having the reviewer file installed does not establish this.
If independent review is unavailable, the agent must report the gate as incomplete.

For supported findings, expect scoped repairs, affected checks, and independent
re-review of the complete candidate after material changes. Unresolved findings
remain visible in the result. A completed task list or an implementer's self-review
does not replace independent review.

## 4. Inspect the Result and Request Delivery

Expect a final report describing the change, checks actually run, review coverage,
and remaining limits. Inspect the diff against the acceptance criteria.

If you want Git delivery and have not already authorized it, request it explicitly:

```text
Commit the verified changes, push the branch, and open a PR.
```

Existing authorization carries forward; an unchanged authorized action does not
need another confirmation. Build alone does not authorize commits, pushes, external
replies, or deployment. PR publication follows `git-delivery` and its exact-draft
approval requirements. GitHub reviews and approvals are never dismissed.

## Verification Record

The live workflow remains unverified. When exercising this guide in a safe test
repository, record the following evidence before describing it as verified in Cursor:

| Item | Evidence to retain |
| --- | --- |
| Environment | Date, Cursor version, skill revision, and target repository revision. |
| Discovery | Skills, routing rule, and reviewer visible after activation. |
| Planning | Request and saved plan containing acceptance criteria and execution handoff. |
| Implementation | Candidate diff and actual failing/passing test output for behavioral changes. |
| Review | Fresh reviewer context, reviewed candidate, findings, and any repair/re-review evidence. |
| Completion | Final report, unmet gates, and actions performed within authorization. |

A successful recorded run establishes that scenario in that Cursor environment.
It does not establish every workflow or other hosts' behavior. Package validation
and installer tests separately establish structural checks and file placement.
