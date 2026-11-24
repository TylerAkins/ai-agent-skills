# PR Descriptions

## GitHub Markdown

PR titles and descriptions render on GitHub. Use GitHub Flavored Markdown (GFM)
and consult the [GFM specification](https://github.github.com/gfm/) for standard
syntax and [GitHub's writing and formatting guidance](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)
for GitHub-specific features such as alerts. Keep formatting proportional to the
review task. Use alerts only for caveats that skimming reviewers need to notice,
and choose the alert type according to its meaning and severity.

## Gather Evidence

Read the repository's actual PR template and applicable title/body instructions.
Preserve required fields, sections, and checkboxes. Inspect the final diff against
its merge base and relevant commits. Establish the reason for the change (Purpose),
the resulting behavior (TL;DR), the real ticket when present, and the verification
actually performed.

## Draft the Body

Without a required template, default to this structure:

```markdown
## Purpose

[The problem, need, or goal this change addresses.]

## TL;DR

- [Resulting behavior.]

## Validation

- [Behavior checked and observed result.]
```

Include a Purpose section in every PR description. Purpose is the only place for the
reason the change exists. Write one or two plain sentences on the problem, need, or
goal it addresses. Draw it from the ticket, linked issue, or request, and do not invent
a motivation the evidence does not support. If none of those states a reason, do not
guess: ask the author for it before publication, or mark the reason as unconfirmed in
the draft. For a trivial change, such as a typo fix, dependency bump, or config tweak,
one line is enough; do not pad it.

For example, "Adds a retry to the export job." says what changed. "Exports failed
without an error when the file server timed out." gives the reason.

Use as many short, high-level TL;DR bullets as the change needs, without a fixed
limit. Explain resulting behavior, not files, helpers, or work history, and do not
restate the purpose. If a repository template requires `Summary` or another heading,
retain that heading and use the same TL;DR-style bullets beneath it. If the template
has a section that already states the purpose, use it for Purpose instead of adding a
duplicate. Preserve its other required fields and checkboxes. Do not repeat the diff
or call it a full changelog. Template comments are guidance, not PR content: remove
unused comments and placeholders from the final description.

Require a `Validation` section, or the repository template's equivalent testing
section, in every PR description, even for a tiny change. Keep it to a few short
bullets describing what was checked and the observed result. Summarize automated
checks in plain language. For manual UI verification, name the flow checked and what
worked. Report only checks actually performed; expected behavior is not verification.

Keep commands, file paths, line numbers, test counts, skipped-test totals, exit
codes, and raw runner output out of routine validation bullets. Retain detailed
evidence in the working record.

Include a validation caveat only when evidence shows it limits a claim made in
this PR or requires reviewer action. State the affected claim or required action.
A difference from the local environment or procedure is not, by itself, a
limitation. Keep incidental verification details in the working record, not the
PR description. Preserve explicitly required disclosures. Do not hide an important
skipped check behind a general claim that tests passed.

For example, use only the bullets supported by actual verification:

```markdown
## Validation

- Automated checks passed.
- Manually verified that changing filters updates the results and clearing them restores the full list.
```

If validation was not performed, say so and state the reason. Report failures and
relevant limitations plainly. Use a brief GitHub alert only when a skimming reviewer
must notice a genuine blocker or significant risk; do not repeat the same caveat
in multiple sections.

Do not add a separate implementation-details section. Put context that changes how
a reviewer should evaluate the change in Purpose when it explains why, or in a TL;DR
bullet when it describes behavior. Link the ADR, issue, or relevant file instead of
retelling the implementation. Leave decisions, tradeoffs, and migration notes out of
the description when the diff or a linked record already carries them.

Use other formatting only when it makes the change easier to review: a small
before/after table for changed behavior or compatibility, screenshots or a short
recording for UI changes, a Mermaid diagram for a complex flow, syntax-highlighted
code for a relevant example, and links to exact issues or decisions instead of
repeating background. Do not add these to every PR or use formatting as decoration.
Do not rely on retired GitHub tasklist blocks; preserve ordinary checkboxes when
the repository template requires them.

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
Keep it as a plain line in the template's location, usually at the end; it is not
a GitHub alert unless the template explicitly says so.

Follow GitHub's [alert guidance](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#alerts)
when an alert helps. Preserve the repository template over these defaults.

## Check the Exact Draft

Read the title and body against the final diff and verification evidence. Confirm
Purpose states the reason for the change, not its implementation, and that the TL;DR
does not repeat it. Check that any alert earns its place without burying important
status or repeating a bullet. Remove empty optional template sections and claims that
add no useful context. Keep identifiers in backticks and useful code examples in
language-tagged fences. Check the rendered structure: template headings, blank
lines around lists, and standard Markdown bullets. Confirm the required Validation
or equivalent section contains concise, evidence-backed bullets. Remove routine
runner statistics and details that repeat the checklist or another section.
For each caveat, identify what the reviewer should conclude or do differently
because of it. If there is no supported answer, remove it.
Resolve any contradiction between prose and a checkbox before publication; do not
guess which status is true. Follow the calling workflow's publication authorization;
do not post a draft as a side effect of writing it.
