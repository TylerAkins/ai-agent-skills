---
name: technical-documentation
description: >-
  Create and maintain accurate READMEs, task guides, API references, explanations,
  and architecture decision records. Use when documentation is requested or a
  change affects documented behavior. Verify examples and claims against sources;
  scale structure to reader needs and preserve decision history.
---

# Technical Documentation

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting. Establish the
reader, task, destination, source of truth, and requested scope. Inspect existing
documentation, repository instructions, code, schemas, configuration, and actual
decisions. Preserve useful unrelated content and the project's conventions.

## Choose the Document's Job

Distinguish learning tutorials, task-oriented how-to guides, factual reference,
and conceptual explanation. Use the form that answers the reader's question;
link between forms instead of mixing every purpose into one long document.
Do not create a documentation hierarchy or ADR for a trivial change.

Organize the reader's complete task, not just individual files. Use the README
for setup, first use, and links to optional detail. Keep a host's installation,
activation, and updates together. Present supported hosts equally unless a
recommendation is justified by the user or product requirements.

Make linked references usable directly: their title and filename should describe
their purpose, and their commands should include prerequisites and a working
directory. Avoid circular setup links, duplicate procedures, and maintainer detail
in onboarding. Preserve supported alternatives, customization handling, and limits.

Choose formatting for the renderer. On GitHub, native `<details>` / `<summary>`
sections can make independent host paths or long optional material easier to scan.
Use descriptive labels, blank lines around Markdown inside HTML, and complete
expanded paths. Keep shared prerequisites visible; avoid nested disclosure piles.
Headings, tables, and lists should help readers navigate or compare.

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

Document actual public behavior and operational prerequisites, not the original plan.
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
