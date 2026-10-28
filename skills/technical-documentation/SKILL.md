---
name: technical-documentation
description: >-
  Create, update, or review technical documentation from repository sources and
  primary references, including developer and user guides, API or factual references,
  onboarding material, technical specifications, release notes, and architecture
  decision records. Use readme-design for project READMEs and explain-it for
  one-time explanations.
---

# Technical Documentation

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting. Establish the
reader, their technical background, the question or task, the destination, the
source of truth, and the requested scope. Use this skill for a durable document;
use [readme-design](../readme-design/SKILL.md) for the project README and
[explain-it](../explain-it/SKILL.md) for a one-time explanation. Inspect repository
instructions, the project structure, existing docs, code, schemas, configuration,
and actual decisions. Preserve useful content and local conventions.

## Discover and Scope the Work

Follow the paths relevant to the reader instead of inventorying the whole codebase.
Identify the project or component, its entrypoints, important dependencies and
configuration, and the tests or workflows that establish behavior. Read source files
after finding them; filenames, manifests, comments, and test names alone do not prove
what the product does.

Compare the requested outcome with the existing docs and implementation. Note missing,
stale, duplicated, or conflicting guidance that blocks the reader's task. Update the
smallest coherent set of documents. Do not turn a scoped request into a repository-wide
rewrite or claim documentation coverage you did not inspect.

When an implementation change affects documented behavior, update the affected
documentation in the same change when it is in scope. For generated docs, edit the
maintained source and regenerate only affected outputs with the repository's documented
generator. If no generator exists, maintain the document directly; do not imply that
all docs or the README can be regenerated automatically.

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
unknown rather than filling the gap with an assumption. If a required source or
environment cannot be checked, hold any dependent claim as unverified; omit it or
label the limit instead of presenting it as fact.

For a substantial reference or a page spanning several execution paths, add a
compact source map that connects each major behavior to its implementation and,
where useful, the command or test that checks it. Keep that map proportional to
the page; small edits do not need a provenance appendix. When the same inventory,
default, or version appears in several places, link to its canonical source or
generate the repeated content from that source when the repository supports it.
Do not call prose or a table generated unless a maintained generator produces it.

Separate evidence by authority. Repository behavior comes from the current
implementation and its contracts; tests can reveal expected cases but can also
be stale. External behavior comes from current primary documentation or a
normative specification. Runtime observations apply only to the tested revision,
host, and environment. Record those limits when they matter to the reader.

Document stable user-visible behavior and supported contracts first. Include
internal control flow only when it helps a maintainer answer a concrete question.
For change-prone host or dependency behavior, identify the relevant product,
surface, and version when known, and recheck the primary source when editing that
claim. Add review dates only when they help maintain a changing inventory; avoid
dates that make stable repository behavior look temporary.

## Choose the Document's Job

Distinguish learning tutorials, task-oriented how-to guides, factual reference,
conceptual explanation, and decision records. Use the form that answers the reader's
question; link between forms instead of mixing every purpose into one long document.
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
Use a table of contents only when it materially improves navigation in a long page.
Headings, tables, and lists should help readers navigate or compare. For GitHub
destinations, apply
[GitHub Flavored Markdown Mastery](references/github-flavored-markdown-mastery.md).
Use only features that improve the technical reader's task and work on the target surface.

For task and user guides, show prerequisites, ordered actions, expected results,
and relevant recovery. Use terms and depth that fit the audience while keeping
technical behavior accurate. Label platform-specific commands and placeholders.
For API or factual references, state exact names, types, inputs, outputs, defaults,
constraints, errors, and supported versions that are established by the contract or
implementation. Use [api-design](../api-design/SKILL.md) for interface design and
contract changes. Generate OpenAPI or other references only through an existing,
verified generator or when establishing that workflow is explicitly in scope.
For architecture or business-facing documents, distinguish current facts, decisions,
proposals, risks, and estimates. Do not invent feasibility, timelines, costs, ROI,
or stakeholder commitments. Do not impose a new documentation platform or elaborate
hierarchy for a small edit.

