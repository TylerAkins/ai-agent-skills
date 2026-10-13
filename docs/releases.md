# Prepare a Release

The release workflow builds all five host bundles and creates a GitHub draft
release with SHA-256 checksums and the source commit. It does not publish the
release or submit marketplace listings.

## Before Running

Merge the intended changes through the repository's normal review process.
Complete the live host checks in [host setup](plugins.md), or disclose the missing
checks in the release notes. Update the version in `plugin.json`,
`.cursor-plugin/plugin.json`, and `.claude-plugin/plugin.json` together.

Create and push an explicitly authorized tag such as `v0.1.0` on the intended
main commit. The workflow accepts only existing stable `vMAJOR.MINOR.PATCH` tags,
requires the tag's commit to be on main's history, and checks the manifest version.

## Build a Draft

Once the workflow is on main, open Actions, select **Prepare release**, and run it
from **main** with the existing tag. The read-only build job checks the candidate,
runs tests and vet, and packages the five hosts. A separate job receives only
those artifacts and uses `contents: write` to create the draft release.

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
