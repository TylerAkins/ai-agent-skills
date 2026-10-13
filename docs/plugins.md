# Local Plugin Setup

Build packages from the feature branch until a release is approved. Git and the Go
version in `go.mod` are needed to build/validate packages, not to use installed skills.
Run these commands from the collection checkout:

```sh
go test -race ./...
go vet ./...
go run ./cmd/skillpack
```

The validator checks this collection's metadata, links, inventories, and manifest
contracts. It is not a complete implementation of either host's JSON Schema, nor
does it prove skill behavior. CI runs these checks and builds both host packages
with read-only GitHub permissions. It never publishes or changes review settings.

## Cursor

Cursor needs its specific package to load the routing rule and independent reviewer.
The portable package carries skills only. Create the local-plugin parent directory
and build directly into a new plugin directory:

```sh
mkdir -p "$HOME/.cursor/plugins/local"
go run ./cmd/skillpack -target cursor -out "$HOME/.cursor/plugins/local/ai-agent-skills"
```

The output must not already exist. The tool refuses to overwrite it and ships no
symlinks, repository `AGENTS.md`, build tools, or credentials. Reload Cursor with
Developer: Reload Window, then inspect Customize for the plugin, 19 skills, routing
rule, and independent-reviewer agent. Local imports must be allowed by your account
or team policy; a marketplace install with the same name can take precedence.

Do not link this checkout into the local-plugin directory. Cursor skips links whose
target is outside that directory. See [Cursor local testing](https://cursor.com/docs/plugins)
and [plugin component reference](https://cursor.com/docs/reference/plugins).

## Codex

Build the portable package into a new directory outside the source checkout:

```sh
mkdir -p /tmp/ai-agent-marketplace/plugins
go run ./cmd/skillpack -target codex -out /tmp/ai-agent-marketplace/plugins/ai-agent-skills
```

For a fresh test marketplace, create `/tmp/ai-agent-marketplace/.agents/plugins/marketplace.json`:

```json
{
  "name": "ai-agent-skills-local",
  "plugins": [
    {
      "name": "ai-agent-skills",
      "source": {
        "source": "local",
        "path": "./plugins/ai-agent-skills"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Productivity"
    }
  ]
}
```

Create the parent directories first. If a marketplace already exists, merge the
entry after inspecting it instead of replacing the file. With a Codex CLI version
supporting plugin marketplaces, register the source:

```sh
codex plugin marketplace add /tmp/ai-agent-marketplace
```

Use the desktop plugin directory to install the local plugin, then start a new chat.
The installed copy can be cached, so rebuilding the source alone does not necessarily
refresh the installed plugin. Follow the host's refresh/update flow and verify the
loaded version. The temporary directory is for testing; use a persistent location
for an installation you intend to keep. See [OpenAI local plugin guidance](https://developers.openai.com/plugins/build/plugins).

The portable package contains all skills and references, not Cursor's rule or agent.
Codex uses its native delegation capability for independent review when available.
Explicitly invoke `using-skills` for routing or `implement-plan` for an accepted plan.
No unsupported Codex agent configuration is shipped.

## Avoid Duplicate Skill Versions

Before enabling the plugin, inspect existing personal/project skill folders and
other plugins for overlapping names. Choose one active source for this collection.
Compare and back up customized copies; disable or move retired copies only after
confirming which files belong to them. This setup does not remove anything automatically.

The plugin does not provide authenticated Jira or GitHub access. Configure those
connections separately in the target host. Your personal PR-preflight skill stays
outside the package; repository rules can invoke it separately when appropriate.

## Update and Verify

Build updated packages into new staging directories outside this checkout. Compare
the contents, preserve any local customizations, and replace only the installation
you own. Reload/refresh the host and verify the active version and components.
There is no automatic installer, marketplace submission, or release publisher yet.

Before distribution, test in both hosts:

1. Verify discovery and explicit invocation, including sibling reference loading.
2. Read a Jira issue in intake mode without Jira writes.
3. Generate a plan containing the `implement-plan` handoff.
4. Build within authorization, run checks, and obtain fresh final independent review.
5. Verify repair/re-review behavior, and that unavailable review is reported incomplete.
6. Confirm no commit, push, external reply, deployment, or review dismissal occurs
   without its applicable authorization. Reviews must never be dismissed.

File validation and package tests have been run; these live host checks are still
pending. Do not treat successful installation as evidence that the complete workflow works.