For release notes or changelogs, derive entries from the actual release or change
range. Separate shipped changes from planned work, and describe user impact only
when supported. Use [release-readiness](../release-readiness/SKILL.md) for rollout
assessment and [git-delivery](../git-delivery/SKILL.md) for authorized publication
work; this skill does not authorize either.

Use code examples, diagrams, tables, screenshots, and use cases when they help the
reader understand or complete the task. Verify examples against the actual interface
or run them safely. Build diagrams from inspected relationships and use formats the
destination supports. Do not add visuals as decoration or imply a diagram is complete
when dependencies were not traced.

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
Use [safe-migrations](../safe-migrations/SKILL.md) for transition instructions when
relevant. Keep examples realistic and safe, with placeholders clearly identified and
no secrets. Copy technical identifiers, units, paths, and contractual values accurately.

## Anti-Rationalization Guardrails

| Rationalization | Rule |
| --- | --- |
| The existing document already explains the behavior. | Trace changed claims to current implementation or primary sources before preserving them. |
| A test name or passing test proves the whole documented contract. | Inspect the assertion and implementation; describe only the behavior each establishes. |
| A manually maintained table is quicker than finding its source. | Map it to a canonical source, or generate it when a maintained generation path exists. |
| The project has API code, so an OpenAPI spec can be generated. | Verify an existing generator and its output contract; do not invent or promise API generation. |
| All documentation should be regenerated after this edit. | Regenerate only affected outputs through maintained generators; preserve hand-authored docs. |
| Every page needs a timestamp, version matrix, or table of contents. | Include maintenance metadata and navigation only when they help this reader and can be kept accurate. |
| Markdown parses, so the page is ready. | Inspect the destination render for the reader's task and disclose renderer limits. |
| The installer placed files, so the host uses them. | Verify discovery and invocation separately; do not infer model behavior from placement. |
| Every technical detail makes a reference more complete. | Keep details that answer a reader's task; link to the source for incidental implementation. |

## Verify With the Reader's Task

Check every local link and referenced file. Verify external facts against primary
sources when unfamiliar or subject to change. Run examples and documented commands
in a safe representative environment when feasible, following the instructions as
a new reader would. Do not execute production/destructive steps to prove documentation.
Record untested platforms, prerequisites, and live actions instead of claiming success.

Keep verification claims at the level of evidence obtained:

1. **Structural:** links, anchors, fenced blocks, frontmatter, and generated package
   contents resolve or parse. This does not prove that commands work or pages read well.
2. **Command:** run safe examples from the documented working directory with stated
   prerequisites. For installers, use a fresh scratch destination and check conflict,
   merge, backup, and sibling-preservation behavior when those are documented.
3. **Rendered:** inspect the target renderer for navigation, code, tables, media,
   disclosure sections in both states, and narrow layouts when relevant. A local
   reference parser is structural/rendering evidence, not proof of GitHub's exact page.
4. **Host behavior:** check discovery, activation, or invocation in the named host
   separately. File placement or a rendered page does not establish model behavior.

Run only the levels needed for the changed claims and reader task. State which level
was checked and what remains unverified; never let a lower level imply a higher one.

Keep verification proportional and report untested platforms or live steps. Reconcile
the final prose with observed behavior after material edits. Change generated
documentation at its source so the next build does not overwrite the repair.

Before delivery, trace one reader's task from entrypoint to success. Remove needless
jumps, duplicate instructions, missing prerequisites, and misleading labels. For a
substantial sourced redesign, record sources and the principle each informed; do
not invent provenance or claim a universal standard. See
[documentation sources](references/documentation-sources.md) for current references.

Report the artifact, verified tasks, and material gaps. Creating local documentation
does not authorize external posting or publication. Use authorized
[git-delivery](../git-delivery/SKILL.md) for Git actions and preserve existing approval.
