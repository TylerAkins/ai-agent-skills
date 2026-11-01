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

## 1. Discover the runner and expected behavior

1. Read repository instructions, neighboring tests, fixtures, dependency versions,
   runner configuration, and relevant CI commands. Prefer repository wrappers and
   scripts over assumed global commands. Identify the package directory and focused
   test selection, then confirm the runner actually executes the selected tests.
2. For test edits, discover configured lint, formatter, and type checks, including
   rules for test files. Follow the validation procedure in
   [writing-clean-simple-code](../writing-clean-simple-code/SKILL.md#4-verify-behavior-and-comprehension).
   Validation does not authorize production changes.
3. Derive expected outcomes from authoritative requirements, independently verified
   examples, or preserved contracts. Do not copy the implementation's formula into
   the expected result. Resolve behavior-changing ambiguity before asserting a
   guessed outcome; continue coverage whose intent is settled.
4. Before writing a test, name the behavior or defect its assertion would detect
   and the production change that would make it fail. If no meaningful change would
   fail it, strengthen the assertion or choose a different test boundary.

## 2. Choose the level that captures the behavior

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

For query changes, optimizations, persisted configuration, or asynchronous and
interactive state, read [scope and state coverage](references/scope-and-state.md).

## 3. Write readable, deterministic tests

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

## 4. Establish evidence for the requested coverage

- For a bug reproduction, use a realistic fixture that distinguishes defective
  behavior. Run it against the defective version when feasible and confirm the
  intended assertion fails; syntax, import, or setup failures do not count. A
  reproduction-only request stops there and does not authorize production repair.
- When tests accompany an authorized behavior change or fix, prefer observing the
  intended assertion fail before implementation and pass afterward. If the old
  version cannot be run safely or meaningfully, record why and use the strongest
  available baseline or reproduction. Do not claim regression sensitivity that was
  not observed.
- For coverage of existing correct behavior, run the test and verify it reaches the
  intended path and asserts an independently justified result. Use a focused mutation
  in an isolated copy when a consequential gap remains about whether the test could
  detect a regression; do not require one for every test-only change.

Keep before/after conditions comparable. Use isolated copies or restore only
agent-owned edits; never reset or stash mixed user work. A reproduction test may
remain failing for a later repair. Report its result without weakening
the assertion to obtain a green suite.

## 5. Execute and report

Run the intended tests and the configured lint, formatter, and type checks for
affected packages using the shared validation procedure above. Retain command
results, rerun affected checks after edits, and report unavailable checks as
incomplete. An intentionally failing reproduction test may remain failing;
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
