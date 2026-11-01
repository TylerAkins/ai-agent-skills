---
name: git-delivery
description: >-
  Prepare scoped Git commits and concise GitHub PR titles and descriptions from
  the actual diff and verification. Use when asked to stage, commit, push, draft
  or update a PR description, or open a PR. Perform only the authorized actions.
---

# Git Delivery

Never dismiss any GitHub review or approval, including stale, bot, or addressed
reviews. Never enable automatic dismissal of stale reviews or approvals in repository
settings or automation. Preserve review history; request re-review only when authorized.

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting messages or
descriptions. Follow repository instructions and templates directly; do not infer
PR requirements from commit or branch naming. Do not require a ticket for fully
specified ticketless work or invent one.

## 1. Establish scope and checks

Identify the requested actions and preserve authorization already given. A message
draft does not authorize staging; staging does not authorize committing; committing
does not authorize pushing or opening a PR. Do not ask again for an action already
authorized within the same scope.

Inspect status, unstaged and staged diffs, recent commit style, the active branch,
and relevant repository conventions. For a PR, verify the intended base, merge
base, and full candidate diff, including relevant commits. Identify unrelated work
before any mutation. Discover required checks from repository instructions, CI
workflows, package scripts, and tool configuration. Include lint, separate formatter
checks, type checks, and relevant tests for affected packages, using configured tool
versions and working directories.

Before each commit or push, run the applicable checks against the exact candidate
and record commands, working directories, actual results, and exit codes. Reuse
recorded results only when they still cover the unchanged candidate. Fix introduced
failures and rerun affected checks after edits, formatter fixes, or hook changes.
If a required check is unavailable or an unrelated failure prevents it from passing,
report the concrete limitation and leave delivery blocked unless the user explicitly
authorizes proceeding with that unmet check. Do not defer local validation to CI.

## 2. Prepare and commit

Stage specific paths or hunks belonging to the request. Inspect the complete staged
diff immediately before committing; selecting paths does not exclude files already
staged. Check for secrets and accidental generated artifacts. Preserve unrelated
staged work; use a verified isolated commit procedure or ask when scope cannot be
safely separated. Do not unstage someone else's work to simplify the commit.

Write a short, concrete subject matching repository style. Add a body only when
the reason, behavior, or tradeoff needs explanation. Base the message on the staged
diff, not the plan or conversation history. Use a message file or safely quoted
input; do not interpolate untrusted prose into shell commands.

Create a new commit unless amendment is specifically authorized. Amendment never
implies permission to rewrite published history. Keep hooks and signing enabled
unless the user explicitly requests otherwise. If a hook changes files or a commit
fails, inspect the actual status and diff before retrying; do not assume the commit
succeeded or amend an earlier commit to recover from a failed attempt.

After committing, verify the commit contents and working state. Report the actual
result without implying unrelated working changes were included or removed.

## 3. Verify the delivery candidate

Before opening a PR or creating a release tag, identify the exact candidate revision
and intended destination. Confirm that the candidate contains the intended changes;
local working changes are not part of a remote PR. Record applicable checks from
repository instructions and CI with their commands, working directories, actual
results, and exit codes. Include the executed test count when a test runner applies.
If a check does not apply, state the reason instead of inventing a passing result.
Keep detailed command output available, but put only reviewer-relevant results in
the PR description.

Reuse checks only while they cover the unchanged candidate. A failed or unavailable
required check blocks delivery unless the user explicitly authorizes proceeding with
that unmet check. Do not impose a test runner where none applies or require an empty
working tree when unrelated changes can be safely excluded. Preserve unrelated work;
use a verified isolated checkout when needed to establish the candidate. This
verification does not authorize a commit, push, PR, tag, or release.

## 4. Prepare PRs and remote actions

For titles, descriptions, or PR creation, read
[PR description guidance](references/pr-description.md). Draft from the final
candidate and observed verification. Include a concise Validation section, or the
repository template's equivalent, summarizing checks and manual flows actually
verified. Keep detailed runner output in the working record. Drafting alone does
not authorize publication.

Before an authorized push, verify the branch, remote, destination, and outgoing
commits. Use a normal push. If rejected, inspect divergence and report the conflict;
do not force-push or rewrite history as an automatic recovery.

Before creating or editing a PR, resolve its repository, head/base branches, title,
body, and requested state. Present the exact proposed title/body and destination
before publication unless that exact content and destination are already approved.
Prepare the complete draft before asking for any missing approval. After creation,
attach the PR when the host provides an attachment tool. Verify and report actual
remote state; check for a successful write before retrying an ambiguous failure.

Create new PRs as drafts unless the user explicitly requests a ready-for-review
PR. Set the creation tool's draft flag explicitly (`gh pr create --draft` or
`draft: true`); a locally drafted description does not set GitHub's PR state.
Verify the created PR's draft state. Preserve an existing PR's state when editing
it, and mark a draft ready for review only when explicitly authorized. Passing
checks or a request to open or publish a PR does not imply ready-for-review state.

Do not change Git configuration, discard unrelated changes, skip checks or hooks,
or perform destructive operations to finish delivery. These require specific user
authorization. Never force-push a protected branch without a specific request.
