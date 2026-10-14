# SQL Server and Azure SQL

Verify version, database compatibility level, driver parameter types, indexes,
statistics, isolation, and Query Store availability before tuning.

Read-only queries do not justify `WITH (NOLOCK)`. It permits dirty, missing, or
duplicated rows and still takes schema-stability locks. Use only when the user or
established workload contract explicitly accepts inconsistent results. Never add it
for correctness-sensitive reads. Preserve existing approved hints unless the task
authorizes changing their semantics; flag consequences. Evaluate read committed
snapshot or snapshot isolation as separately authorized database-level proposals,
including operational costs, rather than enabling them during query editing.
[Table hints](https://learn.microsoft.com/en-us/sql/t-sql/queries/hints-transact-sql-table),
[row versioning](https://learn.microsoft.com/en-us/sql/relational-databases/sql-server-transaction-locking-and-row-versioning-guide).

Use plans plus `SET STATISTICS IO, TIME ON` in an authorized session; restore
session settings. Inspect estimates, implicit conversions, spills, key lookups,
blocking, and parameter-dependent plans. Actual plans execute the statement.
A function-wrapped predicate is not proof of a scan; inspect the original access
path before claiming that a range rewrite improves it.
Consider covering/filtered indexes only against workload and write costs. Parameter
sniffing does not automatically justify RECOMPILE or forced plans; verify feature
support and compare representative parameters.
[Query Store](https://learn.microsoft.com/en-us/sql/relational-databases/performance/monitoring-performance-by-using-the-query-store),
[parameter-sensitive plans](https://learn.microsoft.com/en-us/sql/relational-databases/performance/parameter-sensitive-plan-optimization).
