# Collection and Reviewer Profiles

## Collect Feedback With Context

Resolve the exact repository and handle. Bound the candidate search and record its
query, order, budget, and exclusions. A reviewed-by search may miss PRs where the
person only left conversation comments; disclose this instead of claiming complete
activity history. Increase the budget only when warranted and within the request.

Retrieve relevant review bodies, paginated threads with nested replies, and PR
conversation comments. Capture stable comment IDs, URLs, author/date, and original
commit associations. Check pagination and retrieval failures explicitly. Record
partial retrieval as partial and stop rather than silently constructing a complete
profile from it.

Read historical inline feedback against its associated version. Current head and
trimmed diff hunks are not substitutes for historical surrounding code. If the
historical tree or resolution context is unavailable, mark it unknown. Distinguish
a fix, a scoped exception, disagreement, and an unknown outcome using actual replies
and code evidence. Do not count multiple replies on one concern as independent precedents.

## Profile Contents

Record repository, reviewer, fetch time, requested/actual sample, candidate budget,
search/scanned counts, stop reason, covered PR versions, and missing context.

For each pattern, keep:

- Concrete concern, triggering conditions, and repository scope.
- Distinct PR and comment counts with source links and brief evidence excerpts.
- Outcomes and counterexamples, including rejected or superseded feedback.
- Explicit waivers with their source and exact conditions.
- Evidence strength and unresolved historical limits.

Keep historical patterns separate from predictions about a particular candidate.
Do not create a “not flagged” category from silence. Store concise evidence and
source pointers rather than full private diffs, secrets, or unrelated personal data.

## Freshness

Deduplicate updates by stable comment identity and distinct PR. Recheck activity
and outcomes on sampled PRs when using a profile for new work; record what was
actually refreshed. PR-number-only cutoffs miss later discussion on older PRs.
Refresh stale or contradicted patterns and rebuild on `--refresh`. Keep an existing
profile intact until replacement collection succeeds, marking stale or partial
evidence clearly if a refresh fails.
