# PR Descriptions

## Gather Evidence

Read the repository's actual PR template and applicable title/body instructions.
Preserve required fields, sections, and checkboxes. Inspect the final diff against
its merge base and relevant commits. Establish the concrete problem, resulting
behavior, real ticket when present, and verification actually performed.

## Draft the Body

Without a required template, default to this structure:

```markdown
## TL;DR

- [Resulting behavior and why it matters.]

## Validation

- [Check actually run and its result.]
```

Use as many short, high-level TL;DR bullets as the change needs, without a fixed
limit. Explain resulting behavior and why it matters, not files, helpers, or work
history. If a repository template requires `Summary` or another heading, retain
that heading and use the same TL;DR-style bullets beneath it. Preserve its other
required fields and checkboxes. Remove the collapsed section when it adds nothing;
do not repeat the diff or call it a full changelog. For a tiny change, keep only
the structure required by the repository template. Template comments are guidance,
not PR content: remove unused comments and placeholders from the final description.

In Validation, report checks actually run against the final candidate. Use one
bullet for each distinct result when there are two or more; combine closely related
checks with the same outcome. Report failed checks honestly. Include a command,
test count, file name, or function name only when it helps the reviewer understand
or reproduce the result. Do not copy the detailed evidence block into the PR. If
no checks ran, say so plainly. Do not inventory unrun checks or put deployment or
checklist status in Validation.

Keep a material caveat visible between Validation and the collapsed details. Use
a brief GitHub alert for context such as a rollout dependency:

```markdown
> [!NOTE]
> [Material caveat.]
```

Use `[!WARNING]` instead for a genuine blocker or significant risk. Omit the alert
when there is no material caveat; do not hide blockers in the disclosure. Keep
implementation decisions, tradeoffs, and migration notes in the optional
`<details><summary>Implementation details</summary>` section. Add it only when
there is useful context, with blank lines around Markdown inside the tags:

```markdown
<details>
<summary>Implementation details</summary>

[Reviewer-relevant decisions, tradeoffs, or migration notes.]

</details>
```

Use other formatting only when it makes the change easier to review: a small
before/after table for changed behavior or compatibility, screenshots or a short
recording for UI changes, a Mermaid diagram for a complex flow, syntax-highlighted
code for a relevant example, and links to exact issues or decisions instead of
repeating background. Do not add these to every PR or use formatting as decoration.
Do not rely on retired GitHub tasklist blocks; preserve ordinary checkboxes when
the repository template requires them.

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
ran. Reassess earlier checks after material edits or conflict resolutions.

When the repository requires an AI assistance disclosure, use the tool and model
identified by the user or trusted session context. Reuse a known model name rather
than replacing it with "unknown." Do not guess unavailable model information.

## Check the Exact Draft

Read the title and body against the final diff and verification evidence. Remove
empty optional template sections and claims that add no useful context. Keep
identifiers in backticks and useful code examples in language-tagged fences. Check
the rendered structure: template headings, blank lines around lists and inside
`<details>`, and standard Markdown bullets. Split any Validation paragraph that
packs multiple results into bullets. Remove details that merely repeat CI, the
checklist, or another section.
Resolve any contradiction between prose and a checkbox before publication; do not
guess which status is true.
Follow the calling workflow's publication authorization; do not post a draft as
a side effect of writing it.
