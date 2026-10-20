# GitHub Review Delivery

## Choose the Event

- Use `REQUEST_CHANGES` for confirmed blockers, including still-valid blockers in
  existing threads and findings without an inline anchor.
- Use `COMMENT` for non-blocking findings, suggestions, or questions without blockers.
- Withhold approval when required review or feedback coverage is incomplete.
- Use `APPROVE` only when completed review supports it and no actionable feedback remains.

An incomplete review can report supported findings; it cannot become a clean
approval by adding a caveat.

## Inline Findings

Use verified diff coordinates: `RIGHT` for new lines and `LEFT` for deletions.
Anchor an unchanged-file issue only on a changed line causing or participating in
it, naming the actual affected file. Never use an unrelated line to satisfy the API.
Keep the author mention in the body, not each inline comment.

Do not duplicate an existing finding merely to make a payload nonempty. If a
finding has no truthful anchor or existing thread, retain it in chat and keep
publication pending until the user approves a visible explanation and destination.

## Fixed Review Body

Resolve the PR author and authenticated poster from live metadata. Prefix the
body with `@[author-handle]`, then append one space and exactly one matching
sentence. Do not claim to act on behalf of another person or describe the skill
as private unless explicitly requested and factually supported:

| Event | Sentence |
| --- | --- |
| APPROVE | LGTM. |
| REQUEST_CHANGES | One issue to address before merging; comment inline. |
| REQUEST_CHANGES | Issues to address before merging; comments inline. |
| REQUEST_CHANGES | Unresolved issues remain in the review threads. |
| COMMENT | One question inline. |
| COMMENT | Questions inline. |
| COMMENT | One non-blocking suggestion inline. |
| COMMENT | Non-blocking suggestions inline. |
| COMMENT | One non-blocking issue inline. |
| COMMENT | Non-blocking issues inline. |
| COMMENT | Questions and non-blocking suggestions inline. |
| COMMENT | Questions and non-blocking issues inline. |
| COMMENT | Non-blocking issues and suggestions inline. |
| COMMENT | Questions, non-blocking issues, and suggestions inline. |
| COMMENT | Follow-up remains in the review threads. |

Match singular/plural wording and actual feedback types. Use thread wording for
existing feedback; do not imply new inlines when there are none. Add no headings,
summaries, checklists, CI recaps, praise, limitations, or extra conversation comment.
Keep material verification limits in chat. Only a direct user request for a
different published format overrides this contract; ordinary posting approval does not.

## Approval and Publication

Use read-only API calls to gather review evidence as needed. Before any external
write, present the exact event or action, text, and destination, and obtain user
confirmation under [anti-ai-writing](../../anti-ai-writing/SKILL.md). A request to
review a PR does not authorize publication.

Present the exact event, body, every inline or thread reply, and its destination.
When publication is requested or a posting draft is being offered, ask
“Would you like me to post this review?” and wait for approval. For drafting-only
requests, keep the draft local or in chat without prompting to post. Exclude
incomplete destinations or unsupported examples from approval requests.

Preserve existing approval for unchanged exact text and destinations. Before
presenting the final draft and immediately before posting, recheck head and base
SHAs. If they changed, inspect the affected delta and integration paths, recompute
coordinates, and revise the verdict. Obtain renewed approval for material changes.
Do not create pending reviews or upload pending inlines before approval.

Use the available GitHub connector or CLI without expanding publication scope.
Serialize approved payloads rather than interpolating comment text into shell code.
Validate event, body, reviewed SHA, paths, side, lines, and ranges against the
reviewed diff. Use the reviewed head SHA as `commit_id`; acknowledge that the remote
branch can change between validation and submission.

After posting, retrieve the resulting review and comments to verify actual text,
event, SHA, and locations. If a response fails ambiguously, check whether the post
exists before retrying. Report actual publication state.

Never dismiss any review, including your own, bot, stale, or fixed reviews, or
configure automatic dismissal. Replies, thread resolutions, and re-review requests
are separate actions requiring their own authorization. Preserve review history.
