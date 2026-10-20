# PR Descriptions

## Gather Evidence

Read the repository's actual PR template and applicable title/body instructions.
Preserve required fields, sections, and checkboxes. Inspect the final diff against
its merge base and relevant commits. Establish the concrete problem, resulting
behavior, real ticket when present, and verification actually performed.

## Write Proportionally

Do not hard-wrap prose to a fixed column width or character limit. Keep each
paragraph as one continuous Markdown paragraph and let GitHub wrap it to the
reader's display. Host or editor line-length defaults, including OpenCode defaults,
do not apply to PR prose. Preserve line breaks required for Markdown structure,
such as headings, list items, table rows, and fenced code.

Without a required template, default to this structure:

```markdown
## Summary
[A short paragraph explaining the problem and resulting behavior.]

## Validation
[Meaningful checks actually performed and any material verification limits.]
```

Default to one short Summary paragraph and a brief Validation section. For a tiny
change, a single paragraph is enough when the template permits it. For several
distinct outcomes, use a few concise bullets instead of dense paragraphs. Expand
only when complexity, compatibility, or material risk needs explanation. Add rollout
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
Report meaningful behavioral evidence and material limits rather than an exhaustive
list of tools, suite counts, or independent-review recaps. Keep detailed verification
records in chat or linked evidence unless the repository requires them.
Omit conversational history, abandoned approaches, repeated outcomes, praise, and
generic test/build/lint boilerplate already visible in CI. Retain required template
content even when it overlaps CI.

Include material blockers, unmet acceptance criteria, compatibility limits, and
necessary rollout or backfill conditions. Keep operational notes brief. Distinguish
observed checks from unverified behavior; unit tests or dry runs do not establish
that a browser or live workflow was exercised. Reassess earlier checks after
material edits or conflict resolutions. Include available UI evidence when useful;
its absence need not block drafting.

When the repository requires an AI assistance disclosure, use the tool and model
identified by the user or trusted session context. Reuse a known model name rather
than replacing it with "unknown." Do not guess unavailable model information.

## Check the Exact Draft

Read the title and body against the final diff and verification evidence. Remove
empty optional template sections and claims that add no useful context. Keep
identifiers in backticks and useful code examples in language-tagged fences.
Check the rendered structure: use the template's heading levels, blank lines
around paragraphs and lists, standard Markdown bullets, and backticks for technical
identifiers. Keep related information together and remove long paragraphs that
repeat or obscure the outcome. Clean formatting should make the evidence easier
to assess, not add decorative sections or checkboxes.
Follow the calling workflow's publication authorization; do not post a draft as
a side effect of writing it.
