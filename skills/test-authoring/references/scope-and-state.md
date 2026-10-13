# Scope and State Coverage

Select cases from the affected contract and actual execution path. These are
investigation prompts, not a requirement to add every case to every change.

## Query Selection and Optimization

Compare returned identities, ordering, and requested scope, not just counts or
mock fetch arguments. Exercise applicable empty and maximum inputs, null values,
cutoff ties, identifier types, duplicates, and partial mappings. Verify that mixed
valid/invalid inputs either preserve the full requested scope or reject the input
according to the contract; do not accept a valid subset silently unless allowed.

Use independently justified expected results. Comparing optimized and original
implementations is useful compatibility evidence, but agreement alone cannot prove
either one satisfies the requirement.

## Tenant and Authorization Boundaries

Use multiple tenants or users with distinguishable records. Verify applicable
allow/deny paths, missing identity, wrong-user or tenant access, and preserved
non-gated behavior. Test effective reads and mutations, including shared helpers
and database predicates when process-boundary mocks hide isolation failures.
An empty result alone does not demonstrate correct scoping.

## Persisted State and Configuration

Check applicable first and repeated runs, enable/disable, edits, deletion, reload,
stale caches, old schemas, profile overrides, and defaults. Trace configuration
through its producer and real consumer; testing a parsed flag alone does not
establish downstream behavior. Keep fixture state isolated between runs and verify
cleanup or restoration on failure.
