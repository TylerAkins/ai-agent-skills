# Query Patterns and Semantic Traps

Read when writing or rewriting filters, joins, aggregates, or pagination. These
are semantic templates, not benchmarked optimizations. Bind parameter syntax and
types through the actual driver; adapt identifiers and syntax to the target engine.
Do not run examples against a guessed schema.

## Typed Half-Open Ranges

```sql
WHERE e.tenant_id = <tenant_parameter>
  AND e.event_time >= <start_parameter>
  AND e.event_time < <end_parameter>
```

Use bounds of the same applicable type as the stored column. Derive the end from
the business date/time zone before binding; a local day is not always 24 hours.
This can expose an index or partition predicate, but actual pruning/access requires
plan evidence. Preserve the original date conversion's meaning and boundary rows.
Avoid inclusive BETWEEN for adjacent timestamp windows when the contract needs
nonoverlapping intervals.

## Parent Grain and Child Existence

If the requirement is parents with at least one qualifying child, EXISTS can
express it without multiplying parent rows:

```sql
SELECT p.tenant_id, p.id
FROM parents AS p
WHERE p.tenant_id = <tenant_parameter>
  AND EXISTS (
      SELECT 1
      FROM children AS c
      WHERE c.tenant_id = p.tenant_id
        AND c.parent_id = p.id
        AND c.is_active = <active_parameter>
  );
```

Do not replace a join with EXISTS when child columns, duplicate multiplicity, or
aggregates are part of the output contract. COUNT(*) after a LEFT JOIN counts the
unmatched parent's null-extended row. COUNT(child_key) counts non-null keys;
preaggregating children by tenant and parent is another option only when it
preserves required filters and aggregate semantics. Validate the output for zero,
one, and multiple matching children before claiming equivalence.

## NULLs, Outer Joins, and Set Operations

A NOT IN subquery containing NULL can change the result through UNKNOWN. NOT EXISTS
is often clearer for anti-matching, but verify outer NULL handling, correlation,
and tenant scope before substitution. SQL comparisons use three-valued logic;
`col = NULL` does not express an IS NULL test.

Moving a right-side predicate from ON to WHERE can remove unmatched LEFT JOIN
rows. UNION and UNION ALL have different duplicate contracts. DISTINCT is a
semantic operation with possible sort/hash costs, not an automatic cleanup step.
Window default frames can include tied peers; use a contract-specific explicit
frame when cumulative or last-value behavior requires it.

## Pagination and Ordering

OFFSET pagination can become expensive at deep offsets. Keyset pagination may
improve access for a supported seek key, but changes the cursor contract. Require
a deterministic unique tie-breaker, appropriate index/layout, NULL policy, and
consistent direction for every ordering field. Retain filters and tenant scope in
both the first-page and continuation query. Define how concurrent insert/update
activity affects page membership before claiming stable pagination.

For analytical top-N, select the required ordering and tie policy explicitly.
Adding ORDER BY to an existing unordered LIMIT can change which rows are returned;
do not present that as a behavior-preserving performance rewrite.
