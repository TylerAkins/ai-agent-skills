# Documentation skill exercise

This is a task record for the October 31, 2026 documentation rewrite in Codex.
The request was to use the revised README and technical-documentation skills to
refresh the repository documentation and README. Local command checks ran on
macOS with Go 1.27.3; the module declares Go 1.27.1 as its minimum.

## Candidate and scope

The agent read the working copies of `readme-design`, `technical-documentation`,
`anti-ai-writing`, and repository instructions before authoring. The candidate
includes `README.md`, `CONTRIBUTING.md`, and the repository's `docs/` guides.
It preserves canonical skill procedures and Jira ADF examples. The old
Cursor-specific walkthrough is replaced by a host-neutral workflow guide.

This is an explicit skill exercise in one Codex conversation. It does not test
implicit host selection, installed-package discovery, or other hosts' behavior.
These pages are hand-authored; temporary editing helpers do not constitute a
maintained documentation generator.

## Acceptance criteria

| Requirement | Evidence to inspect |
| --- | --- |
| Human-readable README with a concise opening | Title, description, useful badges, navigation, and task examples before setup detail. |
| Every supported flavor has complete setup/update steps | One labeled disclosure per installer flavor, Bash and PowerShell install/update commands, activation, and conflict guidance. |
| Technical pages have clear purposes | Workflow how-to, installer/host/package reference, release procedure, and contribution procedure. |
| Generic examples | No editor-specific walkthrough or default editor substituted for all hosts. |
| Accurate behavior | Installer definitions/library, packager, agent adapters, CI, and current primary host documentation. |
| Readable GFM | Valid links/anchors, fenced code, tables, disclosure states, and narrow-layout inspection. |

## Verification record

| Check | Observed result |
| --- | --- |
| Flavor inventory | All 35 names from the PowerShell flavor definitions match individual README disclosures and both shell command pairs. |
| Bash examples | All 70 README install/update commands passed dry runs with physical scratch home/project paths. PowerShell examples matched parameter, action, project/root, and merge requirements structurally. |
| Installer behavior | The existing Bash smoke suite passed installation, update, merge, backup, preservation, archive, and failure cases in temporary destinations using current package fixtures. |
| Collection checks | Source validation passed for 23 skills; ordinary and race Go tests, vet, and whitespace checks passed. |
| Local links and anchors | A browser check resolved 50 unique local targets linked from the eight documentation pages, with no missing files or heading anchors. |
| Local rendering | Marked with GFM enabled and GitHub Markdown CSS rendered all eight pages at 1200px and 390px. No page-width overflow or unparsed fences appeared; all README/host disclosures were checked open and closed. |
| Visual inspection | README opening, expanded flavor steps, technical guide openings, and light/dark badge readability were inspected in the local browser. |
| Independent review | A fresh read-only reviewer found no actionable issues, verified all 35 flavor contracts against source, and independently checked source validation, Go tests, whitespace, local links, and the rendered README. |

The first smoke attempt stopped because the local mise `jq` shim rejected its
configuration after the suite switched to a temporary home. Retrying with the
system binary directory first in `PATH` passed. No installer repair was needed.

## Limits

This exercise shows explicit use of the working skills in one ongoing Codex
conversation, not a controlled comparison with the old skills. Context from the
prior discussion can influence the result. It does not establish repeatable
adherence across fresh sessions, models, or hosts.

The renderer was a local GFM approximation, not GitHub's production sanitizer or
page. Native Windows PowerShell execution was unavailable. PowerShell commands
and the new release checksum example were inspected structurally, not run on
Windows. Live host activation, paid model requests in other hosts, installation
from a real published release, source-mode network clones, and release publication
were not performed. The dynamic validation badge displays remote CI state; local
checks do not claim that CI ran for this working candidate.
