# GitHub Actions Trust and Execution

Verify current official documentation before relying on event, token, environment,
or runner behavior. Set explicit minimum token permissions, granting writes only
to jobs that need them. Prefer short-lived OIDC credentials where supported, with
trust restricted to the intended repository, ref/environment, audience, and workflow.

Keep untrusted PR code separate from privileged execution. Do not check out or
execute untrusted head code under privileged pull_request_target or workflow_run
contexts. Verify provenance and content before privileged jobs consume upstream
artifacts; a successful upstream workflow does not make its outputs trusted.
Use isolated runners for untrusted code and assess persistent self-hosted runner exposure.

Treat titles, branch names, issue text, outputs, and dispatch inputs as untrusted.
Pass data through quoted variables or structured arguments instead of inserting
expressions into shell source. Never assume secret masking prevents all disclosure.

Use verified immutable action references or supported workflow dependency lockfiles
under repository policy. Inspect upstream sources and release notes when updating;
confirm SHAs belong to the intended repository. Avoid mutable image tags for
release-critical builds when digest pinning is supported.

## Keep actions on supported majors

When adding or editing workflows, prefer the current stable major release of
first-party actions and other maintained marketplace actions (`actions/checkout`,
`actions/setup-go`, `actions/upload-artifact`, and similar) from each action's
latest release tag, then pin the full commit SHA for that tag. Do not copy SHAs
from old examples, starter templates, or unrelated repos without checking the
action's current release; stale pins are a common source of deprecation warnings
and runner incompatibilities (for example JavaScript actions built for a Node
version the hosted runner no longer provides).

Treat action versions like application dependencies: immutable SHA pins for
integrity, with regular updates through Dependabot, Renovate, or an intentional
bump in the same change that touches the workflow. When upgrading, read the action
release notes for breaking input or behavior changes; re-run affected workflows
on a branch before merging.

If the repository configures Dependabot for `package-ecosystem: github-actions`,
merge or replicate those updates instead of letting action pins age across majors.

## Triggers and required checks

Check pull_request, push, dispatch, tag, reusable-workflow, and merge_group events
only as relevant. Verify checkout/ref behavior, fork token restrictions, available
secrets, conditions, needs propagation, concurrency, and required check names.
Keep aggregate required checks from reporting success when a required job failed
or was unintentionally skipped. Test filtered and failure paths as well as happy paths.

Use separate protected environments for deployment and preserve configured approval
rules. Restrict credential access to trusted jobs. Serialize conflicting deployments
where necessary and verify cancellation/retry behavior before enabling it. A normal
push may trigger delivery; inspect those effects before using it as a validation step.
