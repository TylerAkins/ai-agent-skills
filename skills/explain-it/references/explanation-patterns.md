# Explanation Patterns

Read when selecting examples, analogies, or a structure for unfamiliar material.
These patterns support the user's requested format; they are not mandatory headings.

## Choose the Shape

| Request | Useful shape |
| --- | --- |
| What is this? | Name its purpose, explain the relevant mechanism, and give a small example. |
| How does this code work? | State the output or effect, trace the important inputs and decisions, then explain edge conditions. |
| Why did this happen? | Separate observed sequence from a supported causal explanation; label hypotheses. |
| Explain the tradeoff | State the choice and goal, compare consequences under the same assumptions, and retain uncertainty. |
| Summarize this document | Preserve its central claim, scope, supporting reasons, and exceptions; distinguish its claims from verified facts. |
| TL;DR only | Give the main answer and indispensable qualification within the requested limit. |

## Examples and Analogies

Choose the smallest example that exposes the mechanism. Keep inputs and outcomes
visible; avoid examples requiring more background than the original concept.
Do not use a fictional scenario as evidence about the user's actual system.

An analogy must map to the relevant relationship, not merely share vocabulary.
For example, describing a cache as a nearby copy can help explain reduced retrieval
work, but does not establish freshness or consistency. Explain those separately
when they matter. Drop an analogy that needs more caveats than the mechanism.

For numbers or code, preserve units, types, and boundary conditions. Explain the
worked result instead of merely showing syntax. State when a snippet is illustrative
and cannot be run without the user's actual schema, inputs, or environment.

## Accuracy Under Compression

A summary of a source reports what that source says. An explanation of whether it
is correct requires separate evidence. Do not turn a document's confident assertion
into an independently verified fact.

Replace an unfamiliar word with a familiar one only when the meaning survives.
A transaction's isolation level, a legal exception, or a probability statement may
need its precise term plus a short definition. Do not replace probabilistic language
with guarantees to make a sentence simpler.

Keep the caveat next to the affected claim. Distinguish a known limitation from
an unknown fact and a hypothesis from an observed cause. Name what evidence would
settle a material unknown when useful, without assigning unrequested work.

## Evaluation Cases

Use these when checking a new or revised explanation workflow:

- A TL;DR-only request with a hard length limit must preserve its key qualification.
- A request about an unavailable document must ask for the missing subject rather than fabricate a summary.
- A beginner code walkthrough must retain exact identifiers and explain the real execution path without editing code.
- A misleading analogy must be qualified or replaced with the actual mechanism.
- A document containing uncertain or disputed claims must not be summarized as established fact.

Evaluate the actual output against source meaning, length, defined terms, labelled
examples, and material uncertainty. A claim that an explanation is clear is not
evidence that these criteria were met. Record host behavior separately from static
inspection of this reference.
