---
name: technical-documentation
description: >-
  Create and maintain source-derived technical guides, references, explanations,
  and architecture decision records. Use when repository behavior or technical
  decisions need documentation. Trace claims to implementation and verify examples.
---

# Technical Documentation

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting. Establish the
reader, task, destination, source of truth, and requested scope. Inspect existing
documentation, repository instructions, code, schemas, configuration, and actual
decisions. Preserve useful unrelated content and the project's conventions.

## Trace the Implementation

Start from the reader's technical question and identify the relevant execution
path. Inspect entrypoints, callers, configuration, schemas, tests, and error paths
as needed. Record which repository evidence supports each behavior, default,
constraint, and failure case. Distinguish observed behavior from inference and
unresolved behavior. Do not use an old document, plan, comment, or test name as
proof when the implementation can be inspected.

Write from that evidence. Prefer concise prose around verified facts over prose
that restates source code. Use exact identifiers, values, paths, and version
constraints. If the implementation does not establish an answer, say what remains
unknown rather than filling the gap with an assumption.

## Choose the Document's Job

Distinguish learning tutorials, task-oriented how-to guides, factual reference,
and conceptual explanation. Use the form that answers the reader's question;
link between forms instead of mixing every purpose into one long document.
Do not create a documentation hierarchy or ADR for a trivial change.

Organize the reader's complete technical task, not just individual files. Keep
project overview and first-use navigation in the README; use
[readme-design](../readme-design/SKILL.md) when creating or substantially revising
that entrypoint. Keep a host's installation, activation, and updates together in
the relevant technical guide. Present supported hosts equally unless a
recommendation is justified by the user or product requirements.

Make linked references usable directly: their title and filename should describe
their purpose, and their commands should include prerequisites and a working
directory. Avoid circular setup links, duplicate procedures, and maintainer detail
in onboarding. Preserve supported alternatives, customization handling, and limits.

Choose formatting for the renderer. On GitHub, native `<details>` / `<summary>`
sections can make independent host paths or long optional material easier to scan.
Use descriptive labels, blank lines around Markdown inside HTML, and complete
expanded paths. Keep shared prerequisites visible; avoid nested disclosure piles.
Headings, tables, and lists should help readers navigate or compare. Apply
[GitHub Flavored Markdown guidance](references/github-flavored-markdown.md) when
the destination is GitHub; use only features that improve the technical reader's
task and work in the target surface.

For task guides, show prerequisites, ordered actions, expected results, and relevant
recovery. Label platform-specific commands and placeholders. For reference, state
exact names, types, defaults, constraints, errors, and supported versions. For
explanation, describe rationale and tradeoffs. Do not invent scaffolds or impose
an elaborate hierarchy for a small edit.

## Record Decisions Without Rewriting History

For consequential architectural choices, inspect existing ADR location, numbering,
status, and templates before adding a record. If none exist, use a short Markdown
record with title, status/date, context, decision, considered alternatives, and
consequences, including drawbacks and unresolved implications.

Record actual decisions and evidence. Do not invent evaluated alternatives or mark
a proposal accepted because an agent wrote it. Preserve accepted ADRs as historical
records; supersede them with a linked new decision rather than rewriting the past.
Correct factual errors transparently and distinguish present implementation from
the reasoning known at decision time.

## Draft From Verified Behavior

Lead with the information needed to act. Use complete sentences, consistent terms,
descriptive headings, and small examples. Use tables for genuine comparisons and
lists for steps or parallel items, not a checklist on every page. Explain non-obvious
reasons, limitations, and failure cases; avoid repeating source code or conversation history.

Document actual behavior and operational prerequisites, not the original plan.
Use [api-design](../api-design/SKILL.md) for interface contracts and
[safe-migrations](../safe-migrations/SKILL.md) for transition instructions when relevant.
Keep examples realistic and safe, with placeholders clearly identified and no secrets.
Copy technical identifiers, units, paths, and contractual values accurately.

## Verify With the Reader's Task

Check every local link and referenced file. Verify external facts against primary
sources when unfamiliar or subject to change. Run examples and documented commands
in a safe representative environment when feasible, following the instructions as
a new reader would. Do not execute production/destructive steps to prove documentation.
Record untested platforms, prerequisites, and live actions instead of claiming success.

Inspect the rendered result, including navigation, code fences, tables, and media.
For disclosure sections, check the collapsed page and expand each reader path.
Check narrow layouts when long commands or tables matter. Source/link checks are
a fallback, not proof of rendered quality; disclose when visual checks are unavailable.

For installation guides, test commands in fresh scratch destinations, preserving
sibling resources and checking conflict handling. Verify host discovery separately:
file placement does not prove an agent loaded or followed a skill. Keep verification
proportional and report untested platforms or live steps. Reconcile the final prose
with observed behavior after material edits. Change generated documentation at its
source so the next build does not overwrite the repair.

Before delivery, trace one reader's task from entrypoint to success. Remove needless
jumps, duplicate instructions, missing prerequisites, and misleading labels. For a
substantial sourced redesign, record sources and the principle each informed; do
not invent provenance or claim a universal standard. See
[documentation sources](references/documentation-sources.md) for current references.

Report the artifact, verified tasks, and material gaps. Creating local documentation
does not authorize external posting or publication. Use authorized
[git-delivery](../git-delivery/SKILL.md) for Git actions and preserve existing approval.
