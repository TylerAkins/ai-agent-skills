---
name: readme-design
description: >-
  Design, rewrite, or review a project's README as its public entrypoint. Use when
  readers need to understand the project, choose a path, get started, and find
  deeper documentation. Use technical-documentation for source-derived guides and
  references.
---

# README Design

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting. A README is
the project's entrypoint. Help its intended reader understand what the project
does, decide whether it fits, reach a first useful result, and find deeper detail.
Do not make it a container for every technical procedure.

## Establish the Reader Path

Inspect the repository instructions, current README, project structure, install
and launch paths, and linked documentation. Identify the intended audience and
the first successful outcome they need. Verify all claims and commands against
the repository and authoritative external sources for changeable host behavior.

Organize the page around the reader's next decision:

1. State what the project is and who it helps.
2. Show the shortest supported path to first use.
3. Present meaningful alternatives when the reader must choose between them.
4. Link to detailed procedures, reference, contribution, and maintenance docs.

Keep prerequisites and the first-use path visible. Group optional or audience-
specific detail when it improves scanning, and label collapsed sections by their
contents. Move long troubleshooting, exhaustive configuration, operational
reference, and maintainer procedures to focused documents. Keep linked pages
discoverable and avoid duplicating their procedures in the README.

## Use GitHub Flavored Markdown Deliberately

For GitHub-hosted READMEs, use the source set in
[GitHub Flavored Markdown Mastery](references/github-flavored-markdown-mastery.md).
Choose formatting to clarify hierarchy, actions, comparisons, or optional detail.
Do not use every feature just because GitHub supports it. GFM rendering varies by
surface, so check the actual destination for HTML, diagrams, math, and other
extended features before depending on them.

Use descriptive headings, working relative links, language-tagged code fences,
and concise examples. Use tables only for compact comparisons or structured
facts. Use task lists for actionable progress tracking, not decoration. Use
diagrams when relationships are hard to explain in prose. Use collapsed sections
only when hiding secondary detail makes the main path easier to scan; keep the
summary label informative and the essential path outside. Avoid wide tables,
decorative badges without value, and repeated headings that bury the entrypoint.

## Verify the Rendered Reader Path

Check every local link, heading anchor, command, and referenced file. Follow the
README from its opening through one representative first-use path and confirm the
reader can reach the documented result. Inspect the rendered page on GitHub when
available, including collapsed and expanded content, code fences, tables, images,
and narrow layouts where they matter. If rendering cannot be checked, report that
limit and perform structural checks instead.

When the README needs technical instructions, verify them against the
implementation and move details that need independent maintenance into
[technical-documentation](../technical-documentation/SKILL.md). Change generated
content at its source. Do not describe a README as generated unless a checked-in
generation process actually produces it.

## Anti-Rationalization Guardrails

| Rationalization | Rule |
| --- | --- |
| A README should contain every detail so readers do not need links. | Keep the entrypoint focused and link to maintained task guides or references for depth. |
| More GFM features make a README more polished. | Use a feature only when it improves the reader's task and renders on the target surface. |
| A command appears in an old README, so it must still work. | Trace commands to current scripts, configuration, or authoritative host docs. |
| Markdown source looks fine, so the page is finished. | Inspect the rendered page when available and follow a reader path to first use. |
| If the README is accurate today, it's code-generated. | Claim generation only when a repository generation process exists and was verified. |

Deliver the changed artifact, the reader path and links checked, rendering evidence,
and any material limits. A local edit does not authorize external publication.
