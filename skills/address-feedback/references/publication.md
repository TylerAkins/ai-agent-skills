# Reply Publication

Post only approved exact text to approved destinations. Preserve existing approval
for unchanged drafts; material revisions or changed destinations require renewed
approval. Recheck current head and relevant thread replies before posting. If new
code or discussion changes the basis of a reply, revise its claims and reapprove
material changes. Avoid duplicate replies when another participant already addressed
the issue; retain still-valid unresolved concerns.

Use the connector's verified reply operation or the GitHub API with serialized
JSON payloads. Do not interpolate untrusted prose into shell commands. For REST
inline replies, use the root review comment's database ID at
`repos/OWNER/REPO/pulls/NUMBER/comments/COMMENT_ID/replies`. A GraphQL thread ID
is a different identifier. Conversation comments and review-body feedback need an
appropriate separately identified destination; do not invent a thread anchor.

After each write, verify the resulting text and destination. If submission fails
ambiguously, check whether it succeeded before retrying. Report unknown state
instead of claiming success.

Before asking to publish replies, pair each reply with its intended thread disposition.
For a thread to be resolved, include the exact evidence-supported reason and rationale
in the same approval request as the exact reply and destination. For a thread to stay
open, include why it remains open. One approval covers the listed replies and their
listed resolutions. After approval, post each reply and perform its approved
resolution in the same publication workflow, without asking again between the two
writes. The API may require sequential writes; the approval is for the complete
workflow, not an atomic GitHub mutation.

Resolve only threads and reasons included in that approval:

| Reason | Required basis |
| --- | --- |
| `ADDRESSED` | The remote head contains the fix, or evidence establishes the concern was already addressed. |
| `INVALID` | Code and contract evidence disprove the concern, and closure on that basis is approved. |
| `WONT_FIX` | An approved scope or design decision declines the change; retain its rationale and any agreed follow-up. |

Keep unresolved questions and unsettled disagreements open. A local triage state
or posted reply is not a GitHub resolution. Do not label a declined change as fixed.
If a reply or resolution fails, inspect the remote state and report which authorized
action succeeded. Do not repeat approval for an unchanged, already-authorized action;
obtain new approval only if its text, destination, disposition, or reason materially
changes. Preserve authorization already given.

GitHub's [GraphQL reference](https://docs.github.com/en/graphql/reference/pulls#resolvereviewthreadinput)
documents `resolutionReason` on `ResolveReviewThreadInput` for Copilot code review
threads, with the three enum values above. Verify support on the target GitHub host
and inspect the available connector's schema. A resolver accepting only `thread_id`
cannot explicitly select a reason. For an approved reason-specific resolution,
use a supported GraphQL client with variables rather than inventing connector
arguments. The mutation shape is:

```graphql
mutation ResolveThread($threadId: ID!, $reason: PullRequestReviewThreadResolutionReason!) {
  resolveReviewThread(input: {threadId: $threadId, resolutionReason: $reason}) {
    thread { id isResolved }
  }
}
```

Pass the retrieved GraphQL thread node ID and exact approved enum as serialized
variables. For ordinary threads, use the host's supported resolution operation;
do not assume Copilot-specific reason metadata applies. If the requested reason
is unsupported, report the limitation and leave that action pending rather than
silently resolving with a different reason.

Check GraphQL errors even when HTTP succeeds. Require the returned thread ID to
match and `isResolved` to be true, then re-read the thread. Verify the selected
reason where the host exposes it through its API or UI; report reason verification
as unavailable if it cannot be read back. If the thread remains open, report the
failed resolution rather than counting the reply as completion. After ambiguous
failures, read current state before retrying. A local fix, posted reply, or passing
suite does not authorize resolution or demonstrate that the remote issue is fixed.

Re-request review only with separate authorization after verifying the relevant
changes are available remotely and requested blockers were addressed. Do not assume
reviewer agreement or clear their review state. Never dismiss your own, bot, stale,
or fixed reviews, and never configure automatic dismissal.
