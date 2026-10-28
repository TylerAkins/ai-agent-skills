# Contributing

Keep contributions focused on a concrete engineering task or an observed defect.
For substantial new skills or workflow changes, open an issue to discuss the use
case before investing in an implementation. Small fixes can go straight to a PR.

## Make a Change

Work on a branch in your clone or fork. Read [repository instructions](AGENTS.md)
and nearby skills before editing.

- Edit canonical content in `skills/<name>/SKILL.md`; keep references and resources
  in that skill's folder. Do not edit installed copies or generated packages.
- Give each skill a folder-matching `name` and a concise `description` explaining
  when it applies. Prefer useful decision guidance over generic advice or rigid rituals.
- Update sibling links, the [routing skill](skills/using-skills/SKILL.md), and the
  [README](README.md) when adding, renaming, or removing a skill.
- Preserve authorization boundaries and tested contracts, particularly Jira ADF.
  Never introduce automatic dismissal of GitHub reviews or approvals.
- Write original guidance. Attribute external material when used and respect its license.

For packaging changes, keep manifest names and versions aligned and follow
[packaging reference](docs/plugins.md). Keep contributor files and repository instructions
out of installed host packages.

## Validate

Use the Go version declared in `go.mod`. From the repository root, run:

```sh
go run ./cmd/skillpack
git diff --check
```

For Go tooling or packaging changes, also run these commands from the repository
root in Bash or PowerShell:

```sh
gofmt -w cmd internal
go test -race ./...
go vet ./...
```

Build all release targets and legacy host aliases into new scratch directories outside the checkout
when packaging changes. Use the commands in [packaging reference](docs/plugins.md).
For installer changes, run `bash scripts/tests/install-smoke.sh` in addition to
linting. It uses temporary HOME/project directories and generated release fixtures.
CI runs Bash tests on macOS and Linux, and native PowerShell tests on Windows
(PowerShell 7.4+).
For PowerShell changes, install the pinned analyzer and run from the repository root:

**Windows (PowerShell 7.4+)**

```powershell
Install-Module PSScriptAnalyzer -RequiredVersion 1.25.0 -Scope CurrentUser -Repository PSGallery
pwsh -NoProfile -File scripts/ci/check-powershell.ps1
pwsh -NoProfile -File scripts/tests/install-smoke.ps1
```

The tests use isolated home/project destinations.

For shell scripts, install ShellCheck and run `bash scripts/ci/check-shell.sh`.
It discovers tracked and non-ignored new `.sh` files, including scripts under future
platform directories. Declare the interpreter in each script's shebang.
For workflow changes, validate the GitHub Actions YAML with `actionlint`.

CI streams verbose Go test results and groups package output by host. Open the
running job in GitHub Actions to watch progress; the run summary records its
revision and result. For CLI monitoring, use `gh run watch <run-id>`.

Keep common installation and package logic in Go where practical, and put
OS-specific wrappers in clearly named platform directories. Add isolated
behavioral tests and native runner coverage with each platform implementation.
The PowerShell checker validates `.ps1` files; ShellCheck does not.

For changed skill behavior, try a representative task in the affected host when
available. Describe the prompt, observed result, and material limitations.
Structural checks alone do not establish that an agent loaded or followed a skill.
Do not claim live verification that was not performed.

## Submit a Pull Request

Use a clear title and the [PR template](.github/pull_request_template.md).
Explain the problem and resulting behavior, link a related issue when one exists,
and report meaningful verification and remaining limits. Screenshots or brief
sanitized examples help when they show changed behavior. Avoid repeated summaries
and generic checklists.

AI-assisted contributions are welcome. Review the complete diff and verify its
claims before submitting; you remain responsible for the contribution. At the
bottom of the PR body, name the tool and model used when known, for example
`AI assistance: Codex, model unknown`. Use `None` when no AI assistance was used.
No transcript is required, and model names should not be guessed.

Respond to review feedback with scoped changes. Preserve review history and
approvals; request another review when needed rather than dismissing stale reviews.
