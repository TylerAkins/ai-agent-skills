---
name: git-delivery
description: >-
  Prepare scoped Git commits and concise GitHub PR titles and descriptions from
  the actual diff and verification. Use when asked to stage, commit, push, draft
  or update a PR description, or open a PR. Perform only the authorized actions.
---

# Git Delivery

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting messages or
descriptions. Follow repository instructions and templates directly; do not infer
PR requirements from commit or branch naming. Do not require a ticket for fully
specified ticketless work or invent one.

## Establish Scope

Identify the requested actions and preserve authorization already given. A message
draft does not authorize staging; staging does not authorize committing; committing
does not authorize pushing or opening a PR. Do not ask again for an action already
authorized within the same scope.

Inspect status, unstaged and staged diffs, recent commit style, the active branch,
and relevant repository conventions. For a PR, verify the intended base, merge
base, and full candidate diff, including relevant commits. Identify unrelated work
before any mutation. Run required checks appropriate to the change; reuse recorded
results only when they still apply to the candidate.

## Prepare and Commit

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

## PR Descriptions and Remote Actions

For titles, descriptions, or PR creation, read
[PR description guidance](references/pr-description.md). Draft from the final
candidate and observed verification. Drafting alone does not authorize publication.

Before an authorized push, verify the branch, remote, destination, and outgoing
commits. Use a normal push. If rejected, inspect divergence and report the conflict;
do not force-push or rewrite history as an automatic recovery.

Before creating or editing a PR, resolve its repository, head/base branches, title,
body, and requested state. Present the exact proposed title/body and destination
before publication unless that exact content and destination are already approved.
Prepare the complete draft before asking for any missing approval. After creation,
attach the PR when the host provides an attachment tool. Verify and report actual
remote state; check for a successful write before retrying an ambiguous failure.

Do not change Git configuration, discard unrelated changes, skip checks or hooks,
or perform destructive operations to finish delivery. These require specific user
authorization. Never force-push a protected branch without a specific request.
