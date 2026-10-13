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

Resolve only separately approved threads after confirming the remote head contains
the fix or evidence establishes the concern was already addressed. Keep unresolved
questions and disagreements open. Use the retrieved thread ID and verify the
resulting resolution state. A local fix, posted reply, or passing suite does not
authorize resolution or demonstrate that the remote issue is fixed.

Re-request review only with separate authorization after verifying the relevant
changes are available remotely and requested blockers were addressed. Do not assume
reviewer agreement or clear their review state. Never dismiss your own, bot, stale,
or fixed reviews, and never configure automatic dismissal.
