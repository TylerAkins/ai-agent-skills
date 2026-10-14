# Oracle Database

Identify database version, optimizer/session settings, schema types, bind types,
indexes, statistics, partitioning, and permitted tooling. Use bind variables through
the driver; do not assume a literal plan represents bind-sensitive workloads.

Distinguish EXPLAIN PLAN estimates from the executed cursor. Where authorized and
available, use DBMS_XPLAN.DISPLAY_CURSOR with the relevant SQL ID and child cursor;
actual row statistics require appropriate collection settings. Compare estimated
and actual cardinalities, buffer work, join methods, and spills. Do not enable
instrumentation globally or imply runtime statistics exist when they were not
collected. Confirm privileges and license entitlement before using AWR, ASH,
Diagnostics/Tuning Pack features, or tuning advisors.
[DBMS_XPLAN](https://docs.oracle.com/en/database/oracle/oracle-database/19/arpls/DBMS_XPLAN.html),
[plan collection](https://blogs.oracle.com/sql/how-to-create-an-execution-plan).

Preserve Oracle's empty-string/NULL behavior, DATE values containing time, timestamp
variants, and implicit conversion semantics. Prefer typed binds to NLS-dependent
string dates. Verify version support before pagination, MERGE, or optimizer syntax.
Function-based/composite indexes, partition pruning, hints, and plan management need
workload evidence and separate scope for state changes. DDL can commit transactions;
a rollback wrapper does not make schema experiments safe.
[SQL reference](https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/).
