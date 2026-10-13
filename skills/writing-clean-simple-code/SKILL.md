---
name: writing-clean-simple-code
description: >-
  Write or simplify code with clear control flow, focused responsibilities, and
  only the abstraction current requirements justify. Use when implementing a
  scoped change, reducing unnecessary complexity, or refactoring for readability.
  Preserve repository conventions and contracts; avoid unrelated cleanup.
---

# Writing Clean, Simple Code

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting comments or reports.
Favor code a maintainer can understand, change, and debug with few hidden assumptions.
Judge simplicity by the concepts and dependencies needed to follow behavior, not
line count, clever syntax, or compliance with a universal design pattern.

## Understand the Task and Existing Design

Establish whether the request is new behavior, a bug repair, or behavior-preserving
simplification. Read repository instructions, the actual execution path, callers,
tests, dependency versions, and analogous code before editing. Preserve unrelated
work. Use [agent-planning](../agent-planning/SKILL.md) when dependencies or uncertainty
justify a plan, and [root-cause-debug](../root-cause-debug/SKILL.md) for unresolved bugs.

Identify the relevant inputs, outputs, errors, side effects, ordering, identity,
ownership, and security or tenant boundaries. Understand why compatibility code,
wrappers, caching, or unusual control flow exists before removing it. Check history
when the current code and contracts do not explain the constraint.

For simplification, preserve observable behavior and public contracts. A discovered
bug or desired behavior change is a separate decision; do not hide it inside cleanup.
For new behavior, implement the accepted requirement without speculative features.

## Choose the Simplest Adequate Design

- Keep responsibilities and ownership clear. Put policy in its owning layer and
  reuse existing canonical utilities instead of adding competing implementations.
- Prefer straightforward control flow and meaningful intermediate values. Use guard
  clauses when they reduce nesting without changing evaluation, cleanup, or side effects.
  Choose loops, expressions, or mappings according to the language and actual behavior.
- Name concepts and units precisely, using repository vocabulary. Avoid gratuitous
  renames, exaggerated names, and aliases that obscure the underlying contract.
- Keep interfaces explicit enough to prevent invalid combinations. Do not conceal
  unclear invariants with casts, broad types, optional fields, or silent fallbacks.
  Use inference where it stays clear and retain useful boundary annotations.
- Introduce an abstraction when it gives a real concept a name, owns shared policy,
  or hides a stable boundary. Avoid speculative extension points, pass-through
  layers, and configurable machinery for requirements that do not exist.
- Share duplicated knowledge or policy when the callers have the same contract.
  Similar-looking code with different reasons to change need not share a helper.
  Do not replace a small amount of understandable repetition with coupled machinery.
- Extract code when doing so creates a coherent responsibility or shortens the
  reasoning path. Inline indirection only when it adds no meaningful concept or
  boundary. Moving complexity into more files is not automatically simplification.

Do not impose fixed limits on function length, file size, nesting, or duplication.
Use them as clues to inspect responsibility and comprehension. Preserve established
patterns unless evidence shows they obstruct the requested work.

## Make Small, Reviewable Changes

For new behavior, use [test-authoring](../test-authoring/SKILL.md) to establish
meaningful expected outcomes. Prefer a focused failing behavioral test before
implementation when practical. Write enough production code to satisfy the full
contract, including relevant failures and boundaries, not just one fixture.

For refactoring, establish relevant baseline behavior and coverage before changing
structure. Add characterization coverage for material gaps when useful. Keep
structural steps distinguishable from behavior changes so regressions can be traced.
Separate substantial unrelated refactors from feature work; avoid mandatory extra
PRs for small local improvements necessary to express the requested behavior clearly.

Remove dead code only after checking actual consumers, dynamic references,
configuration, platform variants, and compatibility obligations where relevant.
Do not delete an extension point merely because a local search found no caller.
Avoid defensive code for impossible states, but preserve validation at real trust
boundaries and explicit handling of reachable failures.

Keep comments that explain reasons, contracts, or workarounds. Remove comments
that repeat nearby code. Do not replace clear code with dense one-liners, nested
ternaries, or elaborate fluent chains to make the diff shorter.

## Verify Behavior and Comprehension

Run relevant repository checks in their package directories after meaningful
changes. Confirm intended tests ran. Do not weaken expected behavior or regenerate
snapshots merely to make a refactor pass; update tests only for justified interface
changes or brittle implementation coupling while retaining the behavioral contract.

Review the before/after execution path for semantic changes tests might miss:
evaluation order, exception timing, async completion, cancellation, resource lifetime,
transaction boundaries, mutation, iteration order, serialization, and null/default
handling. Do not apply language-specific shortcuts without checking their semantics.
For performance-sensitive paths, preserve supported workload characteristics and
measure when the proposed structure could materially change them.

Inspect the final diff. Ask whether a reader needs fewer concepts, whether policy
has one clear owner, and whether the result fits the repository. If a change merely
relocates complexity or makes the path harder to follow, revise or restore only
agent-owned edits. Do not simplify already clear code just to produce a change.

Use [code-review](../code-review/SKILL.md) for independent review when warranted,
available, and authorized. Report the concrete change, meaningful verification,
and material limits without claiming that clean style proves correctness. Commit,
push, and publication require explicit authorization through
[git-delivery](../git-delivery/SKILL.md).
