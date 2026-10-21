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

- For understanding, planning, or starting work from an issue, read
  [issue intake](references/intake.md). This mode is read-only.
- For descriptions, issue creation or edits, comments, and mentions, read the full
  [writing and ADF rules](references/writing.md) before preparing the payload.
  Follow its ADF construction, code-token audit, task lists, repo cards, mention
  lookup, and read-back procedure without substituting Markdown conversion.
- If the task includes both, establish sourced requirements through intake first,
  then apply the writing rules to the authorized draft or write.

Discover available Jira interfaces before acting. Check configured MCP tools and
installed CLI executables, then inspect the actual tool schemas or command help and
authentication status. Resolve the site from the supplied URL or verified account
configuration; do not guess cloud IDs, command names, or parameter contracts.
Choose either MCP or CLI based on the verified capabilities of the operation. For
writes, use an interface only when it can submit the required ADF and support the
required read-back. If neither interface is available, or it cannot preserve those
contracts, keep the draft local and use supplied issue content for intake.

Prepare complete text, destinations, and ADF payloads before any required approval.
Drafting alone does not authorize issue creation, edits, transitions, or work logs.
For external comments and status updates, obtain approval of exact text and
destinations under anti-ai-writing; retain approval for unchanged approved drafts.
Post only authorized changes and perform the required ADF read-back. Preserve
unrelated existing content, attributes, and completed task states when editing;
the writing reference's `TODO` examples apply to newly created criteria.

Report actual outcomes and formatting limits. Structural checks or a Markdown
echo do not prove that Jira retained interactive checkboxes, code marks, or mentions.
