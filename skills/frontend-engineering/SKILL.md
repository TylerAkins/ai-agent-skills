---
name: frontend-engineering
description: >-
  Build and improve user interfaces with coherent visual design, responsive layout,
  accessible interaction, and reliable state. Use for pages, components, forms,
  frontend behavior, and UI polish. Follow the project's framework and design system
  and verify rendered behavior rather than relying on source or screenshots alone.
---

# Frontend Engineering

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting copy, comments,
or reports. Read repository instructions, existing screens and components, design
tokens, framework/dependency versions, routing, data contracts, and test conventions.
Use the existing stack and utilities; verify unfamiliar APIs against that version's
official documentation. Preserve unrelated work and established product behavior.

## Establish the Screen's Job and Design

Identify the audience, user task, primary action, content hierarchy, required states,
and acceptance criteria. Use supplied designs and existing product patterns first.
For substantial new interfaces, clarify consequential missing requirements and use
[agent-planning](../agent-planning/SKILL.md) when a plan helps. Do not require a
design ceremony for a small, understood change.

When a new visual direction is needed, study relevant references and translate
their useful hierarchy, density, navigation, and interaction principles into the
product's own language. Do not copy proprietary branding, text, assets, or exact
layouts. Record enough design decisions to guide implementation without inventing
an entire design system for one screen.

Use coherent typography, spacing, colors, radii, and emphasis from project tokens.
Prioritize the user's action and information instead of defaulting to generic hero
sections, uniform cards, oversized spacing, or decorative gradients. These patterns
can be appropriate when the product calls for them; do not impose aesthetic bans.
Use realistic content, including long labels and sparse/dense data. Remove unrelated
implementation details from product copy. Keep all exposed controls functional or
clearly identified as unavailable; never disguise a placeholder as a working feature.

## Implement Clear Components and State

Use [writing-clean-simple-code](../writing-clean-simple-code/SKILL.md) for focused
responsibilities and justified abstractions. Prefer composition and established
component APIs over a large matrix of unrelated flags. Split by responsibility,
not arbitrary line counts. Keep data and presentation ownership clear without
forcing a separate container or hook for every component.

Place state where it is owned: local interaction state, shared state, URL state
for navigable/shareable views, and existing server-state tooling for remote data.
Avoid duplicated derived state and contradictory booleans. Do not introduce a
global store merely to avoid a few props. Preserve stable item identity, history
navigation, deep links, and framework rendering/hydration contracts where relevant.

Handle applicable loading, empty, success, error, disabled, pending, and permission
states. Distinguish no data from filtered-out results. Preserve entered data after
recoverable errors, explain how to proceed, and prevent duplicate submissions.
For optimistic updates, account for failure, concurrent changes, stale responses,
and reconciliation. Trace cancellation ownership before cancelling shared requests.
Do not use hidden controls as authorization; server-side enforcement remains required.

## Make Layout and Interaction Inclusive

Read [accessibility and responsive checks](references/accessibility-and-layout.md).
Prefer native semantic HTML and tested accessible primitives. Custom interaction
must implement its complete keyboard, focus, and state contract. Labels, errors,
and status feedback should be understandable without relying on color or animation.

Choose breakpoints where the content needs them and respect existing layout tokens.
Use flexible layouts, appropriate width limits, and responsive assets. Check narrow
and wide views, zoom, long text, empty states, and overflow. Preserve meaningful
content and actions on small screens rather than hiding them to fit a screenshot.

## Preserve Security and Performance

Treat remote content and URLs as untrusted. Use framework-safe rendering; sanitize
only through vetted mechanisms when rich HTML is required. Do not expose secrets
or private records in client bundles, telemetry, or error messages. Scope cached
data to identity/tenant and clear or invalidate it on relevant context changes.

Avoid needless fetch waterfalls, expensive repeated work, oversized dependencies,
and layout shifts. Use the framework's asset, rendering, and loading conventions.
Optimize from measured evidence and product budgets; do not add memoization,
virtualization, or code splitting mechanically. Lab results and field performance
are different evidence and should be reported separately.

## Verify the Rendered Result

Use [test-authoring](../test-authoring/SKILL.md) for behavioral coverage. Run relevant
repository checks and inspect the application in an available browser with realistic
data. Exercise affected actions and state transitions, keyboard navigation, focus,
validation, responsive layout, and applicable browser targets. Inspect console and
network failures relevant to the change. Screenshots establish appearance, not
interaction correctness; automated accessibility scans do not establish conformance.

Compare rendered output with accepted designs or the project's established screens.
Fix discovered clipping, spacing, contrast, or interaction issues and recheck affected
states. Do not run destructive live actions merely to verify a UI; use safe fixtures
or an authorized test environment. If browser access is unavailable, state exactly
what remains unverified rather than calling the interface visually validated.

Report actual changes, tested flows/viewports, and material limits. Use
[code-review](../code-review/SKILL.md) when independent review is warranted,
available, and authorized. Commit, push, and publication use authorized
[git-delivery](../git-delivery/SKILL.md).
