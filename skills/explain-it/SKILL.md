---
name: explain-it
description: >-
  Explain concepts, code, documents, or decisions in simple language with a short
  TL;DR, concrete examples, and depth matched to the reader; use for plain-English
  explanations, walkthroughs, or summaries rather than implementation or prose editing.
---

# Explain It

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting. Produce an
explanation the reader can understand without already knowing the subject.
Simplify language while preserving the facts, causal relationships, and limits
that matter to the question. Explanation does not authorize code changes,
publication, or action in an external system.

## 1. Resolve the subject and reader

Identify what the user wants explained and why: understanding a concept, following
code, interpreting a document, or assessing a decision. Use their stated audience,
knowledge, language, and length preference. Otherwise default to a capable adult
unfamiliar with this particular subject; do not assume a child or use baby talk.

Resolve references such as "this" from the available file, selection, or conversation.
Read the actual source before describing it. For code, trace the relevant execution
path and callers rather than inferring behavior from names or comments. Follow
applicable source-verification requirements for current or uncertain factual claims.

Gate: establish a supported subject and audience. If the source or referent is
missing, ask one focused question and explain only the settled context. Do not
invent what an unseen document, screenshot, or codebase says. Missing intent blocks
only the explanation that depends on it.

## 2. Build the explanation

Lead with a short TL;DR, usually one or two sentences, stating the main answer and
its practical meaning. Follow an explicit request for a single sentence or a longer
walkthrough instead of forcing this shape on every response.

Then explain the minimum causal chain needed to understand the answer: what the
thing is, how it works, and why the relevant behavior follows. Use familiar words,
short sentences, and concrete subjects. Define necessary jargon on first use;
retain exact identifiers when the reader needs to find them in a source.

Use one small example when it makes an abstract idea concrete. Prefer a real
source-supported example; label invented numbers or scenarios as illustrations.
Use an analogy only when it reduces confusion, and state its material limit.
For choosing examples and handling uncertainty, read
[explanation patterns](references/explanation-patterns.md) when those issues arise.

Put essential exceptions beside the claim they qualify. Separate observed facts,
inferences, assumptions, and unknowns. Preserve numbers, units, conditions,
authorization boundaries, and consequences that could change the reader's decision.
If sources conflict, explain the conflict instead of smoothing it into certainty.

Gate: every material claim must follow from the source or be labelled as an
illustration, inference, or uncertainty. A shorter explanation cannot omit a
condition that makes its main answer false.

## 3. Match depth and deliver

For a TL;DR-only request, stop after the requested summary. For a beginner walkthrough,
introduce concepts in dependency order. For an experienced reader, skip background
they already know and explain the unfamiliar mechanism or tradeoff. Add a diagram
only when it materially clarifies relationships; no tool or visualization is required.

Read the exact draft before delivering. Verify that:

- The opening answers the actual question in the requested length and language.
- Necessary terms are defined before they are used to explain another term.
- Examples agree with the explanation and are distinguishable from actual evidence.
- Source meaning, key conditions, and material uncertainty survive simplification.
- Supported links or citations let the reader inspect source-specific claims.

Repair any failed criterion before presenting the explanation. If evidence remains
unavailable, state that limit and avoid unsupported conclusions. Do not ask a
comprehension quiz or add a generic offer to explain more unless the user requested
interactive teaching. Re-explain with a different example when they indicate confusion.

Use [technical-documentation](../technical-documentation/SKILL.md) when the requested
artifact is a maintained guide, reference, or decision record. Use
[code-review](../code-review/SKILL.md) for a correctness verdict and
[root-cause-debug](../root-cause-debug/SKILL.md) for diagnosis or repair. Explaining
code does not silently expand into reviewing, debugging, or implementing it.

## Checks not to skip

- Retain conditions and uncertainty that could change the answer or its practical
  consequence, even when simplifying the language.
- Resolve and inspect the subject before explaining it. Ask for missing context
  rather than guessing what an unseen source contains.
- Match the requested depth. Extra detail is not useful unless it supports the
  reader's actual question.
- Explain the real mechanism when using an analogy, and state where the analogy stops
  applying.
- Verify source-specific and uncertain claims. Confidence does not satisfy this check.
- Write for a capable reader. Reduce jargon without reducing precision or respect.
