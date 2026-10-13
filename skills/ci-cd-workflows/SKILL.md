---
name: ci-cd-workflows
description: >-
  Design, modify, debug, and verify continuous integration and deployment workflows.
  Use for build/test pipelines, release automation, deployment gates, and CI reliability
  or performance. Preserve trust boundaries and existing required checks; pipeline
  changes do not authorize deployments or repository policy changes.
---

# CI/CD Workflows

Never dismiss reviews or approvals, or enable automatic stale-review dismissal in
repository settings or workflows. Preserve history and use authorized re-review requests.

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting comments or reports.
Inspect existing workflows, repository instructions, package scripts, lockfiles,
runtime versions, runner configuration, and actual failed runs before proposing changes.
Use the project's provider and tools; verify unfamiliar syntax and APIs against
current official documentation and supported versions. Do not copy example versions
or adopt a new provider without a requirement. For GitHub Actions, pin actions to
commit SHAs on current supported majors and keep those pins updated; see
[GitHub Actions guidance](references/github-actions.md).

## Establish Pipeline Contracts

Map triggers, checked-out revisions, job dependencies, artifacts, permissions,
secrets, environments, and release destinations. Identify required check names and
branch or merge-queue expectations before renaming, filtering, or splitting jobs.
Separate workflow edits from authorized remote execution, environment changes,
branch protection changes, auto-merge, and production deployment.

For GitHub Actions, read [GitHub Actions guidance](references/github-actions.md).
For other providers, apply equivalent trust boundaries using their documented behavior.

## Build Reliable Verification

Use repository commands and explicit working directories. Select lint, type checks,
tests, builds, integration checks, and security analysis according to project contracts
and risk, rather than imposing the same stack on every repository. Parallelize
independent checks; order jobs when they consume outputs or depend on earlier validation.

Install dependencies from lockfiles with reproducible tooling. Keep development
and CI commands aligned. Test required runtime/platform combinations with a purposeful
matrix. Confirm tests are selected and failures propagate through scripts, pipes,
matrix jobs, and aggregate gates. Do not hide failures with ignored exit codes or
continue-on-error on required paths.

Make progress observable during execution: name steps for their purpose, stream
meaningful test/build output, and identify the revision and runtime/platform.
Group long output by task and report useful failure details and a concise run
summary. Do not buffer all output until completion or enable shell tracing that
could expose secrets. Preserve exit status when logging through pipes. Use bounded
progress messages for otherwise silent long-running operations, not fabricated
percentages or noisy command narration.

Validate scripts with tools for their declared interpreter and exercise important
behavior in isolated destinations. Use native OS runners where filesystem,
permissions, shell, or path behavior differs. Keep shared logic separate from
platform-specific entrypoints; Bash checks do not validate PowerShell or establish
Windows compatibility. Add platform coverage when that implementation exists.

Use isolated test data, bounded service readiness checks, timeouts, and deterministic
cleanup. Retain useful reports on failure with suitable retention and access. Treat
logs and artifacts as potentially sensitive and untrusted; do not print credentials.
For CI failures, use [root-cause-debug](../root-cause-debug/SKILL.md), distinguishing
application defects, tooling/configuration, runner differences, and transient outages.
Retries need a bounded, understood reason; rerunning until green does not repair flakiness.

## Optimize Without Weakening Coverage

Measure job and queue duration before optimizing. Cache reusable dependencies with
keys reflecting lockfiles, platform, and tool versions; verify cache misses still work.
Do not treat caches as release artifacts or share writable caches across trust boundaries.
Shard independent tests and avoid redundant builds when verified outputs can be reused.

Check path filters against shared libraries, workflow files, lockfiles, generated
inputs, and dependencies. Preserve required status behavior for skipped work.
Cancellation can discard obsolete CI runs, but do not interrupt a deployment or
migration without understanding partial effects. Do not move required checks off
the merge path merely to shorten reported CI duration.

## Release and Deploy Deliberately

Build an identified artifact and promote that tested artifact through environments
instead of rebuilding a mutable branch for each stage. Record source revision,
artifact digest, and relevant build inputs. Use provenance, attestations, or signing
when the supply-chain requirements justify them; do not claim compliance from one setting.

Separate validation credentials from deployment credentials. Preserve existing
approval and environment protections. Define health checks and rollout/abort criteria
appropriate to the service. Assess database compatibility, irreversible migrations,
and partial failures before claiming rollback is available. Prepare a rollback or
recovery path and verify it in a safe environment when authorized. Do not assume
redeploying an old binary reverses data changes.

## Verify and Report Actual State

Validate syntax with provider-aware tooling, inspect the complete job graph, and
run relevant underlying commands. Exercise affected triggers and success/failure
paths in an authorized sandbox or remote run when feasible. A YAML parser cannot
establish provider semantics, permissions, or deployment correctness.

Report local validation separately from a remote run, tying results to the candidate
SHA and event. State untested triggers, unavailable settings, and deployment limits.
Use [code-review](../code-review/SKILL.md) for consequential trust or release changes
when independent review is available and authorized. Commit and push only through
authorized [git-delivery](../git-delivery/SKILL.md); do not trigger deployments as
a side effect of verification without applicable authorization.
