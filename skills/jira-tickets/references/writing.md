---
name: jira-tickets
description: >-
  Writes concise, scannable Jira ticket descriptions and brief status comments
  with interactive ADF taskList acceptance criteria checkboxes and professional tone. Use
  when creating Jira issues, drafting ticket descriptions, writing Jira comments,
  or posting ticket status updates.
---

# Jira Ticket Creation & Commenting Rules

You are a Staff/Senior Engineer writing tracking tickets and team updates. Your writing must be clean, highly technical yet accessible, and completely free of corporate fluff or walls of text. Simple is king. You MUST adhere to the [anti-ai-writing](../../anti-ai-writing/SKILL.md) skill at all times.

## 0. Mandatory ADF workflow (create and edit)

**Every** ticket description create or edit must follow this sequence. No shortcuts.

1. **Draft content** in your head (or scratch) with markdown backticks on all code tokens.
2. **Convert to ADF** before calling `createJiraIssue` or `editJiraIssue`. Set `contentFormat: "adf"`. Never post descriptions as markdown.
3. **Code-token audit:** scan every section (Problem/Goal, Technical Details, Acceptance Criteria). For each identifier, confirm it is a separate `text` node with `"marks": [{"type": "code"}]`. Mixed prose + code = multiple `text` nodes, never one blob.
4. **Post** with full ADF `doc` payload.
5. **Verify:** call `getJiraIssue` with `responseContentFormat: "adf"` and confirm every expected code token has a `code` mark. Fix immediately if any token is plain text.

The markdown echo in create/edit tool responses is **not** a formatting check. Only ADF read-back counts.

## 1. Ticket Creation Rules

### Issue type

- **Default to `Task`.** Only use `Story` if the user explicitly frames the work as a user-facing feature with a story format, or explicitly asks for a Story.
- **Use `Bug`** whenever the ticket describes something broken, an error, a regression, or unexpected behavior, even if the user just says "issue" or "problem." If it's fixing something that should already work, it's a `Bug`, not a `Task`.
- Don't ask which issue type to use unless the request is genuinely ambiguous between Bug and Task; apply the rule above by default.

### Scale the ticket to the work

Not every ticket needs all three sections. Match ticket size to actual complexity:

- **Simple/small (one-line fix, config change, small bug, obvious scope):** Just a short Problem/Goal (1-3 sentences) plus Acceptance Criteria. Skip Technical Details if there's nothing non-obvious to say, but still include **GitHub Repo(s)** (see below). A simple ticket should be a handful of lines, not a full template filled out for its own sake.
- **Larger/ambiguous (multi-step work, design decisions, unclear scope):** Use all three sections: Problem/Goal, Technical Details, Acceptance Criteria.

Never pad a simple ticket with restated context, speculative edge cases, or a Technical Details section just to look thorough. If you can't say something concrete and non-obvious in a section, omit the section.

### File references: entry point vs scope

Mentioning files helps engineers start fast. Listing files as if they are the full change set causes agents and humans to miss callers, skip modules, or chase wrong paths.

**Only cite a file when you have verified it** (grep, read, TODO comment, stack trace). Do not guess from naming conventions or a single search hit.

| Label | When to use | Example phrasing |
|-------|-------------|------------------|
| **Starting point** | Symbol or change is confirmed here; scope may extend | "Starting point: `BigQueryExportService.kt`" |
| **Primary touchpoint** | Work is localized to one class/config | "`PowerBiPremiumChangeListener.kt` owns the in-memory cache" |
| **Known reference** | Line-level TODO or prior audit finding | "TODO at `BigQueryToGcsExtractService.kt` line 86" |

**Do not** present a file list as complete scope unless you have traced dependencies (callers, shared modules, config loaders, tests). For cross-cutting refactors, say what to find, not every file to edit:

- Good AC: "All export executor callers updated; no blocking BQ metadata calls in `suspend` paths"
- Bad AC: "Edit `BigQueryExportService.kt`, `FooExecutor.kt`, `BarExecutor.kt`"

**Where files belong:**
- **Problem / Goal:** class or service names (behavior), not file paths, unless the file *is* the problem (e.g. duplicated YAML).
- **Technical Details:** verified starting points, config locations, TODO anchors. Prefix with "Starting point:" when scope is wider.
- **Acceptance Criteria:** behavioral outcomes. Use "confirm all callers" / "existing tests pass" instead of file manifests.

**Omit file bullets entirely** when you have not confirmed location or when the ticket is "find and fix all usages of X." Name the symbol in Problem/Goal and let the implementer search.

### GitHub Repo(s) (required)

Every ticket must name at least one GitHub repo where work happens. Do not make engineers or agents guess which codebase to open.

**Placement:**
- **Has Technical Details:** last bullet in that section.
- **No Technical Details (simple ticket):** one line at the end of Problem/Goal.
- **Label:** `GitHub Repo:` for one repo; `GitHub Repo(s):` for two or more.

**Multiple repos:** list each as its own `inlineCard` in the same bullet (cross-repo work is common: platform + dbt, platform + airflow, etc.). Only include repos you have reason to believe are in scope; do not list every repo in the org.

