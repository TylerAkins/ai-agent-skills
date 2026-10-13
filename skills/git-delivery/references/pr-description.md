# PR Descriptions

## Gather Evidence

Read the repository's actual PR template and applicable title/body instructions.
Preserve required fields, sections, and checkboxes. Inspect the final diff against
its merge base and relevant commits. Establish the concrete problem, resulting
behavior, real ticket when present, and verification actually performed.

## Write Proportionally

Without a required template, default to this structure:

```markdown
## Summary
[A short paragraph explaining the problem and resulting behavior.]

## Validation
[Meaningful checks actually performed and any material verification limits.]
```

For a tiny change, a single paragraph is enough. For a larger change, use a few
bullets under Summary when they make distinct outcomes easier to scan. Add rollout
or compatibility notes only when relevant. Do not repeat Summary under a separate
Changes section or add empty sections, generic checklists, or routine Next Steps.
If no checks were performed, say so plainly rather than inventing validation.

Do not generate checkboxes unless the repository template or user requests them.
Describe completed verification in ordinary prose. For required checkboxes, mark
only scenarios actually executed and still applicable to the final candidate;
leave unperformed ones unchecked. Do not convert proposed checks into achievements.

Describe behavior and reviewer-relevant impact rather than listing edited files,
internal steps, or every helper. Include a concrete before/after example when it
clarifies the change. Mention interfaces and flags only when they help assess it.
Omit conversational history, abandoned approaches, repeated outcomes, praise, and
generic test/build/lint boilerplate already visible in CI. Retain required template
content even when it overlaps CI.

Include material blockers, unmet acceptance criteria, compatibility limits, and
necessary rollout or backfill conditions. Keep operational notes brief. Distinguish
observed checks from unverified behavior; unit tests or dry runs do not establish
that a browser or live workflow was exercised. Reassess earlier checks after
material edits or conflict resolutions. Include available UI evidence when useful;
its absence need not block drafting.

## Check the Exact Draft

Read the title and body against the final diff and verification evidence. Remove
empty optional template sections and claims that add no useful context. Keep
identifiers in backticks and useful code examples in language-tagged fences.
Follow the calling workflow's publication authorization; do not post a draft as
a side effect of writing it.
