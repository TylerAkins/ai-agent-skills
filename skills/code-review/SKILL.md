---
name: code-review
description: >-
  Review local diffs, branches, implementation plans, or GitHub pull requests
  against requirements and repository evidence. Use for requested code or plan
  reviews and delegated independent review. Draft concise findings; publish GitHub
  reviews only after approval of the exact verdict, text, and locations.
---

# Code Review

## Scope and Intent

Review without editing, staging, committing, or repairing the candidate. Run
mutating checks in an isolated copy. Read
[anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting feedback.

Establish authoritative requirements, accepted decisions, and repository contracts.
Verify claims in plans, tests, comments, author explanations, and earlier reviews.
Do not invent intent where uncertainty matters.

Pin the target before judging it:

- For local changes, identify the base, candidate commits, and staged, unstaged,
  and untracked files; do not confuse the working tree with HEAD.
- For a GitHub PR, resolve the repository, number, author, head SHA, base SHA,
  merge base, changed files, and linked requirements. Read the exact candidate and
  affected unchanged consumers by import and usage sites of each changed file,
  including components, not just callers of changed symbols.
- For a plan, identify its version and requirements; verify proposed paths,
  interfaces, dependencies, and checks against the repository.

Read applicable root and nested agent instructions, skill catalogs, and review
playbooks before discovery. Load relevant local skills; a mention in chat or a plan
does not prove host activation. Report material gaps from unavailable procedures.

For independent review, give a fresh reviewer raw requirements and the exact
candidate, without author reasoning, self-review, or proposed findings. If no fresh
reviewer is available and permitted, disclose the independence limit. Treat agent
findings as hypotheses and verify them against the candidate and contracts.

## Three-Phase Review

### Phase 1: Candidate Issue Discovery

Make separate passes for requirements, repository standards, and runtime correctness,
scaled to risk. Check for missing, incorrect, and unauthorized behavior, including
requirements already met by unchanged code. Use the [five-axis rubric](references/review-rubric.md)
for correctness, readability, architecture, security, and performance. Trace
execution, callers, consumers, configuration, failures, and tests; verify unfamiliar
APIs against installed dependency versions. A plan task alone does not require a diff.

Keep a brief working record of requirements checked, consumers traced, high-risk
transitions, candidate findings, and unverified paths. Record behavior and evidence,
not just checked boxes or file names. Treat concerns as hypotheses during discovery;
do not announce blockers yet.
Use separate reviewers only when available and permitted, with the same raw
requirements and candidate; otherwise disclose that the passes were not independent.

For stateful, asynchronous, or interactive behavior, read
[scope and state coverage](../test-authoring/references/scope-and-state.md). Identify
owners of values and operations. Trace failure, retry, overlap, rollback, identity
change, dismissal, and unmount. Check visible, pending, and persisted state and
tests that control relevant completion orders; happy-path tests do not cover lost
edits or stale work affecting a new owner.

For plans, check dependency order, shared contracts, decisions, acceptance criteria,
and whether proposed checks establish requirements. Do not claim implementation
verification from a plan review.

Run focused checks when useful; confirm selected tests ran. Zero tests is not
coverage, and green tests do not prove completeness. Assess regression sensitivity
in an isolated copy when useful. Record unperformed checks and unavailable paths.

For browser-visible changes, use an available browser tool against a safe local or
preview environment. Check the affected flow, rendered state, and relevant console
or network failures. Browser checks do not prove all async interleavings; report
unavailable safe tooling or environments as coverage limits.

For GitHub, record your own findings and gaps before reading earlier reviews.
Retrieve review bodies, every paginated thread and nested reply, and conversation
comments. Verify prior findings against the candidate; distinguish independently
found issues from those found through prior feedback. Deduplicate comments while
retaining valid unresolved blockers. Partial retrieval or open-thread counts do not
establish feedback coverage.

### Phase 2: Mandatory Adversarial Verification

For each possible blocker, make a separate verification pass. State the strongest
plausible author defense, then check the source that could confirm or refute it:
macro expansion, runtime path, schema, contract, tests, or peer implementation as
relevant. Author explanations and tests are evidence to verify, not proof.

A blocker requires all of the following:

- Changed location and reachable trigger.
- Exact code and relevant macro or runtime definition showing failure, invalid data,
  or violation of a named contract under that trigger.
- Causal path to a material consequence.
- Evidence that refutes or limits the strongest plausible defense.

An unverified consumer, speculative effect, or style preference is not a blocker.
Demote useful but unproved concerns to questions or non-blocking notes with the
missing evidence; drop those with no useful action. An unverified material path
prevents a clean approval.

Apply the same evidence bar to cleared paths and corrections. Compute relevant
dates, counts, offsets, or boundaries; trace consumers affected by null returns,
clamps, throws, or fallbacks. Show decisive worked values or named consumers in chat,
or label the path unverified.

### Phase 3: Calibrated Verdict and Report

Choose `APPROVE` only with complete coverage, supported repository patterns,
passing relevant checks, and no actionable feedback. Use `COMMENT` for actionable
non-blocking feedback and `REQUEST_CHANGES` only for verified blockers. Incomplete
coverage prevents approval. For GitHub, use the fixed review body, put the
investigation report in chat, and put finding evidence and consequences inline.

## Finding Bar and Verdict

Retain only supported failures, contract violations, or demonstrable maintenance
risks introduced or exposed by the change. Maintenance risk alone is non-blocking.
Give each finding a location, trigger, consequence, and evidence. Distinguish
unrelated existing defects from newly activated paths. State required behavior or
a minimal correction when known; do not invent an implementation.

Use impact to distinguish feedback:

- **Critical:** A material security, data loss, or operational failure blocks merge.
- **Required:** A supported contract violation or regression must be addressed.
- **Optional:** A justified improvement that does not block shipping.
- **Nit:** A minor preference, only when useful or requested.
- **Question:** Intent or evidence is missing; do not present it as a confirmed defect.

Order feedback by consequence; do not manufacture nits or enforce a finding count.
Repository conventions and facts outrank personal preferences. File size,
conditional count, and abstraction choices are clues, not automatic blockers.

Report incomplete coverage even without findings. After repairs, verify earlier
triggers, inspect the repair delta, and search the wider candidate and callers for
sibling failures. Changed contracts or approach require expanded coverage. Material
candidate changes reopen affected review; aborted or empty independent review remains
pending.

## Deliver Concise Feedback

Write findings as one plain paragraph by default: defect, trigger, impact, evidence,
and required behavior or correction. A test or documentation finding must name the
uncovered behavior or incorrect claim and its consequence.

In chat, summarize architectural impact, blocker proof, non-blocking Notes /
Questions, and material limits. For local reports, use Summary, Blockers, and Notes /
Questions; keep empty sections brief and omit routine CI recaps.

For GitHub reviews, follow [GitHub review delivery](references/github-review.md)
for event selection, inline comments, suggested changes, exact body, and publication
approval. Review requests do not authorize unseen publication or pending uploads.

## Anti-Rationalization Guardrails

These rules govern phase transitions. Missing evidence leaves the gate incomplete;
do not substitute a declaration of confidence or silently waive a requirement.

| Model Rationalization | Enforced Rule |
| --- | --- |
| The linter passed, so no review comments are needed. | Trace changed behavior, contracts, consumers, and failure paths before issuing a verdict. Lint output cannot satisfy review coverage. |
| A small PR needs no scrutiny. | Review the complete candidate against authoritative intent regardless of diff size. Report unavailable coverage as incomplete. |
| The trace found nothing wrong. | Tracing establishes coverage, not correctness. Compute the dates, counts, offsets, or boundaries the clearance depends on and show them, or record the path as unverified. |
| Style inconsistency is fine. | Check applicable repository conventions and address supported violations proportionally. Distinguish maintenance risks from optional preferences; do not invent blockers. |
| The suspicious line looks wrong, so it must be a blocker. | Treat it as a hypothesis. Check the strongest author defense and actual macro/runtime path; require causal evidence before assigning blocker status. |
| The happy path passed, so async behavior is covered. | Trace ownership and failure or completion order for affected state; verify high-risk interleavings with controlled tests and browser behavior where relevant. |
| A plausible consumer might reject this value. | Verify the consumer and contract. If downstream behavior is unavailable or inferred, report a question or leave the path unverified, not a blocker. |
| A confident explanation is enough to clear or confirm a concern. | Cite source behavior, trigger, and consequence. Confidence, reviewer instinct, and author intent do not satisfy the proof gate. |
