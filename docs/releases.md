# Prepare a Release

The release workflow builds all five host bundles and creates a GitHub draft
release with SHA-256 checksums and the source commit. It does not publish the
release or submit marketplace listings.

## Before Running

Merge the intended changes through the repository's normal review process.
Complete the live host checks in [host setup](plugins.md), or disclose the missing
checks in the release notes. Update the version in `plugin.json`,
`.cursor-plugin/plugin.json`, and `.claude-plugin/plugin.json` together to the
same `MAJOR.MINOR.PATCH` value. The workflow derives the release tag as
`v` plus that version (for example `1.0.0` in the manifests becomes tag `v1.0.0`).

Do not create or push a release tag yourself; the workflow creates the tag when
it creates the draft release, unless an identical tag already points at the
current `main` commit (for example when retrying after a failed draft job).

## Build a Draft

On `main`, open Actions, select **Prepare release**, and run the workflow with
no inputs. The read-only build job reads the manifest version on `main`, runs
tests and vet, validates the collection, and packages the five hosts. A separate
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
