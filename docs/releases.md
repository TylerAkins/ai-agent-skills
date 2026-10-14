# Prepare a Release

The release workflow builds four bundles: Cursor, Claude, portable plugin, and
skills-only. It creates a GitHub draft release with SHA-256 checksums and the
source commit. It does not publish the
release or submit marketplace listings.

## Before Running

Merge the intended changes through the repository's normal review process.
Complete the live host checks in [host verification](plugins.md#verify-in-each-host), or disclose the missing
checks in the release notes. Update the version in `plugin.json`,
`.cursor-plugin/plugin.json`, and `.claude-plugin/plugin.json` together to the
same `MAJOR.MINOR.PATCH` value. The workflow derives the release tag as
`v` plus that version (for example `1.0.0` in the manifests becomes tag `v1.0.0`).

Do not create or push a release tag yourself; the workflow creates the tag when
it creates the draft release, unless an identical tag already points at the
current `main` commit (for example when retrying after a failed draft job).

## Archive Compatibility

Codex and Copilot share `ai-agent-skills-portable`; OpenCode, Gemini CLI, Muse Code,
and Antigravity share `ai-agent-skills-skills`. Cursor and Claude retain separate
archives. Each archive uses its package name as its internal root directory.

Updated installers prefer shared names listed in `SHA256SUMS` and select legacy
`codex`, `copilot`, or `opencode` archives only when the corresponding shared name
is absent. Failed downloads, invalid checksums, or unexpected archive roots stop
installation; they do not trigger fallback to another asset.

Older installer copies cannot consume the new portable archive or the consolidated
OpenCode distribution. Update the installer checkout before installing a new
release, or pin a compatible older release. Already-installed host files are
unaffected until an authorized installation/update. Source builds keep legacy host
targets so updated helpers can still build historical release tags.

## Build a Draft

On `main`, open Actions, select **Prepare release**, and run the workflow with
no inputs. The read-only build job reads the manifest version on `main`, runs
tests and vet, validates the collection, and packages all four distribution targets. A separate
job uploads artifacts and uses `contents: write` to create tag `v{version}` at
that commit (if needed) and a draft GitHub release.

If a draft for that tag already exists, or a published release already exists,
the workflow fails instead of overwriting assets. Delete the draft or publish it
before preparing another run for the same version.

Download and inspect the draft's bundles. On Linux, verify downloads with:

```sh
sha256sum --check SHA256SUMS
```

On macOS, use `shasum -a 256 --check SHA256SUMS`. Keep all downloaded files in the
same directory. Checksums detect changed bytes; they are not signed provenance.

Review the source commit, host results, and release notes before publishing the
draft through GitHub. Publishing is a separate authorized action. The workflow
does not overwrite an existing release or replace assets automatically; inspect a
failed or partial attempt before retrying.

## Dependency Maintenance

Dependabot checks Go modules and GitHub Actions weekly and assigns update PRs to
`TylerAkins`. The configuration takes effect on the default branch. Security
alerts and automatic security-update PRs are enabled separately in repository settings.
Updates still require review and checks; no auto-merge or review dismissal is configured.
