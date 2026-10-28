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
the project's public entrypoint. Help its intended reader understand what the
project does, decide whether it fits, reach a first useful outcome, and find deeper
detail. Do not turn it into a generic project template or a container for every
technical procedure.

## Discover the project

Inspect repository instructions, the current README, the top-level structure, and
linked documentation. Use filenames and directory names to find likely sources,
then read the relevant manifests, configuration, entrypoints, scripts, and source
before stating what the project does.

Establish only facts that affect the reader's path:

- Project type, intended users, primary languages, frameworks, and notable capabilities.
- Supported install, build, launch, and test commands, with prerequisites and expected results.
- Important configuration, dependency, and CI behavior that readers need to use or contribute.
- Existing documentation, visual assets, license terms, and contribution instructions when relevant.

Trace feature claims to implementation. Trace commands to scripts, package metadata,
build files, or official host documentation. A manifest's presence does not prove
that a dependency or feature is active. Preserve accurate existing content and
replace claims only when the sources support the correction.

## Choose content for this project

There is no required section list. Choose sections from the reader's decisions and
the project's actual capabilities. Usually establish a clear title and summary,
then show installation and basic use when the project can be installed or run. Add
features, prerequisites, development, testing, API, screenshots, or other material
only when it answers a real reader question and can be supported by repository
evidence.

Do not add License or Contributing sections by default. GitHub already surfaces
repository license and contribution affordances when the corresponding files are
present. Include a short section only when it provides necessary information that
those files and the GitHub interface do not. Add acknowledgments, roadmaps, badges,
tool inventories, and TODO placeholders only when requested or supported and useful.

Organize the page around the reader's next decision:

1. State what the project is and who it helps.
2. Show the shortest supported path to first use.
3. Present meaningful alternatives when the reader must choose between them.
4. Link to deeper task guides, references, and maintainer material when useful.

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
| A README generator has a required section list. | Select sections from this project's actual reader needs; do not fill a template mechanically. |
| A standard License or Contributing section is expected. | Omit it by default when GitHub and the repository files already surface the information; add it only to answer a specific reader need or user request. |
| A manifest or directory name proves what a feature does. | Trace feature claims to relevant source and configuration before describing them. |
| Missing information should become a TODO section. | Omit unsupported content or resolve the missing fact; do not publish invented placeholders. |
| CI exists, so a status badge belongs in the README. | Add badges only when they provide useful, current information to the intended reader. |
| More GFM features make a README more polished. | Use a feature only when it improves the reader's task and renders on the target surface. |
| A command appears in an old README, so it must still work. | Trace commands to current scripts, configuration, or authoritative host docs. |
| Markdown source looks fine, so the page is finished. | Inspect the rendered page when available and follow a reader path to first use. |
| If the README is accurate today, it's code-generated. | Claim generation only when a repository generation process exists and was verified. |

Deliver the changed artifact, the reader path and links checked, rendering evidence,
and any material limits. A local edit does not authorize external publication.
