# BigQuery GoogleSQL

Confirm GoogleSQL, project/dataset location, parameter types, table partitioning
and clustering, pricing/reservation model, and permitted bytes/cost. Use a dry run
for validation and estimated bytes; it is not a latency benchmark or correctness
test. Actual jobs cost resources; set an applicable maximum-bytes-billed limit
rather than treating read-only SQL as unlimited execution.
[Dry runs](https://docs.cloud.google.com/bigquery/docs/running-queries#dry-run).

Project required columns, use eligible partition filters, and inspect pruning in
job evidence. Check whether the original date expression already prunes before
rewriting it. [Partition pruning](https://docs.cloud.google.com/bigquery/docs/querying-partitioned-tables).
LIMIT on SELECT * does not reliably reduce scanned bytes. Reduce
join inputs at the correct grain; avoid explosive joins and repeated UNNEST fan-out.
Verify NULL/empty-array behavior, approximate aggregate contracts, and timestamp
versus date/time-zone boundaries.
[Query computation](https://docs.cloud.google.com/bigquery/docs/best-practices-performance-compute).

Use execution stages and job statistics to examine bytes, slot time, shuffle,
skew, and output growth. Separate cached results from actual execution; CTEs do
not guarantee materialized reusable work. Treat materialized views, clustering,
partition changes, and capacity changes as separate costed proposals.
[Query insights](https://docs.cloud.google.com/bigquery/docs/query-insights).

## Preferred Join Style

For this collection's BigQuery guidance, prefer `USING` for equality joins when
keys have identical names and the resulting columns match the output contract:

```sql
SELECT o.tenant_id, o.order_id, i.item_id
FROM `project.dataset.orders` AS o
JOIN `project.dataset.items` AS i
USING (tenant_id, order_id);
```

Include every required key, especially tenant scope; USING does not imply uniqueness
or prevent join fan-out. Use ON for differently named keys, expressions, inequalities,
or additional join conditions. Do not rename columns or move an outer-join ON
predicate into WHERE just to force USING. Avoid NATURAL JOIN.

USING merges join-key output columns, changes SELECT * column order, and coalesces
keys for FULL OUTER JOIN. Preserve explicit projections, qualified references,
NULL behavior, and outer-join results when converting existing ON joins. The
company preference is a style rule, not a performance claim.
[USING semantics](https://docs.cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#using_clause).
