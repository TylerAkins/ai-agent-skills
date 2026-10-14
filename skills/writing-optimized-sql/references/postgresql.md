# PostgreSQL

Verify version, column types, collation, statistics, indexes, and caller preparation
behavior. Use EXPLAIN first; EXPLAIN (ANALYZE, BUFFERS) executes SQL and needs safe
authorized data and resource bounds. Compare estimates with actual rows, loops,
buffers, sorts, spills, and access paths.
[Using EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html).

Choose B-tree, partial, expression, covering, GIN/GiST, or BRIN indexes only for
supported operators, predicates, and data distribution. Inspect heap access and
visibility when evaluating index-only scans; an index does not guarantee them.
Statistics maintenance and concurrent index construction have operational effects
and require their own scope.
[Indexes](https://www.postgresql.org/docs/current/indexes.html).

Check version-dependent CTE inlining/materialization and generic versus custom
prepared plans instead of assuming CTEs or preparation improve performance.
Preserve timestamptz versus timestamp semantics and window frames. MVCC does not
eliminate contention: locking reads, DDL, long transactions, and resource pressure
still matter. For queue consumers, SKIP LOCKED changes the result contract and is
not a general optimization for reporting queries.
[WITH queries](https://www.postgresql.org/docs/current/queries-with.html),
[transaction isolation](https://www.postgresql.org/docs/current/transaction-iso.html).
