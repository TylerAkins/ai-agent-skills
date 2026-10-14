# SQL Verification and Measurement

Read before executing query validation or benchmarking. Use the target engine,
version, driver, and representative schema. A different engine's successful parse
cannot establish dialect correctness.

## Execution Boundary

Inspect the complete statement and called functions/procedures. SELECT can invoke
side effects or acquire locks; profiling may execute the underlying statement.
Use already-authorized environments, least-privilege credentials, scoped data,
resource budgets, and bounded timeouts. Never print credentials or sensitive rows.
Use sanitized fixtures and aggregate diagnostics where possible.

Estimated plans, BigQuery dry runs, and dialect lint can establish limited structural
evidence. Actual SQL Server plans, PostgreSQL/MySQL EXPLAIN ANALYZE, MariaDB ANALYZE,
and warehouse query profiles entail actual execution. Do not execute DML, expensive
scans, or administrative commands merely to obtain evidence. A transaction rollback
may not undo sequence consumption, external effects, DDL, or all engine behavior.
Read-only access does not authorize unlimited compute spend or contention.

## Correctness Gate

Record expected output grain, duplicate semantics, ordering, and typed values
before testing. Include relevant fixtures:

- Empty matches, NULL keys/values, duplicates, missing foreign keys, and multiple child rows.
- Multiple tenants with overlapping local IDs and unauthorized rows.
- Date/time boundaries, daylight-saving changes, numeric precision, and collation.
- Ranking ties, deterministic pagination, and aggregate/window frame boundaries.
- For DML/procedures: constraints, retries, concurrent writers, failures, and rollback limits.

Compare full typed results in a safe harness on stable data. Treat unordered outputs
as multisets with duplicate counts; compare ordering only where the contract requires
it. Bidirectional EXCEPT commonly removes duplicates and is insufficient by itself.
Use dialect-supported EXCEPT ALL or explicit multiplicity comparison when appropriate;
verify NULL equality and type semantics. Small floating-point tolerances must follow
an accepted numeric contract, not conceal a regression.

Use the same snapshot or isolated fixture for both candidates. Separate runs on
changing live data cannot prove equivalence. Concurrency/isolation changes require
concurrent tests, not just static row equality. No failure may be hidden by rewriting
the expected result to match the candidate.

For a new query, assert independently specified expected results. For a repair,
record the actual failing behavioral assertion against the old version and passing
runner output against the candidate. For an optimization, retain the original as
the equivalence baseline. Missing execution leaves this gate unverified.

## Performance Gate

Record original/candidate SQL, engine/version, schema/layout/statistics, inputs,
data size/distribution, hardware or warehouse configuration, session settings,
isolation, concurrency, timeout, and cache state. Capture available raw plan/profile
IDs or sanitized artifacts. Track queueing and compilation separately from execution.

Choose metrics from the workload: elapsed latency and variability, logical/physical
reads, rows examined, CPU, memory/spills, lock waits, bytes scanned, slot time,
shuffle, credits, or compute cost. Report repeated runs for representative selective,
broad, empty, and skewed inputs as applicable. Alternate candidate order to reduce
cache/order bias. Separate warm-cache and cold-cache comparisons without clearing
shared production caches or changing warehouse configuration without authorization.

Define the target metric and acceptable correctness/resource tradeoffs before
comparison. Record run count, failures/timeouts, measurements, and limitations.
Estimated optimizer cost, a single faster run, or a cached result is not a measured
workload speedup. Recheck required evidence after material SQL/layout changes.

## Delivery Record

Provide the final SQL and bound parameter types, followed by:

| Evidence | Required record |
| --- | --- |
| Contract | Engine/version, output grain, scope, ordering, isolation, permitted execution |
| Correctness | Harness/command, fixtures, actual output/status, comparison method |
| Performance | Baseline and candidate metrics, runs, plan/profile, cache and workload conditions |
| Operations | Index/layout/compute proposals, cost, maintenance and recovery requirements |
| Limits | Unavailable data, untested inputs/hosts, and unexecuted validation steps |

Keep unavailable evidence visibly unverified. A useful draft can be delivered
without execution, but cannot be labelled correctness-tested or performance-verified.
