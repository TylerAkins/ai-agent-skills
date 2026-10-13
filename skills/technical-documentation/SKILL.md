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

For a README, explain the project's purpose, intended use, shortest working setup,
and how to find the relevant capabilities. Include actual prerequisites, commands,
limits, and license when useful. Do not invent a development server, test runner,
installer, roadmap date, support guarantee, or badge to fill a template.

For task guides, state prerequisites, actions in execution order, expected results,
and consequential recovery or troubleshooting. For reference, document exact names,
types, defaults, constraints, errors, and supported versions without hiding facts
in a tutorial. For explanation, describe rationale and tradeoffs with evidence.

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

Inspect rendered Markdown or the target renderer when available, checking heading
structure, tables, fences, navigation, and media. Source/link checks are a fallback,
not proof of rendered quality. Reconcile prose and examples with final behavior after
material edits. Generated reference output should follow its actual generation source,
not be patched in a way the next build overwrites.

For a new documentation workflow, use a realistic artifact to check whether a reader
can find prerequisites, perform the task, and understand success and limitations.
Keep behavioral evidence separate from formatting lint; one example is not proof of
general effectiveness. Avoid tests that merely require particular headings or wording.

Report the artifact, verified tasks, and material gaps. Creating local documentation
does not authorize external posting or publication. Use authorized
[git-delivery](../git-delivery/SKILL.md) for Git actions and preserve existing approval.