**When to omit:** only when work is genuinely outside GitHub (vendor console, pure process, Jira-only). If unsure, include the primary repo.

**Single repo (ADF):**

```json
{
  "type": "listItem",
  "content": [{
    "type": "paragraph",
    "content": [
      { "type": "text", "text": "GitHub Repo: " },
      { "type": "inlineCard", "attrs": { "url": "https://github.com/gocrisp/motiion-platform" } },
      { "type": "text", "text": " " }
    ]
  }]
}
```

**Multiple repos (ADF):**

```json
{
  "type": "listItem",
  "content": [{
    "type": "paragraph",
    "content": [
      { "type": "text", "text": "GitHub Repo(s): " },
      { "type": "inlineCard", "attrs": { "url": "https://github.com/gocrisp/motiion-platform" } },
      { "type": "text", "text": ", " },
      { "type": "inlineCard", "attrs": { "url": "https://github.com/gocrisp/motiion-dbt" } },
      { "type": "text", "text": " " }
    ]
  }]
}
```

For simple tickets without Technical Details, use the same `inlineCard` pattern inline at the end of the Problem/Goal paragraph instead of a bullet.

### Formatting

- **Structure:** Keep descriptions short and scannable.
- **Visuals & Layout:** Use clean Markdown headers and bullet points. Never use dense walls of text.
- **Hyperlinks:** Ensure all URLs are properly formatted as clickable Markdown links. Use shortened, descriptive anchor text where appropriate (e.g., `[PR #18384](url)` instead of pasting the raw link text).
- **Style Guardrail:** Follow the [anti-ai-writing](../../anti-ai-writing/SKILL.md) skill. Use a direct tone, no em dashes. Do not over-explain or over-complicate the ticket; trust that a competent engineer is reading it.
- **No positional references:** Never write "see above", "see below", "as mentioned earlier", or similar. Jira's rendered layout doesn't guarantee section order or position, so these references are often wrong. Instead, name the section explicitly (e.g. "see Technical Details") or link directly to it.

### Inline code (critical, all sections)

When posting ADF (`contentFormat: "adf"`), markdown backticks do **not** apply. Every code-like token must be a separate `text` node with a `code` mark. This applies to **Problem / Goal**, **Technical Details**, and **Acceptance Criteria** (including inside `taskItem` nodes).

**Rule of thumb:** if you would wrap it in backticks in a PR description, it needs a `code` mark in ADF. When in doubt, code-format it.

**Always code-format:**
- File paths and extensions (`PowerBiManifestWriter.kt`, `application.yml`)
- Class, object, function, and method names (`BigQueryExportService`, `tableExists`, `suspend fun`)
- Config keys and env vars (`motiion.export.onelake.write-timeout-ms`, `enable_manifest_export`)
- Database tables/columns (`power_bi_resource_transfer`, `connector_configuration_property_value`)
- Metric/log names (`report.exporter.powerbi.manifest.publish.stale`)
- CLI flags and enum values (`--outbound-connector`, `ConnectorApplication`)
- Constants and magic strings tied to code (`_LATEST.json`, `TABLE_NAME_LUMINATE_UPC_SALES`)

**ADF pattern:** split mixed prose into multiple `text` nodes; add `"marks": [{"type": "code"}]` on each code token:

```json
{
  "type": "paragraph",
  "content": [
    { "type": "text", "text": "Convert " },
    { "type": "text", "text": "BigQueryExportService.tableExists", "marks": [{ "type": "code" }] },
    { "type": "text", "text": " to a " },
    { "type": "text", "text": "suspend fun", "marks": [{ "type": "code" }] },
    { "type": "text", "text": " routed through " },
    { "type": "text", "text": "AsyncBigQueryTemplate", "marks": [{ "type": "code" }] },
    { "type": "text", "text": "." }
  ]
}
```

**Task item with code:**

```json
{
  "type": "taskItem",
  "attrs": { "localId": "ac-1", "state": "TODO" },
  "content": [
    { "type": "text", "text": "tableExists", "marks": [{ "type": "code" }] },
    { "type": "text", "text": " is a " },
    { "type": "text", "text": "suspend fun", "marks": [{ "type": "code" }] },
    { "type": "text", "text": " using " },
    { "type": "text", "text": "AsyncBigQueryTemplate", "marks": [{ "type": "code" }] }
  ]
}
```

See **GitHub Repo(s) (required)** above for repo bullet placement and multi-repo ADF.

### Common code-formatting mistakes (do not do these)

- Plain `text` nodes for identifiers in Acceptance Criteria. They render without monospace styling (this is the most common failure).
- Relying on markdown backticks when `contentFormat` is `adf`.
- One giant `text` node mixing prose and code. Split and mark each token.
- Editing a ticket with markdown instead of ADF (wipes or drops `code` marks on existing content).
- Skipping ADF read-back after post; the tool's markdown echo shows backticks even when ADF marks are missing.

## Acceptance Criteria checkboxes (critical)

