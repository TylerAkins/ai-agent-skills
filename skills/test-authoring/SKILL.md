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
select focused tests, then confirm the runner actually executes them.

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
Choose manual verification when automation cannot establish the requirement, and
state that limitation. Avoid fixed test-level percentages or unnecessary end-to-end
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

## Establish Regression Sensitivity

For a bug, build a realistic fixture that distinguishes defective and corrected
behavior. When feasible, observe the expected behavioral assertion fail against
the defective version before verifying success against the corrected version.
Syntax errors, import failures, or unrelated mutations do not establish sensitivity.

Use isolated copies or precisely restore only agent-owned edits for before/after
checks. Never broadly reset or stash mixed user work. For existing correct behavior,
a test passing immediately can provide useful coverage: verify that it reaches
the relevant path and would detect a meaningful regression. Use a focused mutation
experiment when useful, not as a mandatory ritual for every test.

A request to write a reproduction test does not authorize repairing production code.
If the test is expected to remain failing for a later repair, report the reproduced
failure accurately rather than weakening its assertion to obtain a green suite.

## Execute and Report

Run the intended tests and relevant surrounding checks using actual repository
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
