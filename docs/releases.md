# Prepare and verify a release

The **Prepare release** workflow builds seven archives with checksums and a source
commit, then creates a draft GitHub release. This guide ends with a reviewed draft;
publishing and marketplace submission require separate authorization.

## Prepare the candidate

1. Merge the intended changes through normal review.
2. Update `plugin.json`, `.claude-plugin/plugin.json`, and `.cursor-plugin/plugin.json` together to the same `MAJOR.MINOR.PATCH` version.
3. Run the [packaging checks](plugins.md#validate-and-build). Complete relevant [host checks](plugins.md#verify-in-each-host), or retain their limits for release notes.
4. Confirm that `v{version}` is unused, or already points to the exact current `main` commit after a partial attempt.

The workflow derives the tag from the manifest. Do not manually create or move a
tag as a routine release step. If a tag points elsewhere, investigate and prefer
a new version rather than rewriting published history.

## Build the draft

On `main`, open Actions, select **Prepare release**, and run it with no inputs.
The workflow accepts only `main` and serializes release runs for that ref.

| Job | Behavior | Permission |
| --- | --- | --- |
| Build | Checks Go formatting, shell scripts, race tests, vet, and source validation; builds seven archives and checksum files. | Repository read. |
| Draft | Downloads the artifacts, verifies checksums and source commit, and creates the tag if needed plus a draft release. | `contents: write`. |

If a release already exists for the version, the workflow stops rather than
replacing it. Inspect failed or partial state before retrying. A leftover draft
must be deliberately reconciled before another run; a published release needs a
new manifest version. The workflow does not publish automatically.

## Verify downloaded artifacts

Download all draft archives, `SOURCE_COMMIT`, and `SHA256SUMS` into one directory.
Open a shell there and verify every checksum.

**Linux (Bash)**

```sh
sha256sum --check SHA256SUMS
```

**macOS (Bash)**

```sh
shasum -a 256 --check SHA256SUMS
```

**Windows (PowerShell 7.4+)**

```powershell
foreach ($line in Get-Content -LiteralPath SHA256SUMS) {
    if ($line -notmatch '^([a-fA-F0-9]{64})\s+\*?(?:\./)?(.+)$') {
        throw "Invalid checksum line: $line"
    }
    $expectedHash = $Matches[1]
    $assetPath = $Matches[2]
    if ((Get-FileHash -LiteralPath $assetPath -Algorithm SHA256).Hash -ne $expectedHash) {
        throw "Checksum mismatch: $assetPath"
    }
}
```

Every listed file must exist and match. Compare `SOURCE_COMMIT` with the intended
candidate. Checksums detect changed bytes; they are not signed provenance.
Review release notes, host evidence, and package contents before an authorized
publication. Do not retry an ambiguous write without inspecting remote state.

## Archive compatibility

Each archive has an internal root named `ai-agent-skills-{target}`. See the
[package inventory](plugins.md#package-contents) for exact contents.

| Installation | Preferred release target |
| --- | --- |
| Codex/Copilot skills or portable plugin | `portable` |
| OpenCode/Gemini/Muse/Antigravity skills | `skills` |
| Claude plugin, skills, or agents | `claude` |
| Cursor plugin or skills | `cursor` |
| Codex native agents | `codex` |
| OpenCode native agents | `opencode` |
| Cursor/Copilot/Gemini/Antigravity native agents | `native-agents` |

Updated helpers prefer shared `portable`/`skills` names in `SHA256SUMS` and use
legacy `codex`, `copilot`, or `opencode` archives only when the preferred name is
absent. A failed download, checksum mismatch, or wrong archive root stops the
install; it does not trigger fallback. Agent-only flavors require an archive
containing the matching native agents.

Update the installer checkout before consuming newer releases. Older installers
may expect separate host archives. Installed files remain unchanged until an
installation/update is performed. Source-build aliases support historical tags;
source mode still builds a remote ref, not local unpublished edits.

## Dependency maintenance

[Dependabot](../.github/dependabot.yml) checks Go modules and GitHub Actions weekly
and assigns its PRs to `TylerAkins`. This configuration takes effect on the default
branch. Security-alert and automatic security-update settings are separate.

## Implementation map

| Contract | Source |
| --- | --- |
| Candidate version and identity | [Portable manifest](../plugin.json), [Claude manifest](../.claude-plugin/plugin.json), [Cursor manifest](../.cursor-plugin/plugin.json) |
| Jobs, permissions, archive names, retry behavior | [Release workflow](../.github/workflows/release.yml) |
| Platform checks | [Validation workflow](../.github/workflows/validate.yml) |
| Preferred and legacy release selection | [Bash library](../scripts/lib/install.sh), [PowerShell installer](../scripts/install-ai-agent-skills.ps1) |
