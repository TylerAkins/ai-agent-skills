# Contribute a change

Keep contributions focused on a concrete task or observed defect. Discuss a
substantial new skill or workflow in an issue before investing in implementation;
small fixes can go directly to a PR.

## Edit the source

Work on a branch in your clone or fork. Read [repository instructions](AGENTS.md)
and the relevant skill before editing.

- Keep canonical skills in `skills/<name>/SKILL.md`, with owned supporting resources in that folder. Do not edit installed copies or built packages.
- Use a folder-matching skill name and a concise description explaining when it applies. Follow [skill-authoring](skills/skill-authoring/SKILL.md) for the full contract.
- Update sibling links, [routing](skills/using-skills/SKILL.md), and the [README](README.md) when adding, renaming, or removing a skill.
- Preserve authorization boundaries, unrelated work, and tested Jira ADF contracts. Never dismiss GitHub reviews or approvals.
- Attribute external material and respect its license. Keep examples generic unless a named host is necessary.

For README setup edits, cover every installer flavor with install, activation,
and update commands in a labeled collapsed section, including supported shell
variants. Verify the inventory against the installer, not an old table.

## Validate your change

Use the Go version in [go.mod](go.mod). From the repository root, run source
validation and whitespace checks for every change:

```sh
go run ./cmd/skillpack
git diff --check
```

Then select the checks that match the edited artifact:

| Change | Additional verification |
| --- | --- |
| Skills | Follow the skill-authoring evaluation gate, including `go test ./...`. Exercise a representative task when a host is available. |
| README/docs | Verify source-backed commands and claims, local links/anchors, and the rendered reader path. Exercise safe setup commands in scratch destinations. |
| Go tooling or packaging | Check Go formatting, run race tests and vet, and build every target plus legacy aliases into fresh scratch directories. |
| Bash installer/scripts | Run ShellCheck and installer smoke tests. |
| PowerShell | Run the pinned analyzer and native Windows smoke tests. |
| GitHub Actions | Validate YAML with `actionlint` and run affected local checks. |

**Go/tooling checks**

```sh
gofmt -l cmd internal
go test -race ./...
go vet ./...
```

Formatting output must be empty; format only files you changed. Use the
[packaging commands](docs/plugins.md#validate-and-build) for builds. Keep manifest
identity/version aligned across the three manifests. Repository instructions,
credentials, and discovery symlinks must stay out of packages.

**Bash checks**

```sh
bash scripts/ci/check-shell.sh
bash scripts/tests/install-smoke.sh
```

Install ShellCheck first. The checker discovers tracked and non-ignored new shell
scripts; each script needs the correct shebang. Smoke tests use temporary home and
project directories with generated release fixtures. They do not update live hosts.

**Windows checks (PowerShell 7.4+)**

```powershell
Install-Module PSScriptAnalyzer -RequiredVersion 1.25.0 -Scope CurrentUser -Repository PSGallery
pwsh -NoProfile -File scripts/ci/check-powershell.ps1
pwsh -NoProfile -File scripts/tests/install-smoke.ps1
```

The analyzer handles `.ps1`; ShellCheck does not. Keep platform-specific wrappers
clearly separated and shared logic in Go where practical. Add isolated behavioral
coverage and native runners when adding a platform implementation.

The [validation workflow](.github/workflows/validate.yml) runs installer checks on
macOS, Linux, and Windows, then source/package validation. Its Go output is verbose;
use the running Actions job or `gh run watch <run-id>` to monitor an actual CI run.
Local results do not establish that CI passed.

For host tests, record the prompt, host/version, revision, visible skill activity,
result, and limits. File placement and structural checks do not prove selection
or instruction following. Do not claim checks that were unavailable or unperformed.

## Submit a pull request

Use a clear title and the [PR template](.github/pull_request_template.md). Explain
the concrete problem and resulting behavior. Link a real issue when relevant;
do not invent one. Include a concise Validation section describing checks and
manual flows actually verified. Leave detailed runner output out of routine
bullets and disclose material gaps or failures. Screenshots help when appearance
is part of the change.

AI-assisted contributions are welcome. Review the complete diff and verify its
claims before submitting. At the bottom of the PR, name the tool and known model;
use `model unknown` only when unavailable and `None` when no AI assistance was used.
No transcript is required. Follow [git-delivery](skills/git-delivery/SKILL.md) for
authorized Git actions and exact-draft publication gates.

Address feedback with scoped changes. Preserve review history and request
re-review when needed instead of dismissing stale reviews or approvals.
