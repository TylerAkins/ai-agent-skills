# Snowflake

Record account features, warehouse size/type, concurrency, role, cache state, table
type, clustering, and query ID. Distinguish queue/compilation time from execution.
Use Query Profile for partition pruning, join expansion, spills, and expensive
operators. Cached results and warehouse cache can distort comparisons.
[Execution times and profiles](https://docs.snowflake.com/en/user-guide/performance-query-exploring).

Do not prescribe traditional B-tree indexes for standard Snowflake tables; verify
table type and supported access features. Predicate pruning, clustering, search
optimization, materialized views, and warehouse changes address different workloads
and can add maintenance/credit costs. Propose them from measured evidence, not from
a relational-database index checklist.
[Performance optimization](https://docs.snowflake.com/en/guides-overview-performance).

Preserve case-sensitive quoted identifiers, timestamp variants and session time
zones, NULL handling, and duplicate/tie semantics. QUALIFY can express window
filtering clearly but is not proof of a faster plan. In MERGE, verify source-key
uniqueness and deterministic match behavior before executing DML. Warehouse scaling
and cache-setting changes require explicit execution scope.
[MERGE](https://docs.snowflake.com/en/sql-reference/sql/merge).
