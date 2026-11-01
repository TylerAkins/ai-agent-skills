---
name: api-design
description: >-
  Design and evolve API and module contracts with explicit behavior, validation,
  error semantics, authorization, and compatibility. Use for endpoints, schemas,
  service boundaries, SDKs, or shared interfaces. Follow existing protocol and
  repository conventions rather than imposing a new API style.
---

# API and Interface Design

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting contracts,
examples, or reports. Inspect existing interfaces, consumers, schemas, transport,
framework versions, and repository conventions. Verify protocol and library semantics
against official documentation. Design-only requests do not authorize implementation.

## 1. Establish the consumer contract

Identify the caller's task, boundary owner, trusted inputs, supported consumers,
and accepted requirements. Use [decision-partner](../decision-partner/SKILL.md)
only for consequential unresolved choices. Before implementation, define the relevant
parts of the contract:

- Data: inputs, outputs, required/optional fields, absent versus null semantics,
  defaults, units, identifiers, and constraints. Keep internal storage shapes and
  privileged fields out of public inputs unless required.
- Behavior: errors, side effects, ordering, atomicity, concurrency, cancellation,
  retry behavior, and compatibility.

Use existing naming and error conventions; do not standardize the entire repository
as a side effect. Keep the contract proportional to the interface's risk and reach.

## 2. Define misuse and failure behavior

Use types and schemas that distinguish valid variants without a bag of contradictory
optional fields. Validate at actual trust boundaries, including external responses,
configuration, and persisted data whose invariants are not guaranteed. Static types
do not validate runtime data. Avoid redundant checks inside established trusted paths.

Enforce authentication, object/action authorization, and tenant scope in effective
reads and writes. Derive identity from trusted context, not caller-selected ownership.
Prevent over-posting, unsafe URLs, injection, and private-field disclosure. Define
bounded inputs, resource use, and pagination consistent with the product's needs.

Use stable machine-readable errors with actionable public messages and safe details.
Distinguish validation, authorization, missing resources, conflicts, transient failures,
and unknown outcomes. Follow the transport's semantics and established disclosure
policy; do not expose raw internals or assume every endpoint uses identical status codes.

Apply only the relevant transport rules:

- For HTTP, preserve method, status, caching, conditional-request, and update semantics.
  Specify omission/null handling for partial updates and distinguish replacement
  from patching.
- For GraphQL, consider nullability, resolver authorization, query cost, and schema
  evolution.
- For events, specify delivery, ordering, schema, and replay contracts.

## 3. Define retries and collections

For retryable effects, define an intent-stable idempotency key, caller/tenant scope,
payload mismatch handling, atomic claiming, in-flight responses, retention, and replay.
Uniqueness alone does not ensure exactly-once external effects: account for crashes
between the effect and result recording, downstream deduplication, and reconciliation
of unknown outcomes. Do not retry an ambiguous non-idempotent operation blindly.

For collections, define filtering, maximum page size, stable ordering and tie-breakers,
continuation validity, and behavior under concurrent inserts/deletes. Bind cursors
to relevant query and scope without treating them as authorization. State partial
results explicitly; counts and pagination metadata must not imply stronger consistency
than the system provides.

## 4. Evolve and verify

Trace all supported producers and consumers, including generated clients, dynamic
references, and deployed versions. Additive fields, enum values, and changed defaults
can break strict consumers. Use [safe-migrations](../safe-migrations/SKILL.md) for
transitions requiring coexistence, deprecation, or breaking changes. Avoid inventing
a new API version when compatible evolution satisfies the requirement.

Use [agent-planning](../agent-planning/SKILL.md) for dependent multi-component work
and [writing-clean-simple-code](../writing-clean-simple-code/SKILL.md) for authorized
implementation. Use [test-authoring](../test-authoring/SKILL.md) for contract tests
at real boundaries, including malformed inputs, authorization denial, tenant isolation,
retry races, serialization, and compatibility as applicable. Verify actual consumer
behavior rather than only mocks or schema validity.

Keep schemas, examples, and relevant documentation consistent with the final behavior.
Use [code-review](../code-review/SKILL.md) for consequential contract review when
available and authorized. Report decisions, actual verification, and unresolved
consumer or execution limits. Publication and Git actions require applicable authorization.
