# Accessibility and Layout

Apply the project's accessibility target; use WCAG 2.2 AA as a working engineering
baseline when no target is supplied, without claiming formal conformance from a
partial check. Consult current W3C criteria and ARIA Authoring Practices for the
specific pattern. Prefer native elements; ARIA roles alone do not implement behavior.

## Semantics and Interaction

Use meaningful headings and landmarks, links for navigation, buttons for actions,
and visible associated form labels. Give icon-only controls accessible names and
informative images appropriate alternatives; decorative imagery should not add
noise. Keep accessible names consistent with visible labels.

Verify keyboard operation, logical focus order, visible focus, and no unintended
keyboard traps. For modal dialogs, implement appropriate initial focus, containment,
inert background, dismissal, and return focus with a proven primitive or complete
native implementation. Non-modal patterns must not inherit modal trapping blindly.
Test menus, tabs, comboboxes, and other composite controls against their actual
interaction pattern rather than adding generic tabIndex or key handlers.

Associate errors and instructions with fields, preserve useful input, and announce
important status changes without moving focus or flooding live regions. Check
authentication and validation flows for the applicable accessibility requirements.
Make drag interactions and hover-only information available by accessible alternatives.

## Visual and Responsive Behavior

Check contrast in actual normal, hover, focus, disabled, error, and theme states.
WCAG AA generally requires 4.5:1 for normal text and 3:1 for qualifying large text;
check applicable non-text contrast requirements and exceptions separately. Do not
use color as the sole signal. Verify target sizing/spacing against applicable WCAG
criteria and input needs instead of assuming one pixel size covers every case.

Support reduced motion and avoid unnecessary animation. Check zoom and reflow,
text spacing, sticky elements obscuring focus, long content, localization when
supported, and touch input. Two-dimensional content may need intentional scrolling;
do not remove essential columns or actions merely to eliminate overflow.

Use automated checks for detectable issues plus manual keyboard/focus and relevant
assistive-technology checks. Record the actual coverage and exceptions. A screenshot,
Lighthouse score, or clean scan alone does not establish accessibility conformance.
