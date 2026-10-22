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

Review the candidate without editing, staging, or committing it. Use an isolated
copy for checks that write or mutate code. Do not implement repairs during review.
Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting feedback.

Establish authoritative requirements, accepted decisions, and applicable repository
contracts. Treat plans, tests, comments, author explanations, and earlier verdicts
as claims to verify. Preserve consequential uncertainty rather than inventing intent.

Pin the target before judging it:

- For local changes, identify the base, candidate commits, and included staged,
  unstaged, and untracked files. Do not confuse the working tree with committed HEAD.
- For a GitHub PR, resolve the repository, number, author, head SHA, base SHA,
  merge base, changed files, and linked requirements. Read the exact candidate and
  affected unchanged consumers, swept by import and usage sites of each changed
  file, including components, not only by callers of changed symbols.
- For a plan, identify its version and source requirements. Inspect the repository
  to verify proposed paths, interfaces, dependencies, and verification commands.

For delegated independent review, receive raw requirements and the exact candidate,
not author reasoning, self-review, proposed findings, or the implementation plan as
proof. If implementation reasoning is already in context, use a fresh reviewer
when available and authorized; otherwise disclose the independence limit.
AI-agent review output is issue-discovery input, not proof. Verify each retained
finding against the candidate, repository contracts, and the required evidence bar.

## Three-Phase Review

### Phase 1: Candidate Issue Discovery

First reconcile requirements with behavior. Look for missing, incorrect, and
unauthorized behavior. Verify requirements already satisfied by unchanged code;
do not require a diff merely because a plan lists an implementation task. Treat
every concern discovered in this phase as an unverified hypothesis. Do not draft
or announce blockers during discovery.

Then use the [five-axis rubric](references/review-rubric.md) to inspect correctness,
readability, architecture, security, and performance. Trace actual execution paths,
callers, consumers, configuration, failure handling, and relevant tests. Verify
unfamiliar APIs against installed dependency versions.

For plans, apply the rubric to the proposed behavior and design. Check dependency
order, shared contracts, unresolved decisions, acceptance criteria, and whether
the proposed checks can establish the requirements. Do not claim implementation
verification from a plan review.

Run focused checks when they can establish a concern or material behavior. Passing
tests do not establish correctness or completeness. Verify actual test selection;
zero tests is not passing coverage. When useful, assess regression sensitivity in
an isolated copy. Record unperformed checks and unavailable paths.

For GitHub, form an assessment before reading earlier reviewers' conclusions.
Then retrieve review bodies, all paginated threads and nested replies, and
conversation comments. Verify earlier findings against the current candidate.
Deduplicate new comments while retaining still-valid unresolved blockers. Partial
retrieval and open-thread counts do not establish complete feedback coverage.

### Phase 2: Mandatory Adversarial Verification

Before assigning blocker status to a candidate, make a separate verification pass
for that concern. State the strongest plausible author defense, then inspect the
source that could confirm or refute it. Depending on the concern, this may include
macro definitions and expansion, runtime control flow, schemas, public contracts,
tests exercising the path, and peer implementations in the same repository. Treat
author explanations and tests as evidence to check, not as proof by themselves.

A blocker requires all of the following:

- A specific changed location and reachable trigger.
- The exact changed code and relevant macro or runtime definition whose behavior,
  under the described trigger, demonstrably fails, violates a named contract, or
  produces invalid data.
- A causal explanation connecting that behavior to a material consequence.
- Evidence that addresses the strongest plausible defense or establishes why it
  does not apply.

Do not promote an inference about an unverified consumer, a speculative downstream
effect, or a stylistic preference to blocker status. If a concern is useful but not
fully proved, demote it to a non-blocking note or question and name the missing
evidence. Drop concerns with no useful action or question. If required evidence
cannot be obtained, leave the path unverified and do not issue a clean approval when
that gap makes review coverage incomplete.

Apply the same evidence duty to a cleared path and a proposed correction. Compute
dates, counts, offsets, or boundaries used in the decision, and trace consumers
affected by control-flow changes such as null returns, clamps, throws, or fallbacks.
Show worked values or named consumers in chat when the verdict depends on them, or
label the path unverified.

### Phase 3: Calibrated Verdict and Report

Set the baseline to `APPROVE` when review coverage is complete, the implementation
fits supported repository patterns, relevant checks pass, and no actionable feedback
remains. Passing tests support this assessment but do not replace source and contract
verification. Use `COMMENT` for actionable non-blocking feedback and
`REQUEST_CHANGES` only for verified blockers. Incomplete coverage prevents a clean
approval.

In the chat report, summarize high-level architectural impact, list verified
blockers with their failure proof, and place non-blocking observations under Notes /
Questions. State material verification limits. For GitHub, keep the fixed review-body
contract and put the investigation report in chat; inline comments must carry the
verified evidence and consequence. When a small, exact correction is fully supported,
include a GitHub suggested-change block in the inline comment. Read [GitHub review
delivery](references/github-review.md) for eligibility and formatting.

## Finding Bar and Verdict

Retain a finding only when evidence supports a concrete failure, contract violation,
or demonstrable maintenance risk introduced or exposed by the change. A maintenance
risk alone is non-blocking. A blocker must satisfy the Phase 2 proof requirements.
Include a supported location, trigger, consequence, and evidence. Distinguish
unrelated existing defects from paths newly activated by the candidate. State required
behavior or a minimal correction when known; do not invent an implementation.

Use impact to distinguish feedback:

- **Critical:** A material security, data loss, or operational failure blocks merge.
- **Required:** A supported contract violation or regression must be addressed.
- **Optional:** A justified improvement that does not block shipping.
- **Nit:** A minor preference, only when useful or requested.
- **Question:** Intent or evidence is missing; do not present it as a confirmed defect.

Order feedback by consequence. Do not manufacture nits or enforce a finding count.
Repository conventions and supported technical facts take precedence over personal
preferences. File sizes, conditional counts, and abstraction choices are clues to
investigate, not automatic blockers.

Keep completion separate from findings. Report incomplete coverage explicitly,
even when no defect was confirmed. For repairs, verify earlier triggers and expand
coverage when contracts or approach changed. Material candidate changes invalidate
affected prior coverage; an aborted or empty independent attempt remains pending.

## Deliver Concise Feedback

Write each finding as one plain paragraph by default: defect, triggering condition,
impact, evidence, and required behavior or correction. Use supported file links,
backticks for identifiers, and language-tagged fences only when code helps.
Omit praise, filler, em dashes, investigation narration, and generic test reminders.
A test or documentation finding must name the uncovered behavior or incorrect claim
and its consequence.

For local review reports, always use the Summary, Blockers, and Notes / Questions
structure, keeping empty sections brief. State incomplete coverage and material
limits. Omit routine CI recaps.

For GitHub reviews, read [GitHub review delivery](references/github-review.md).
Keep the investigation report in chat and concrete findings inline. Present the
exact verdict, body, comments, and destinations before posting. Review requests
do not authorize unseen publication or pending review uploads.

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
| A plausible consumer might reject this value. | Verify the consumer and contract. If downstream behavior is unavailable or inferred, report a question or leave the path unverified, not a blocker. |
| A confident explanation is enough to clear or confirm a concern. | Cite source behavior, trigger, and consequence. Confidence, reviewer instinct, and author intent do not satisfy the proof gate. |
