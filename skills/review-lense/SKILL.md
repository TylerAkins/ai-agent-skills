---
name: review-lense
description: >-
  Predict what a named reviewer may flag from their feedback in a specific
  repository. Use for reviewer-specific pre-review or preference analysis.
  Separate historical preferences from verified defects; do not replace correctness
  review or imply the reviewer will approve.
---

# Reviewer Preferences

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting feedback.
Use this skill to anticipate feedback, not impersonate a reviewer or change technical
judgment to match their tastes. Preserve the supplied reviewer handle and resolve
the repository and candidate/base. Ask for a missing handle rather than guessing.

## 1. Collect repository-specific evidence

Read [collection and profile guidance](references/profiles.md) before fetching or
updating history. Use available GitHub tools or CLI with verified schemas and
explicit repository/reviewer scope. Do not depend on scripts from another installed
skill. With no access, use supplied evidence and disclose the reduced scope.

Default to a bounded sample targeting 25 PRs with substantive feedback, searching
up to 120 candidates unless the user specifies another budget. Count distinct PRs
and comments separately; boilerplate approvals do not establish a preference.
Report actual sample size, search coverage, and stop reason. An underfilled sample
can still inform a tentative prediction, but it is not complete history.

## 2. Derive and test predictions

1. Cluster historical feedback by technical concern and triggering conditions, not
   wording. Read thread replies, historical code, and outcomes. Distinguish recurring
   preferences, one-off concerns, and explicit scoped waivers. A resolved thread or
   merged PR does not show by itself that the reviewer withdrew or accepted a concern.
2. Test each plausible prediction against the current diff, surrounding code, and
   actual consumers. Verify technical validity using the finding bar and rubric in
   [code-review](../code-review/SKILL.md). Drop disproven concerns; label unverified
   concerns as questions. Do not suppress defects absent from the reviewer's history.
3. Record two separate judgments: historical support that this reviewer may comment,
   and current evidence that the code has a defect. Use qualitative support such as
   repeated, single-example, or tentative. Recurrence is not a calibrated probability
   of correctness or a future comment. Do not promise approval or treat silence as
   a waiver.

## 3. Report and apply only requested fixes

Lead with the few predictions that matter. For each, give the current location and
trigger, likely concern, linked precedent, current validity, and a justified action.
Keep the profile scope, freshness, and material gaps concise. Do not invent a
finding count, pad the report with generic advice, or reproduce a reviewer's voice.
If no supported predictions remain, say so without implying a clean correctness review.

Remain read-only for prediction requests and `--no-fix`. Treat `--refresh` as a
request to rebuild the profile, not permission to edit code. When bounded fixes
are explicitly requested, change only supported issues within that scope. Assess
behavior and risk even for renames, logging, and type changes; run affected checks
and obtain independent review for material repairs when authorized and available.
Disclose unavailable review rather than labeling self-review independent.

Keep profiles in workspace scratch or a user-selected cache outside installed
packages. Do not commit, push, contact reviewers, or publish from this skill.
