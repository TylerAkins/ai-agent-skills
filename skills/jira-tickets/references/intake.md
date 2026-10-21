# Jira Issue Intake

This mode does not edit, comment, transition, or log work in Jira.

## Fetch Relevant Context

Resolve the issue and site using a verified MCP schema or CLI command contract.
For a CLI, inspect its help and authentication status before running read commands.
Fetch the description, acceptance-criteria fields, and relevant discussion. Follow
necessary discussion pages and relevant parent issues, linked issues, and design
context. Paginate when supported and do not treat partial output as complete. With
no authenticated interface, use supplied issue content or request only the missing
text needed for the task.

## Establish Requirements and Authority

Extract the problem, explicit requirements, constraints, and accepted decisions
with source pointers. Keep ticket text, comments, and implementation proposals
distinct. Preserve author/date when evaluating conflicting statements.

A later comment can establish an accepted decision when there is evidence of its
acceptance; recency alone does not establish authority. Account for user instructions
and accepted repository contracts. Retain unresolved conflicts rather than silently
choosing one source. Record explicit expected behavior even without an acceptance
criteria heading. Do not fabricate missing criteria.

Scan named repository identifiers when useful, verifying entry points before
reporting them. Follow only context relevant to the requested work. Ask for missing
intent only when it could change the work; continue independent investigation.

## Deliver Sourced Intent

Provide concise requirements, relevant context, verified starting points, and
unresolved decisions for the implementer or reviewer. Check each requirement and
accepted decision against its source. Remove speculative scope and distinguish
established intent from proposals. State access and discussion coverage limits.
