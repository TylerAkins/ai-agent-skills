# MySQL and MariaDB

Identify the product/version, storage engine, SQL mode, collation, isolation, and
driver. Do not assume MySQL and MariaDB share optimizer features or ANALYZE syntax.
Check CTE/window support, strict aggregation behavior, and DML syntax for the target.
[MySQL optimization](https://dev.mysql.com/doc/refman/8.4/en/optimization.html),
[MariaDB EXPLAIN](https://mariadb.com/docs/server/reference/sql-statements/administrative-sql-statements/analyze-and-explain-statements/explain).

Start with EXPLAIN; inspect access type, chosen keys, estimates, filtering, join
order, filesort, and temporary-table work. MySQL EXPLAIN ANALYZE and MariaDB ANALYZE
execute the statement; confirm supported syntax and execution scope first. Statistics
maintenance is a separately authorized operation, not automatic query inspection.
[MySQL EXPLAIN](https://dev.mysql.com/doc/refman/8.4/en/explain.html).

Match predicate types and collations to avoid conversions that obstruct index use.
Design composite indexes around actual access/order patterns and the applicable
leftmost-prefix rules. Evaluate covering access, selectivity, index size, and writes;
do not add an index for every WHERE column. LIMIT needs deterministic ordering when
used for pagination. InnoDB locking and snapshot behavior depend on isolation and
statement type; a read-only label does not justify READ UNCOMMITTED or locking reads.
