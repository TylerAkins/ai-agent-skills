# Databricks SQL and Spark SQL

Identify SQL warehouse versus cluster, runtime/version, Photon availability,
catalog permissions, table format/layout, and workload budget. Verify syntax and
features for that execution surface; generic Spark behavior is not enough.

Inspect EXPLAIN and query profiles for scan pruning, row growth, shuffle, skew,
join selection, memory/spills, and scheduling versus execution. Profiles describe
executed work; reading SQL does not establish performance.
[Query profile](https://docs.databricks.com/aws/en/sql/user/queries/query-profile).

Project needed columns and filter early where semantics and planner behavior permit.
Avoid accidental cartesian joins and explosion of array/map data. Do not force
BROADCAST without credible build-side size and memory evidence; adaptive planning
and hints are runtime-dependent. Preserve ANSI mode, NULL semantics, timestamp
types/time zones, and deterministic window ordering.
[Join hints](https://docs.databricks.com/aws/en/sql/language-manual/sql-ref-syntax-qry-select-hints).

Consider data skipping, file compaction, and liquid clustering for the actual
layout and supported runtime. OPTIMIZE and changes to layout or compute are
separately authorized operations with cost. Do not prescribe OPTIMIZE, ZORDER,
partitioning, and liquid clustering as interchangeable universal steps.
[Liquid clustering](https://docs.databricks.com/aws/en/tables/clustering).
