---
name: writing-optimized-sql
description: >-
  Write, review, and optimize SQL queries, procedures, and application SQL for
  SQL Server, MySQL/MariaDB, PostgreSQL, BigQuery, Snowflake, Databricks SQL,
  Oracle, Vertica, and Teradata;
  preserve result semantics and verify tuning against plans and measured workloads.
---

# Writing Optimized SQL

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting. Deliver
readable, dialect-correct SQL and evidence proportional to the requested outcome.
Writing a query does not authorize executing it against a live database, changing
isolation settings, creating indexes, resizing compute, or deploying schema changes.
Preserve existing execution authorization and its database, tenant, and cost scope.

## 1. Establish the engine and contract

Before executable SQL, identify the engine/version, compatibility level or runtime,
query purpose, schema and types, join keys and uniqueness, caller parameters,
expected output grain, ordering, and relevant NULL/time-zone rules. Inspect actual
SQL and callers; do not invent columns or infer key uniqueness from names.
For tuning, obtain representative cardinalities, skew, indexes or physical layout,
statistics, concurrency, and the available plan/profile or slow-query evidence.
Request only facts needed for the current query and next step. Schema/types and
result semantics support a safe candidate; plans, distribution, and concurrency
support measured tuning. Missing benchmark data need not block a labelled draft.

Choose new query, correctness repair, or behavior-preserving optimization. Resolve
ambiguous behavior before a rewrite that could change results. For unknown engines,
verify their official syntax and planner behavior before making executable claims.
Do not translate one dialect's hints, indexes, or transaction model mechanically.

Load only the relevant engine reference:

| Engine | Reference |
| --- | --- |
| SQL Server or Azure SQL | [SQL Server](references/sql-server.md) |
| MySQL or MariaDB | [MySQL and MariaDB](references/mysql-mariadb.md) |
| PostgreSQL | [PostgreSQL](references/postgresql.md) |
| BigQuery GoogleSQL | [BigQuery](references/bigquery.md) |
| Snowflake | [Snowflake](references/snowflake.md) |
| Databricks SQL or Spark SQL | [Databricks](references/databricks.md) |
| Oracle Database | [Oracle](references/oracle.md) |
| Vertica | [Vertica](references/vertica.md) |
| Teradata Vantage | [Teradata](references/teradata.md) |

Gate: record the engine, required behavior, permitted execution, and missing
prerequisites. Unknown schema or dialect blocks executable output; provide a
clearly labelled template or investigation steps instead of invented working SQL.

## 2. Write for correctness and readability

For join, filter, aggregation, or pagination rewrites, read
[query patterns](references/query-patterns.md) for semantic traps and scoped templates.

Specify needed columns, qualify ambiguous names, use meaningful aliases, and
parameterize values using the caller's driver. Allowlist dynamic identifiers;
value parameters cannot bind table names or sort expressions. Preserve predicates
that enforce tenant scope, authorization, soft deletion, and row-level security.

Keep joins at the intended grain. Establish many-to-one versus many-to-many keys
before aggregation; do not hide fan-out with DISTINCT. Preserve duplicate counts,
NULL semantics, outer-join rows, numeric precision, collation, time-zone boundaries,
and tie behavior. Use explicit ordering with a unique tie-breaker when deterministic
pagination or ranking is required. Validate window frames and aggregation grain.
Read-only intent alone does not permit inconsistent results. Use SQL Server `NOLOCK`
only when the contract explicitly accepts dirty reads; see the SQL Server reference.

Prefer typed parameters and predicates on stored/indexed or partition columns.
Half-open date ranges can avoid wrapping a timestamp in a function, but derive
bounds in the contract's time zone and precision. Do not assume EXISTS, joins,
CTEs, temporary tables, or window functions are inherently faster than alternatives.
For procedures and DML, preserve transaction ownership, retries, idempotency,
constraints, error propagation, and affected-row contracts.

## 3. Diagnose before tuning

Read [verification and measurement](references/verification.md) before executing
SQL or comparing candidates. Inspect estimated versus actual rows, access paths,
join fan-out, spills, sorts, pruning, shuffle, blocking, and compilation as relevant
to the engine. Distinguish compute execution from queueing, network/fetch time,
result caching, and lock waits. `EXPLAIN ANALYZE` executes SQL, so check its effects,
scope, workload, and resource limits before running it. An expensive operator is a
hypothesis to test, not proof that its syntax is wrong.

Change one causally justified factor per comparison. Prefer query-local changes
that retain semantics. Propose indexes, statistics maintenance, materialization,
partitioning/clustering, isolation changes, or compute changes separately, with
write/storage/cost implications. Verify the engine version and physical design before
proposing an index or hint; warehouse pruning and distributed execution require
engine-specific evidence. Use
[safe-migrations](../safe-migrations/SKILL.md) for authorized schema or state changes;
this skill does not grant that execution scope.

Gate: connect each proposed change to observed evidence or label it a hypothesis.
Do not call a query optimized solely because it is shorter or has an index hint.

## 4. Verify and deliver

For new behavior or a bug repair, use
[test-authoring](../test-authoring/SKILL.md) to establish expected results and
regression sensitivity before production repair. For a behavior-preserving rewrite,
compare original and candidate on stable representative data using the same inputs
and contract; include multiplicities, NULLs, boundaries, ties, and empty matches.
Checksums and row counts alone cannot prove equivalent results.

Run the destination's SQL parser/compiler or actual-engine validation when available.
Static lint does not establish database semantics. Complete the correctness gate
before performance comparison. Preserve raw plan/profile and measurement evidence,
including candidate SQL, parameter sets, environment, cache state, and resource cost.
Use representative repeated comparisons; do not promise a universal speedup.

Report the SQL, engine/version, semantic changes if any, evidence for each change,
actual checks, before/after measurements, and operational tradeoffs. Distinguish
written, syntax-checked, correctness-tested, and benchmarked status. If execution or
representative data is unavailable, deliver a proposal plus exact validation steps;
leave correctness/performance gates unverified rather than fabricating results.
No database CLI, paid warehouse, or language runtime is universally required.
