# Teradata Vantage

Identify version, deployment, table type, primary index or NoPI design, partitioning,
statistics, AMP distribution, workload rules, and spool limits. Read EXPLAIN for
access paths, cardinality confidence, join strategy, redistribution/duplication,
partition elimination, and spool growth. Estimated steps are not runtime metrics;
use authorized query logs or monitoring evidence for elapsed work and skew.
[Database design](https://docs.teradata.com/r/Enterprise_IntelliFlex_VMware/Database-Design/Primary-Index-Primary-AMP-Index-and-NoPI-Objects/Performance-Considerations-for-Primary-Indexes).

A primary index determines data distribution and access; it is not interchangeable
with a primary-key uniqueness constraint or a traditional B-tree index. Assess
selectivity, distribution, skew, and join alignment together. Statistics and physical
design changes require separate scope; do not blindly collect every column's
statistics or change the primary index as a query-local repair.
[Primary indexes](https://docs.teradata.com/r/Enterprise_IntelliFlex_VMware/Database-Design/Indexes-and-Maps/Primary-Indexes-and-Primary-AMP-Indexes).

Preserve SET versus MULTISET duplicate behavior, session transaction mode, NULL/date
semantics, and QUALIFY/window ordering. Reduce intermediate row expansion and spool
with contract-preserving filters and aggregation. Determine whether lack of statistics,
resource contention, or skew explains the plan before adding hints or changing SQL.
