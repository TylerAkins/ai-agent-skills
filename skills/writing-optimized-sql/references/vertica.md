# Vertica

Identify version, deployment mode, projections, sort/segmentation keys, partitioning,
statistics, resource pool, and concurrency. Use EXPLAIN to inspect chosen projections,
join order, row estimates, sorting, and redistribution. PROFILE executes the statement;
use only within authorized execution and cost limits. Retain transaction/statement
IDs and relevant runtime metrics when available.
[Query plans](https://docs.vertica.com/24.2.x/en/admin/managing-queries/query-plans/),
[performance tables](https://www.vertica.com/kb/System-Tables-For-Performance/Content/BestPractices/System-Tables-For-Performance.htm).

Optimize for columnar projection access rather than prescribing B-tree indexes.
Inspect whether segmentation avoids network redistribution and sort order supports
filters or joins. Replication can reduce movement for appropriate smaller inputs
but consumes storage; do not propose it universally. Check skew and stale estimates
before attributing slow execution to SQL shape.
[Projections](https://docs.vertica.com/23.3.x/en/admin/projections/).

Projection changes, statistics collection, partition maintenance, and resource-pool
changes need separate execution authority and write/storage/concurrency tradeoffs.
Preserve join multiplicities, NULL behavior, window frames, and version-specific
analytic syntax. Physical design recommendations remain hypotheses until tested
against the representative workload on the actual version.
