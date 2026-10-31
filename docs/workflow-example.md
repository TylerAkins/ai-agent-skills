# Take a planned change through independent review

Use this walkthrough for a small change in an existing repository, such as
rejecting a blank name in a form. The outcome is a scoped diff, verification
results, and an independent review. Delivery remains a separate action.

This describes the skills' instructed workflow. It is not a recorded end-to-end
host test. Client controls differ; the requests below work as ordinary task text.

## Prepare the repository

1. [Install the skills](../README.md#install), activate them in your host, and check discovery.
2. Open the target repository. Read its instructions and inspect existing changes.
3. Use a task branch and identify the project's real test/build commands.
4. Confirm that a fresh reviewer context is available if the task requires independent review. Install the optional agent definitions when your host needs them.

Jira is optional. If requirements come from an issue, ask
[jira-tickets](../skills/jira-tickets/SKILL.md) to read it in intake mode. Reading
an issue does not authorize tracker writes.

## Plan the behavior

Request planning before authorizing implementation:

```text
Use agent-planning to plan validation for the existing name field.
Reject blank or whitespace-only names and preserve valid existing behavior.
Include acceptance criteria, verification, and an implementation handoff.
Do not implement yet.
```

Expect source-backed requirements, ordered tasks, checks, unresolved decisions,
and an `implement-plan` handoff. Resolve choices that affect behavior before
starting dependent work. A plan is a proposal to verify against the repository.

## Implement the accepted plan

After reviewing the plan, request:

```text
Use implement-plan to implement the accepted plan, including verification
and final independent review. Preserve unrelated changes.
```

When moving to another chat, include the source requirements, accepted decisions,
plan, and authorization already given.

For this behavior change, expect a focused test that fails on the original
implementation and passes after the fix. If that baseline cannot run safely or
meaningfully, the agent must state the reason and choose the strongest available
before/after evidence before editing. Refactoring uses passing baselines;
documentation uses document checks. A failed or unavailable check remains visible.

## Review and repair

The [implementation skill](../skills/implement-plan/SKILL.md) requires fresh,
read-only [independent review](../skills/code-review/SKILL.md) unless you explicitly
skip it. The reviewer receives original requirements, repository instructions,
comparison base, and the exact candidate, including relevant untracked files.
The author's explanation is not evidence that the change is correct.

Expect findings tied to observable defects, review coverage, and limits. The
agent should verify supported findings, repair them, rerun affected checks, and
obtain independent re-review after material changes. If fresh review is unavailable,
the final report must leave that gate incomplete. A self-review is not a replacement.

## Inspect the result

Compare the diff with the acceptance criteria. Check the final report for actual
verification, review coverage, and remaining gaps. When you want Git delivery,
authorize the relevant actions explicitly:

```text
Commit the verified changes, push this branch, and prepare a draft PR.
```

Existing authorization carries forward. PR publication follows
[git-delivery](../skills/git-delivery/SKILL.md), including exact-title/body approval
when still needed. Implementation does not itself authorize publication, external
replies, or deployment. Reviews and approvals are never dismissed.

## Record a host test

To turn this walkthrough into a verified example, retain evidence from a safe
representative repository:

| Stage | Evidence |
| --- | --- |
| Environment | Host/version, skill revision, target revision, and date. |
| Discovery | The host exposes the required skills and reviewer. |
| Plan | Original request, accepted criteria, and execution handoff. |
| Implementation | Candidate diff, commands, actual results, and baseline evidence. |
| Review | Fresh context, reviewed candidate, findings, and repair/re-review results. |
| Completion | Final report, unresolved gates, and authorized actions actually performed. |

One successful run establishes that scenario in that environment. Package builds
and installer tests establish different evidence: structure and file placement.
See [host evidence limits](host-compatibility.md#behavioral-evidence-and-limits).
