# Database Migrations and Backfills

## Inspect Engine and Rollout Constraints

Verify engine/version, migration framework, transaction behavior, table size,
indexes, replication, workload, and deployment ordering. Inspect every reader and
writer, including background jobs and alternate profiles. Additive changes can
acquire blocking locks, rewrite data, or increase load; do not label them safe
solely because they add a column or index.

Use expand/contract when old and new application versions coexist. Add compatible
structures first, migrate writers and data, verify readiness, switch readers, then
remove old access and contract in a later supported stage. Check nullable/default
semantics and new-install behavior. Establish which representation is authoritative
through every phase.

## Preserve Data Under Concurrent Writes

Before dual writes, define atomicity, ordering, retry/idempotency, failure recovery,
and reconciliation. Two writes do not become consistent merely because they occur
in one function. Use supported transactions or an explicit eventual-consistency
mechanism appropriate to the storage boundary.

Make backfills bounded, resumable, and idempotent where possible. Use stable keys
or checkpoints and verify progress is committed consistently with transformed data.
Handle concurrent updates without overwriting newer values. Account for deletions,
duplicates, nulls, malformed data, and tenant scope. Define throttling and abort
criteria using actual load, lock time, and replication lag rather than fixed folklore.

Use engine-supported online/index or staged constraint mechanisms when appropriate.
Check their transaction restrictions and failure residue. Verify constraints against
existing rows before relying on them; a newly added declaration may not validate
historical data. Do not silently delete invalid records to force validation.

## Verify Recovery and Contraction

Rehearse representative upgrades, interrupted backfills, retries, mixed-version
access, and permitted rollback paths in a safe environment. Compare data identities
and business invariants, not just row counts. Verify backups and restoration when
recovery depends on them, including potential loss of intervening writes.

Separate code rollback, schema reversal, and data restoration. A down migration
is useful only when it actually preserves the required data and supported versions.
For irreversible changes, define a forward repair or restore procedure and explicit
execution boundary; never fabricate reversibility by recreating an empty column.

Before a destructive step, verify no supported version or reachable job still
uses the old shape and rollback no longer depends on it. Retain historical migration
files required by the framework. Execute live or destructive operations only under
the user's applicable authorization, with observed readiness and recovery limits.
