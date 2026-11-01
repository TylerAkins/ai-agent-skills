---
name: readme-design
description: >-
  Design, rewrite, or review a project's README as its public entrypoint. Use when
  readers need to understand the project, choose a path, get started, and find
  deeper documentation. Use technical-documentation for source-derived guides and
  references.
---

# README Design

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting. Make the README
human-readable, visually coherent, and useful from first glance to first use.
Preserve project identity and accurate existing content. Review-only requests do
not authorize edits; README work does not authorize publication.

## 1. Establish the reader and facts

Inspect repository instructions, the current README, linked docs, and relevant
source, manifests, configuration, and scripts. Establish the intended audience,
project purpose, supported capabilities, and paths to first use. Trace commands,
prerequisites, and feature claims to implementation or authoritative documentation.
Do not infer behavior from filenames or dependency presence. Resolve missing facts
before publishing dependent claims, or omit them and report the gap.

## 2. Design the opening and reader path

Start with a clear title and a short description of what the project does and who
it helps. Use existing branding where useful. Add a screenshot, demo, diagram, or
representative output when it makes the result easier to understand. Do not force
a banner or visual onto a project that needs only a small working example.

Choose a few useful, current badges with consistent styling and meaningful link
targets. Omit vanity metrics, redundant signals, and badges that overwhelm the
introduction. Check visual assets for readability on light and dark backgrounds,
provide useful alt text, and avoid essential information available only in images.

Arrange content so readers can understand the project, decide whether it fits,
choose a supported path, reach a first useful result, and find deeper documentation.
Show commands in context with prerequisites and an expected outcome. Make install
choices and first use easy to find without a long preamble. When presentation is
weak or a redesign is requested, consult [design examples](references/design-examples.md)
for specific patterns rather than copying another project's layout wholesale.

## 3. Keep every section useful

Choose sections for this project's reader needs. Do not fill a fixed template.
Features, architecture, FAQ, roadmap, acknowledgments, contribution, and license
sections belong only when they add supported information the reader needs. Link
to existing repository files rather than repeating their contents. Remove unused
placeholders, repetitive summaries, and inventories that do not help first use.

Keep shared prerequisites and navigation visible. Use clearly labeled collapsible
sections for independent installation paths or optional detail, with each expanded
path complete enough to follow. Preserve all supported alternatives and required
install, activation, and update instructions; brevity does not justify deleting
paths. Keep platform-specific commands clearly labeled and treat supported tools
equally unless the project has a justified recommendation. Use generic examples
unless a named tool is necessary for the actual project.

Link long troubleshooting, exhaustive configuration, and maintainer procedures to
focused documents. Use [technical-documentation](../technical-documentation/SKILL.md)
for those guides. Follow repository requirements when procedures must remain in
the README; do not replace required instructions with a link.

## 4. Format with GitHub Flavored Markdown

Use GFM for Markdown READMEs unless the destination explicitly requires another
format. Apply [GFM guidance](references/github-flavored-markdown-mastery.md) when
selecting or checking syntax. Distinguish GFM from GitHub-specific features and
check support on the target surface.

Use a logical heading hierarchy, focused paragraphs, descriptive links, inline
code for identifiers, and language-tagged code fences. Use tables for compact
comparisons, ordered lists for steps, and task lists only for actual tracked work.
Avoid wide tables, nested disclosures, decorative separators, and repeated headings.
Use a short navigation row or table of contents when it helps readers find their
path. Keep spacing and visual styling consistent; add formatting only when it
improves comprehension or navigation.

## 5. Verify the result

Check local links, heading anchors, referenced files, and commands. Follow one
representative first-use path from the opening to the expected result, using safe
commands where feasible. Check every required installation alternative for completeness.
Change generated content at its maintained source; claim generation only when a
verified generator exists.

Inspect the rendered destination when available: opening hierarchy, spacing,
navigation, code, tables, images, and collapsed sections in both states. Check
narrow layouts and light/dark readability when relevant. If rendering or commands
cannot be checked, report the specific limit and perform available structural
checks. Markdown parsing does not prove usability or working commands.

Deliver the changed artifact, checks actually performed, and material limits.
