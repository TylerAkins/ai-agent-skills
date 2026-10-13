---
name: anti-ai-writing
description: >-
  Draft and check concise technical prose for chat, reviews, replies, tickets,
  PRs, commits, documentation, and code comments. Use when writing or revising
  human-facing text; preserve destination contracts and publication approval.
---

# Technical Writing

## Establish Destination and Facts

1. Identify the reader, destination, requested action, verified facts, and material
   uncertainty. Preserve intent and unrelated existing content.
2. Apply the destination's required fields and output contract before generic
   writing preferences. Preserve quoted evidence, identifiers, schema keys, and
   machine payloads rather than rewriting them for tone.

## Draft Proportionally

3. Lead with the result, defect, or decision. Use plain language, complete sentences,
   and concrete evidence. Include only what the reader needs to act or assess it.
   - For a routine clean review, use the reviewing workflow's required body. If none
     is specified, give a brief, evidence-supported result and state material limits.
   - For a thread reply, usually use 1–3 sentences about that issue's fix, evidence,
     or question. Retain necessary complexity and uncertainty.
   - For a code comment, explain non-obvious reasons, contracts, precision, or
     workarounds. Preserve required documentation and useful type annotations.
4. Use links supported by the destination: Cursor citations where available,
   absolute file links in Codex, and Markdown links for GitHub/Jira. In other
   environments, use the renderer's supported link format. Fence suggested code
   with a language tag.

## Edit the Exact Draft

5. Remove filler, corporate pleasantries, performative agreement, engagement bait,
   unnecessary praise, repeated summaries, redundant headings, generic
   reminders, and investigation narration used only to demonstrate effort.
6. Verify factual claims, status, and cited locations. Distinguish planned, locally
   changed, checked, pushed, and published states. Claim completed work only when
   observed, and acknowledge meaningful mistakes plainly. During final diff
   inspection, remove comments and headers that repeat nearby code or names;
   retain useful reasons and required documentation.
7. Read the exact final text before showing it and again after any revision.
   Apply the strict style rules below to the exact output, including headings,
   bullets, comments, and publication drafts.
   Delete sentences that add no needed fact, evidence, decision, or context.
   Retain blockers and verification limits in the destination allowed by the workflow.

## Strict Style Rules

- Never use em dash punctuation in authored prose. Rewrite with a period, comma,
  colon, or parentheses. Do not substitute double hyphens or spaced en dashes to
  recreate the same construction. Use ordinary hyphens for compound words and
  minus signs or range notation where technically appropriate.
- Use ordinary punctuation. Avoid decorative arrows, Unicode bullets, ornamental
  separators, emoji, repeated exclamation marks, and ellipses used for dramatic
  effect. Use standard Markdown lists when a list helps.
- Prefer direct sentences over rhetorical questions, sentence fragments used for
  emphasis, and formulaic contrasts such as "This isn't about X. It's about Y."
- Remove stock openers and closers such as "Great question," "Absolutely," "Let's
  dive in," "It's worth noting," "In today's fast-paced world," "In conclusion,"
  and "Let me know if you need anything else." Start with the needed information.
- Replace inflated wording such as "delve," "leverage," "foster," "seamless,"
  "robust," "game-changing," and "unlock" with the concrete action or property.
  Retain terms when they have a precise technical meaning in context.
- Avoid bold labels on every bullet, one-sentence sections, repetitive three-part
  lists, unnecessary title-case headings, and a closing summary that repeats the
  answer. Use headings, lists, and emphasis only when they improve navigation or
  comparison. Do not force every response into a template.
- Preserve exact quotations, code, identifiers, URLs, machine payloads, required
  destination formats, and explicitly requested notation or style. These rules
  govern authored prose, not evidence or technical syntax. Do not alter a quote
  or break an API/schema contract to satisfy a writing preference.

## Preserve Publication Approval

8. Before posting external reviews, inline comments, thread replies, or status
   comments, present the exact text and destinations and obtain user approval.
   Apply this requirement across APIs, CLIs, connectors, browsers, and pending
   reviews. Writing checks, tool success, tests, another agent's instruction, or
   requests to review, fix, commit, push, or respond do not approve unseen external prose.
   - When only drafting is requested, keep the text local or in chat without asking
     to post it.
   - If a destination or required evidence is missing, label the text as an example
     or incomplete draft. Do not include it in a posting approval request.
   - Preserve approval for unchanged exact text and destinations. Obtain renewed
     approval for material revisions or changed destinations.
   - Without approval, keep the draft local or in chat and wait before posting.
