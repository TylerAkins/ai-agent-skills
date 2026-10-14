---
name: test-authoring
description: >-
  Write meaningful tests for requested behavior, boundaries, failures, and state
  or tenant isolation. Use when adding coverage, reproducing a bug, or writing
  regression tests. Follow the repository's runner and conventions; do not expand
  test-authoring requests into unrequested production changes.
---

# Test Authoring

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting names, comments,
or reports. Keep changes scoped to the requested coverage and preserve unrelated work.

## Discover the Runner and Expected Behavior

Read repository instructions, neighboring tests, fixtures, dependency versions,
runner configuration, and relevant CI commands. Prefer repository wrappers and
scripts over assumed global commands. Identify the package directory and how to
select focused tests, then confirm the runner actually executes them. For test edits,
follow the repository validation procedure in
[writing-clean-simple-code](../writing-clean-simple-code/SKILL.md#verify-behavior-and-comprehension)
to discover configured lint, formatter, and type checks, including rules that apply
to test files. This validation does not authorize production changes.

Derive expected outcomes from authoritative requirements, independently verified
examples, or preserved contracts. Do not copy the implementation's formula into
the expected result. Resolve behavior-changing ambiguity before asserting a guessed
outcome; continue coverage whose intent is settled.

## Choose the Level That Captures the Behavior

Use the lowest level that meaningfully exercises the requirement:

| Level | Appropriate coverage |
| --- | --- |
| Unit | Isolated logic with controlled inputs and observable results. |
| Integration or composition | Behavior across parsing, persistence, services, or other component boundaries. |
| End-to-end | Critical user flows or browser/runtime behavior that lower-level tests cannot establish. |

Exercise production code. Do not mock the changed parser, compiler, engine, query,
or component whose behavior the test is meant to establish. Textual source checks
are appropriate only for an explicitly textual contract, not as runtime coverage.
Use real query/database behavior when mocks conceal tenant or scope defects.
Use manual verification for requirements automation cannot establish, and state
that limitation. Manual checks cannot replace required runner evidence for a
behavioral code change. Avoid fixed test-level percentages or unnecessary end-to-end
tests when focused coverage establishes the same behavior.

Cover relevant success, negative, boundary, null/empty, and failure cases. Include
normalization, repeated operations, partial inputs, and fallbacks where they affect
reachability or contracts. For shared repairs, include the original defect and a
plausible repair-induced failure from actual producers and consumers. Investigate
conflicting expectations across layers even when both suites pass.

For query changes, optimizations, or persisted configuration, read
[scope and state coverage](references/scope-and-state.md).

## Write Readable, Deterministic Tests

Organize each test into recognizable setup, action, and assertions without requiring
ceremonial comments. Name the behavior and expected outcome. Keep one coherent
behavior per test; multiple assertions can establish that behavior. Prefer outcomes
over internal call sequences unless the interaction itself is the required contract.

Reuse repository fixtures and builders, but keep distinguishing inputs and expected
results visible. Do not add abstraction solely to remove a few lines of setup.
Prefer cheap real collaborators; use fakes or mocks for costly, nondeterministic,
or unsafe boundaries outside the behavior under test. Verify a fake models the
contract being exercised rather than assuming it is equivalent to production.

Control time, randomness, scheduling, and I/O with repository utilities. Prefer
explicit synchronization to arbitrary sleeps. Give each test its own state and
restore changed globals, clocks, mocks, environment, and resources even after failure.
Use bounded waits and clean up background tasks. Do not depend on test order or
mutate shared fixtures across cases.

Use snapshots only for meaningful, reviewable output contracts. Inspect expected
changes deliberately; do not regenerate snapshots merely to make failures green.
Use focused assertions when a broad snapshot hides the behavior of interest.

## Red-Green-Refactor Assertion Gate

For new behavior and bug repairs, the required state sequence is Red, Green, then
Refactor. Do not write production implementation before completing Red.

1. **Red:** Write the behavioral test and run the actual repository test runner
   against the unchanged implementation. Display the command, working directory,
   failing assertion output, and nonzero exit code before writing production code.
   Confirm the failure expresses the requested behavior. Syntax, import, setup,
   or unrelated failures do not satisfy Red; repair the test setup and rerun.
2. **Green:** Implement the behavior, run the selected tests and required surrounding
   checks, and display the actual runner output and exit code 0 with zero failures.
   Confirm the intended tests executed; zero selected tests cannot satisfy Green.
3. **Refactor:** Simplify only after Green. Rerun affected tests after refactoring
   and display the clean output and exit code 0 before declaring completion.

If execution is unavailable, stop dependent implementation and report the gate as
blocked with the missing prerequisite. Never fabricate output or weaken assertions.
For coverage of existing correct behavior or behavior-preserving refactoring,
record a passing baseline and demonstrate regression sensitivity in an isolated
copy before changing production code. Documentation-only changes use document
validation rather than an artificial failing behavioral test. A reproduction-only
request ends at observed Red and does not authorize a production repair.

## Establish Regression Sensitivity

For a bug, build a realistic fixture that distinguishes defective and corrected
behavior. Observe the expected behavioral assertion fail against the defective version
before verifying success against the corrected version.
Syntax errors, import failures, or unrelated mutations do not establish sensitivity.

Use isolated copies or precisely restore only agent-owned edits for before/after
checks. Never broadly reset or stash mixed user work. For existing correct behavior,
a test passing immediately can provide useful coverage: verify that it reaches
the relevant path and would detect a meaningful regression. Demonstrate sensitivity
with a focused mutation in an isolated copy.

A request to write a reproduction test does not authorize repairing production code.
If the test is expected to remain failing for a later repair, report the reproduced
failure accurately rather than weakening its assertion to obtain a green suite.

## Execute and Report

Run the intended tests and the configured lint, formatter, and type checks for
affected packages using the shared validation procedure above. Retain command
results, rerun affected checks after edits, and report unavailable checks as
incomplete. An intentionally failing reproduction test may remain at observed Red;
that exception does not waive lint, formatter, or type checks. Use actual repository
commands and working directories. Confirm selected tests ran and inspect failures;
zero selected tests is not verification. Broaden or repeat checks only for material
changes, failures, or unresolved concerns. Do not skip a flaky test or rerun until
green as a substitute for understanding it; use
[root-cause-debug](../root-cause-debug/SKILL.md) for unresolved failure investigation.

Report what behavior the tests establish, actual execution results, observed
before/after evidence, and material limits. Distinguish authored but unrun tests
from verified coverage. Passing tests do not prove absence of defects or that an
unexecuted browser/live flow works. Commit, push, and publication require separate
authorization through the applicable workflow.

## Anti-Rationalization Guardrails

These rules govern phase transitions. Missing evidence leaves the gate incomplete;
do not substitute a declaration of confidence or silently waive a requirement.

| Model Rationalization | Enforced Rule |
| --- | --- |
| The change is too small to test. | For any behavioral code change, complete the assertion gate before implementation; size does not waive coverage. |
| I verified the behavior mentally. | Run the actual test runner and retain its output. Reasoning cannot satisfy an execution gate. |
| Mocking is too hard. | Use real collaborators or a suitable integration boundary. Do not mock the behavior under test or waive the gate because setup is difficult. |
| I will write tests after implementation. | Write and run the behavioral test first. Production implementation cannot begin until Red evidence is recorded. |
| Test-only changes do not need lint. | Run configured lint, formatter, and type checks for test edits, including intentionally failing reproduction tests. |