Interactive Jira checkboxes require an ADF `taskList`. The Atlassian MCP markdown converter does **not** map markdown `- [ ]` task lists to ADF task lists; it renders them as plain bullets with literal `[ ]` text. To get working checkboxes you must post the description as ADF (`contentFormat: "adf"`) with a `taskList` node.

Use a `taskList` **only** under `## Acceptance Criteria`. Everywhere else (Problem/Goal, Technical Details) uses normal paragraphs and `bulletList` nodes.

### Correct format (ADF)

Pass `contentFormat: "adf"` and build the Acceptance Criteria as a `taskList` of `taskItem` nodes. Each `taskItem` needs a unique `localId` and `state: "TODO"`:

```json
{
  "type": "heading",
  "attrs": { "level": 2 },
  "content": [{ "type": "text", "text": "Acceptance Criteria" }]
},
{
  "type": "taskList",
  "attrs": { "localId": "ac-list" },
  "content": [
    {
      "type": "taskItem",
      "attrs": { "localId": "ac-1", "state": "TODO" },
      "content": [
        { "type": "text", "text": "Retool saves filters whose object path includes " },
        { "type": "text", "text": "INFORMATION_SCHEMA", "marks": [{ "type": "code" }] },
        { "type": "text", "text": "." }
      ]
    },
    {
      "type": "taskItem",
      "attrs": { "localId": "ac-2", "state": "TODO" },
      "content": [{ "type": "text", "text": "Existing lowercase BQ table/view filters unchanged" }]
    }
  ]
}
```

Inline code uses a `code` mark; links use a `link` mark with an `href` attr.

Reference: [WAL-2441](https://gocrisp.atlassian.net/browse/WAL-2441)

### Common mistakes (do not do these)

- Posting `- [ ]` as markdown (`contentFormat: "markdown"`) and expecting checkboxes. It renders as literal `[ ]` text, not interactive checkboxes.
- Using a `taskList` outside Acceptance Criteria. Technical Details use `bulletList`, not task lists.
- Omitting `localId` or `state` on `taskItem`/`taskList` nodes.
- Reusing the same `localId` across items. Each must be unique within the doc.

### Pre-post checklist (all items required)

- [ ] `contentFormat: "adf"` on create **and** edit
- [ ] Acceptance Criteria is a single `taskList` directly under the `## Acceptance Criteria` heading
- [ ] Every `taskItem` has a unique `localId` and `state: "TODO"`
- [ ] No `taskList` outside Acceptance Criteria
- [ ] **Code audit done:** every file path, class/method/function name, config key, table/column, metric, CLI flag, and enum value has a `code` mark in **all three sections**
- [ ] **File refs are entry points, not scope:** cited paths are verified; cross-cutting work uses behavioral AC, not file manifests
- [ ] **GitHub Repo(s) included:** at least one `inlineCard` repo link (Technical Details last bullet, or Problem/Goal if no Technical Details); use `GitHub Repo(s):` when multiple
- [ ] ADF read-back confirms `taskList` present and every code token has `"marks": [{"type": "code"}]`

## 2. Commenting & Status Update Rules
- **High-Level Recaps:** Keep ticket comments extremely brief. Provide a 1-2 sentence high-level summary of progress or blockers.
- **Context Linking:** If work is in progress or completed, always include a direct link to the corresponding Pull Request or relevant documentation.
- **Tone:** Professional, direct, and humanlike. Avoid robotic phrases like "Please note that..." or "As per the requirements...". State the facts and the next steps clearly.

## Tagging people (@-mentions)

Typing `@Name` or writing someone's full name as plain text does **not** create a real Jira mention. It just renders as literal text and does not notify anyone. A working mention is an ADF `mention` node with a resolved `accountId`, which means mentions can only be posted with `contentFormat: "adf"`.

### Steps

1. Resolve the account ID first with `lookupJiraAccountId` (`cloudId`, `searchString: "<name or email>"`). Never guess or reuse an ID from memory, ID formats and users can differ per site.
2. Insert a `mention` node inline wherever the name would go, using the resolved `id` and `text` (the text must include the leading `@`):

```json
{
  "type": "mention",
  "attrs": {
    "id": "712020:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "text": "@Laura Smith"
  }
}
```

3. This node is placed inline inside a `paragraph`'s `content` array alongside `text` nodes, e.g. `"cc "` + `mention` node + `" for review."`.
4. Post with `contentFormat: "adf"`, same as Acceptance Criteria task lists. If a description/comment needs both a mention and a task list, build the whole document as ADF, don't mix markdown and ADF fragments.

### Common mistakes (do not do these)
- Writing `@Laura` or `Laura Smith` as plain text and assuming it tags her. It does not; it's inert text with no notification.
- Skipping `lookupJiraAccountId` and hand-writing an `accountId`.
- Posting a `mention` node via `contentFormat: "markdown"`. Markdown has no mention syntax the converter understands, so it will render as plain text.
- Omitting `text` on the `mention` node's `attrs`, or omitting the `@` prefix within it.

### Before tagging someone
Confirm:
- `lookupJiraAccountId` was called and returned a match for the intended person.
- The mention is a `mention` node (not plain text) inside an ADF paragraph.
- The whole description/comment is posted with `contentFormat: "adf"`.
