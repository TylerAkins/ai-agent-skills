# Packaging Reference

For normal installation, updates, and activation, expand your host in the
[README](../README.md#install).
This page is for maintainers inspecting or building host packages.

## Package Contents

Every target contains the complete `skills/` collection and supporting resources.

| Release target | Hosts | Additional components |
| --- | --- | --- |
| `cursor` | Cursor | `.cursor-plugin/plugin.json`, `rules/`, `agents/`, LICENSE |
| `claude` | Claude Code | `.claude-plugin/plugin.json`, `agents/`, LICENSE |
| `portable` | Codex, Copilot | Root `plugin.json`, LICENSE |
| `skills` | OpenCode, Gemini CLI, Muse Code, Antigravity | LICENSE; no plugin manifest |

The release workflow publishes these four `.tar.gz` archives. Installer flavors
still select host-specific destinations and activation steps. The `codex`,
`copilot`, and `opencode` build targets remain available for existing source-build
consumers; their contents match `portable`, `portable`, and `skills`, respectively.

Cursor includes a routing rule and reviewer; Claude includes the reviewer.
The agent requests read-only review through instructions, not a tool sandbox.
Codex and Copilot rely on their host's available review/delegation capabilities.

Repository `AGENTS.md`, tooling, credentials, and the `.cursor/skills` discovery
symlink are excluded. Do not symlink this checkout into Cursor's local-plugin
folder; external targets are skipped.

## Validate and Build

Use the Go version in `go.mod`. From the checkout:

```sh
go test -race ./...
go vet ./...
go run ./cmd/skillpack
```

Build into new directories outside the checkout:

```sh
package_root=$(mktemp -d)
for host in cursor claude portable skills; do
  go run ./cmd/skillpack -target "$host" -out "$package_root/$host"
done
```

The output directories must not exist. The packager refuses overwrite and validates
each generated package. Checks cover our metadata, local links, inventories, and
package contracts, not complete host schema or behavioral validation.

For a temporary source checkout and local installation, use
[installer source mode](installer-reference.md#source-builds-and-manual-installation).
For release assets, use [release preparation](releases.md).

## Verify in Each Host

Before distributing a changed workflow, test it in the relevant app:

1. Confirm discovery, explicit invocation, and sibling reference loading.
2. Read a Jira issue in intake mode without writes.
3. Generate a plan containing the `implement-plan` handoff.
4. Implement within authorization, run checks, and obtain fresh independent review.
5. Verify repair/re-review handling and reporting when review is unavailable.
6. Confirm commits, pushes, external replies, and deployments require applicable authorization. Reviews must never be dismissed.

File placement and installer tests do not establish that an agent followed the
workflow. Record the host/version, observed results, and missing checks.

## Host References and Distribution

- [Cursor plugins](https://cursor.com/docs/plugins) and [manifest reference](https://cursor.com/docs/reference/plugins)
- [OpenAI local plugins and marketplaces](https://developers.openai.com/plugins/build/plugins)
- [Claude plugins](https://code.claude.com/docs/en/plugins) and [manifest reference](https://code.claude.com/docs/en/plugins-reference)
- [Copilot plugin formats](https://docs.github.com/en/copilot/concepts/agents/about-plugins)
- [OpenCode skills](https://opencode.ai/docs/skills/)
- [Gemini CLI skills](https://geminicli.com/docs/cli/using-agent-skills/)
- [Antigravity skills](https://antigravity.google/docs/skills)
- [Muse Code skills](https://meta-models.github.io/muse-code-sdk/next/guides/extend/skills/)

Packaging and release assets do not create marketplace listings. Cursor submissions
go through [the publisher form](https://cursor.com/marketplace/publish).
Codex, Claude, and Copilot have separate marketplace formats; OpenCode, Gemini CLI, Muse Code, and Antigravity consume
skill folders directly. Publishing/registering a marketplace remains a separate
authorized action.
