# Adversarial Review

Read when a change adds a guard, computation, metric, failure path, or new tests.
The goal is to replace "this looks right" with a small set of inputs that would
prove it wrong, plus evidence that something exercises them.

## Method

1. State the intent each changed behavior must satisfy, in one sentence.
2. Construct the smallest plausible input that violates that intent. Prefer an
   input the source data, schema, or contract allows, not an exotic one.
3. Find the check that would catch that input. Look for a test, an executed
   check, a documented contract, or an enforced constraint.
4. Record the counterexample and one disposition: settled, Required, or
   impossible with evidence.

Derive inputs from the repository, not from memory. Useful sources are the schema
and key definitions, module docs, sibling implementations, migration history,
runtime configuration, and real data distributions.

## What counts as settled

- A test or executed check exercises the counterexample, fails against the
  defective behavior, and passes on the candidate.
- A documented contract or enforced constraint excludes the input.
- Runtime or data evidence shows the state cannot occur, and the source is named.

Anything else is unsettled. When the settling check is feasible but unrun, the
review is incomplete and the check is Required. Name the exact command so the
caller can settle it.

## Examples across stacks

| Change | Counterexample | Weak check | Settling check |
| --- | --- | --- | --- |
| Aggregate to a coarser grain | One output entity has extra source rows, such as a store split across regions | Test recomputes the model's `SUM` | Collapse per entity with `MAX`; add a duplicate-key fixture |
| Add a guard | A valid empty state, such as a deleted period | Test covers only the guard's own empty case | Exercise the valid-empty state and the retry path |
| Retried write | The same request arrives twice | Test calls it once | Idempotency or conflict test with the retry |
| Interface state | The first response arrives after the second | Test awaits one response | Out-of-order response test |

## Requirements can be wrong

A requirement written from a symptom can encode the defect. When a change adds a
new failure behavior, ask which legitimate state now fails and how the caller
recovers. If the requirement does not answer, record an open finding rather than
treating the guard as correct because it satisfies the sentence.

## Avoid

- Treating a sibling implementation as proof when the structure, platform, or
  contract differs.
- Accepting a green test that passed on zero rows, disjoint samples, or a copied
  expression.
- Demoting a counterexample to a note because execution is unavailable.
