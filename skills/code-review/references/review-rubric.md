# Five-Axis Review Rubric

Apply the axes to the affected behavior and repository conventions. Depth should
follow the change's risk; a checklist is a prompt for investigation, not proof.

## Correctness

Check source requirements, preserved public contracts, edge cases, error paths,
serialization, compatibility, and state transitions. Trace async completion,
cancellation ownership, retries, cleanup, and transaction atomicity when affected.
Inspect tests for independent expected outcomes, actual production behavior, and
relevant negative and boundary cases. A plan or green suite cannot settle a
contradictory source requirement.

## Readability and Simplicity

Check whether names and control flow communicate the behavior using project idioms.
Investigate redundant branches, dead code, silent fallbacks, and comments that
obscure an invariant. Preserve useful compatibility code and required documentation.
Recommend simpler structure when it removes a demonstrated maintenance burden;
shorter code is not automatically clearer code.

## Architecture

Trace ownership, module boundaries, shared policy, canonical utilities, dependency
direction, and all supported consumers. Check that a refactor reduces complexity
instead of moving it. For changed keys, interfaces, or types, search configuration,
aliases, fixtures, serialization, and dynamically constructed names. Explain
the concrete structural remedy when a finding is supported.

For dependency upgrades, read changelogs and migration notes for the actual version
range. Inspect transitive changes in the lockfile and affected API consumers,
defaults, and runtime behavior. Verify compatibility with relevant tests; a
successful installation or a semantic version label does not establish it. State
material coverage gaps rather than assuming an unchanged caller remains compatible.

## Security

Trace untrusted inputs and output recipients. Verify authentication, authorization,
tenant and scope isolation in effective queries and mutations, injection resistance,
secret handling, and public error contracts. Check allow and deny paths, wrong-user
or tenant behavior, missing identity, and preserved access where relevant. For
dependency changes, inspect pinned versions, lockfile changes, authoritative
advisories, and compatibility evidence; do not infer safety from installation alone.

## Performance

Investigate query amplification, unbounded work, pagination, blocking hot paths,
allocation, repeated rendering, and resource lifecycle. Trace composed concurrency
against actual limits. Tie findings to reachable workloads and supported evidence;
do not invent timing estimates or demand optimization without demonstrated impact.
