---
name: jira-tickets
description: >-
  Read Jira issues into sourced requirements and unresolved decisions, or draft,
  create, and edit concise Jira descriptions and status comments. Use when a Jira
  key or URL is supplied for work, or Jira writing is requested. Preserve explicit
  ADF formatting for interactive acceptance criteria, code marks, and mentions.
---

# Jira Tickets

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting human-facing text.
Select the requested operation; reading an issue does not authorize Jira writes.
Preserve prior authorization within its scope.

Choose the applicable mode, not every mode in sequence:

- For understanding, planning, or starting work from an issue, read
  [issue intake](references/intake.md). This mode is read-only.
- For descriptions, issue creation or edits, comments, and mentions, read the full
  [writing and ADF rules](references/writing.md) before preparing the payload.
  Follow its ADF construction, code-token audit, task-list, repo-card, mention
  lookup, and read-back procedure without substituting Markdown conversion.
- If both modes apply, establish sourced requirements through intake first, then
  apply the writing rules to the authorized draft or write.

## Perform Jira operations

1. Discover the available interfaces before acting. Check configured MCP tools and
   installed CLI executables, inspect actual schemas or command help, and verify
   authentication. Resolve the site from the supplied URL or verified account
   configuration; do not guess cloud IDs, command names, or parameter contracts.
2. Select MCP or CLI only after confirming it supports the requested operation. For
   writes, it must accept the required ADF and support the required ADF read-back.
   If no available interface meets those requirements, keep the draft local; for
   intake, use supplied issue content rather than guessing or degrading formatting.
   For intake-only work, complete the read-only intake procedure, report its results,
   and stop. Steps 3–6 apply only to drafting or authorized writing.
3. Prepare complete text, destinations, and ADF payloads before any required
   approval. Drafting alone does not authorize issue creation, edits, transitions,
   or work logs.
4. For external comments and status updates, obtain approval of the exact text and
   destinations under anti-ai-writing. Retain approval for unchanged approved drafts.
5. Perform only authorized writes, using the complete ADF payload. When editing,
   preserve unrelated existing content, attributes, and completed task states; the
   writing reference's `TODO` examples apply to newly created criteria.
6. After an authorized write, read the issue back as ADF and verify the required
   formatting. If a code token is plain text, fix it within the approved scope and
   repeat the read-back. If read-back is unavailable, report the write as unverified;
   if a defect remains, report it as incomplete. Structural checks or rendered
   Markdown do not prove Jira retained interactive checkboxes, code marks, or mentions.

Report actual outcomes and formatting limits.
