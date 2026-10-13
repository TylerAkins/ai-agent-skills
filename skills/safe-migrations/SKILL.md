---
name: safe-migrations
description: >-
  Plan and implement compatible transitions for APIs, services, dependencies,
  configuration, and persisted data, including deprecation and removal. Use when
  replacing an interface or system, retiring behavior, or changing schemas with
  active consumers. Verify staged compatibility, cutover, and recovery within authorization.
---

# Safe Migrations

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting plans, notices,
or reports. Distinguish planning, implementation, live execution, and removal.
Preserve authorization already given, but do not infer production writes, consumer
notifications, destructive execution, or publication from a request to prepare a migration.

## Establish the Contract and Consumers

Read repository instructions, current implementation, supported versions, consumers,
deployment topology, tests, and relevant operational evidence. Verify tool, database,
and framework semantics against their actual versions and official documentation.
Define the reason for the transition, required replacement behavior, scope, owners,
and accepted breaking changes. Retirement without a replacement can be intentional;
record that decision rather than inventing an alternative or deadline.

Trace published interfaces, dynamic names, configuration, generated clients, jobs,
integrations, offline clients, persisted formats, and external consumers. Search
results and low traffic alone do not establish absence of dependency. Record what
is verified, unknown, and outside available visibility.

Compare old/new behavior across inputs, outputs, errors, defaults, identity, ordering,
authorization, tenant scope, and side effects. Separate supported contracts from
incidental observations, but investigate observable behavior consumers may rely on.
An additive field, new enum value, or changed default can still break a consumer.
Apply the project's versioning and support policy; use semantic versioning only
where that is the established public version contract.

## Plan Independently Verifiable Stages

Use [agent-planning](../agent-planning/SKILL.md) for consequential multi-stage work.
Record phase order, compatible version combinations, success evidence, abort criteria,
recovery actions, and the point beyond which reverting code is insufficient.
Keep the plan proportional; a local dependency upgrade does not need a service
cutover ceremony. For persisted data, read
[database and backfill guidance](references/database-migrations.md).

Choose a transition based on the actual boundary:

| Approach | Appropriate use |
| --- | --- |
| Expand, migrate, contract | Old/new interfaces or data shapes must coexist during rollout. |
| Compatibility adapter | Preserve a supported interface while changing its implementation. |
| Incremental routing | Move consumer cohorts or traffic between implementations with observable recovery. |
| Coordinated cutover | An accepted outage or atomic deployment boundary makes coexistence unnecessary. |

Avoid introducing flags, dual writes, or permanent adapters without a concrete need.
When used, define their ownership, consistency rules, rollback limits, and eventual
removal conditions. Shadow execution must not duplicate external writes or other
side effects. Isolate cohorts and telemetry without leaking tenant data.

For public deprecation, prepare a notice with reason, affected versions, supported
replacement or retirement outcome, migration steps, and accepted support/removal
dates. Do not invent a notice period or announce an unapproved deadline. Provide
tooling or examples proportional to consumer effort. Draft locally; publish or
contact owners only under applicable authorization.

## Implement and Verify the Transition

Preserve unrelated work and make stages reviewable. Confirm compatibility across
old/new producers and consumers, rollout order, mixed versions, retries, and relevant
failure paths. Use [test-authoring](../test-authoring/SKILL.md) for independently
justified expectations. Verify migrations against representative existing state,
not just clean installation. Reconcile new-install and upgraded-system behavior.

Tie operational evidence to the exact candidate, schema/data state, environment,
and cohort. Define parity checks that detect missing records, altered identities,
ordering, or unauthorized access rather than relying only on totals. Investigate
differences before promoting a stage. Test recovery in a safe environment when
feasible and distinguish rehearsed recovery from a documented but untested procedure.

Use [ci-cd-workflows](../ci-cd-workflows/SKILL.md) for staged automation and
[code-review](../code-review/SKILL.md) for consequential migration review when
independence is available and authorized. A passing suite alone does not authorize
live cutover or establish consumer readiness.

## Remove Only After Readiness Is Supported

Before contracting or deleting, verify migrated consumers, disabled old writers,
completed reconciliation, and support obligations. Choose a representative observation
window based on actual usage cycles, including scheduled jobs and offline clients.
Account for telemetry gaps and dormant consumers; zero observed requests is not
proof of zero dependency. Keep recovery viable until the accepted removal boundary.

Remove retired code, configuration, jobs, flags, and obsolete tests within scope.
Preserve tests for continuing contracts, required historical migrations, and useful
migration/version history. Do not delete records merely because active usage ended.
Resolve unknown consumers or obtain an explicit risk decision before destructive work.

Report implemented stages separately from executed migration, verified cutover,
and completed retirement. State remaining dependencies, irreversible effects, and
verification limits. Commit, push, and publication require authorization through
[git-delivery](../git-delivery/SKILL.md).
