# PR Descriptions

## Gather Evidence

Read the repository's actual PR template and applicable title/body instructions.
Preserve required fields, sections, and checkboxes. Inspect the final diff against
its merge base and relevant commits. Establish the concrete problem, resulting
behavior, real ticket when present, and verification actually performed.

## Draft the Body

Without a required template, default to this structure:

```markdown
## Summary
[A short paragraph explaining the problem and resulting behavior.]

## Validation
[Meaningful checks actually performed and any material verification limits.]
```

Write a short Summary that explains the problem and resulting behavior. Add a
rollout dependency, backfill, blocker, or compatibility limit only when the reviewer
needs it to assess the change. Describe the behavior rather than listing files,
helpers, or work history. State each fact once. Skip routine disclaimers about what
a PR itself does not do, repeated outcomes, empty sections, and generic Next Steps.
For a tiny change, one paragraph is enough when the template permits it.

In Validation, report checks actually run against the final candidate. Use one
bullet for each distinct result when there are two or more; combine closely related
checks with the same outcome. Give a failed check or material untested behavior its
own bullet. Include a command, test count, file name, or function name only when it
helps the reviewer understand or reproduce the result. Do not copy the detailed
evidence block into the PR. If no checks ran, say so plainly. Mention an unrun live
or integration check only when it would reasonably be expected or changes the risk
assessment. Do not put deployment or checklist status in Validation unless it
limits what a reported check establishes.

For example, two completed results should scan like this:

```markdown
## Validation

- `poetry run ruff format --check` and `poetry run ruff check` passed.
- Targeted package-global tests passed with `poetry run pytest`.
```

Use checkboxes only for tracked tasks required by the repository template or user.
Mark a required box only when that task was completed and still applies to the final
candidate. Leave unperformed tasks unchecked. Do not repeat checklist status in
prose or turn a planned check into a completed result.

Keep material blockers and unmet acceptance criteria visible. Distinguish tested
behavior from expectations: unit tests and dry runs do not prove a live workflow
ran. Reassess earlier checks after material edits or conflict resolutions. Include
UI evidence when it helps assess a user-facing change.

When the repository requires an AI assistance disclosure, use the tool and model
identified by the user or trusted session context. Reuse a known model name rather
than replacing it with "unknown." Do not guess unavailable model information.

## Check the Exact Draft

Read the title and body against the final diff and verification evidence. Remove
empty optional template sections and claims that add no useful context. Keep
identifiers in backticks and useful code examples in language-tagged fences. Check
the rendered structure: template headings, blank lines around lists, and standard
Markdown bullets. Split any Validation paragraph that packs multiple results into
bullets. Remove details that merely repeat CI, the checklist, or another section.
Resolve any contradiction between prose and a checkbox before publication; do not
guess which status is true.
Follow the calling workflow's publication authorization; do not post a draft as
a side effect of writing it.
