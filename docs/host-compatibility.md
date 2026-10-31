# Host compatibility

Use this reference to distinguish installed files, host discovery, and actual
skill execution. The native installers provide 35 flavors across eight host
families. The [README](../README.md#native-shell-installer) contains every flavor's
install and update commands; the [installer reference](installer-reference.md)
records exact destinations and conflict handling.

Host documentation describes available mechanisms. It cannot guarantee that a
model will choose a skill or follow every instruction. Check the specific client,
version, session, and workspace where you use the collection.

[Skills by host](#skills-by-host) · [Subagents](#specialized-subagents) · [Integration boundaries](#integration-boundaries) · [Evidence limits](#behavioral-evidence-and-limits)

## Skills by host

The paths below describe this collection's native installation choices, not every
compatible discovery root a host may support. Project paths are relative to the
selected repository; `~` is the user profile. Plugins can add separate skill sources.
Official skill references were consulted October 31, 2026; live invocation is a
separate check.

| Host | Global skill flavor and path | Project skill flavor and path |
| --- | --- | --- |
| Antigravity app/IDE | `antigravity-global`: `~/.gemini/config/skills` | `antigravity-project`: `.agents/skills` |
| Antigravity CLI | `antigravity-cli-global`: `~/.gemini/antigravity-cli/skills` | `antigravity-project`: `.agents/skills` |
| Claude Code | `claude-global`: `~/.claude/skills` | `claude-project`: `.claude/skills` |
| Codex | `codex-global`: `~/.agents/skills` | `codex-skills`: `.agents/skills` |
| GitHub Copilot | `copilot-global`: `~/.copilot/skills` | `copilot-skills`: `.github/skills` |
| Cursor | `cursor-global`: `~/.cursor/skills` | Manual `.cursor/skills`; no project skills-only flavor. |
| Gemini CLI | `gemini-global`: `~/.gemini/skills` | `gemini-project`: `.gemini/skills` |
| Muse Code | `muse-global`: `~/.agents/skills` | `muse-project`: `.agents/skills` |
| OpenCode | `opencode-global`: `~/.config/opencode/skills` | `opencode-project`: `.opencode/skills` |

<details>
<summary>Antigravity app, IDE, and CLI</summary>

The [official skills guide](https://antigravity.google/docs/skills) documents
model selection and manual invocation. The app/IDE exposes active skills in
**Customizations**. The CLI supports `/skills reload` and skill slash commands.

The CLI reads the shared `~/.gemini/config/skills` directory as well as
`~/.gemini/antigravity-cli/skills` and `~/.gemini/skills`. The app does not read
those CLI-specific directories. The standalone IDE also accepts legacy
`~/.gemini/antigravity/skills`. Choose one source to avoid duplicates.

</details>

<details>
<summary>Claude Code</summary>

The [official skills guide](https://code.claude.com/docs/en/skills) documents
automatic matching and explicit `/skill-name` invocation. Native global installs
honor an absolute `CLAUDE_CONFIG_DIR`; project installs remain in `.claude/skills`.

The `claude` flavor installs a plugin loaded with `--plugin-dir` for each session.
Plugin skills use scoped names such as `/ai-agent-skills:code-review`. A native
`code-review` skill can shadow the bundled skill of the same name; check the
resolved source before comparing behavior.

</details>

<details>
<summary>Codex</summary>

The [official skill guide](https://learn.chatgpt.com/docs/build-skills) documents
implicit selection from descriptions, `/skills` and `$` invocation in CLI/IDE,
and repository/user `.agents/skills` discovery. Restart if changed skills do not
appear.

The `codex-desktop` and `codex-marketplace` flavors prepare a portable plugin and
local desktop catalog. App activation remains separate. They do not register a
CLI marketplace or install native agents. Native agents use separate flavors.

</details>

<details>
<summary>GitHub Copilot</summary>

The [official skills guide](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/add-skills)
covers supported surfaces and description-based loading. Personal skills remain
local; cloud-agent use needs repository-hosted skills. Check your actual surface
rather than assuming every app, IDE, CLI, and cloud session shares local files.

`copilot-staging` prepares a portable plugin payload only. The helper does not
create the [marketplace](https://docs.github.com/en/copilot/concepts/agents/about-plugins)
needed to activate it. Native skill flavors are ready for host discovery without
that staging step.

</details>

<details>
<summary>Cursor</summary>

The [official skills guide](https://cursor.com/docs/skills) documents native
selection and **Customize > Skills** discovery. The `cursor` plugin includes
skills, a routing rule, and four agents. The `cursor-global` flavor installs
skills only. Local plugin loading depends on host/account policy.

For this repository's CLI plugin path, use `--plugin-dir` as described in the
[flavor section](../README.md#skills-and-plugins). Native agents are a separate
installation unless you use the plugin.

</details>

<details>
<summary>Gemini CLI</summary>

The [official skills guide](https://geminicli.com/docs/cli/skills/)
documents `/skills reload`, `/skills list`, and model-driven activation with
user approval for skill directory access. Installing the files does not grant
that activation consent. Check discovery after updates in the relevant workspace.

</details>

<details>
<summary>Muse Code</summary>

The [official discovery reference](https://meta-models.github.io/muse-code-sdk/next/guides/extend/skills/)
documents `.agents/skills`, compatible host roots, catalog-based selection, and
`read_skill`. Use `/skills reload` and `muse skills list` to check discovery.
Project skills require workspace trust; the installer does not grant it.
Catalog limits can affect which descriptions are exposed, so inspect the actual
session instead of inferring selection from the files.

</details>

<details>
<summary>OpenCode and OpenChamber</summary>

[OpenCode v2](https://opencode.ai/v2/docs/skills/) advertises permitted skill
descriptions and provides a `skill` tool. Selection is model-mediated. The helper
installs to OpenCode's own global/project roots and does not edit global instructions.

[OpenChamber](https://docs.openchamber.dev/skills/) has an explicit `$` skill
picker. It is a separate client, not another installer flavor. For a connected
OpenCode server, use the server's filesystem and project location. Verify external
installs in that client; its picker alone does not establish automatic skill selection.

</details>

### Other third-party installer targets

The [Open Skills CLI](https://github.com/vercel-labs/skills) supports additional
hosts through its [adapter inventory](https://github.com/vercel-labs/skills/blob/main/docs/agents.md).
That list changes independently and is not copied here. An adapter's destination
is not evidence of host invocation or an additional native flavor in this repository.
Use the target host's current official documentation to verify discovery and activation.

## Specialized subagents

The canonical prompts in `agents/` define four specialists:

| Agent | Responsibility |
| --- | --- |
| `independent-reviewer` | Review an exact candidate against original requirements. |
| `root-cause-investigator` | Investigate failure causes and verification criteria. |
| `dependency-investigator` | Verify dependency versions and integration contracts. |
| `architecture-advisor` | Compare consequential design options before implementation. |

They return findings or advice; they do not implement changes or publish results.
No prompt pins a model. Native agent flavors install definitions only, so install
matching skills separately. Claude and Cursor plugins already include agents.
See [package contents](plugins.md#package-contents) for archive composition.

| Host | Native agent locations | Discovery/invocation | Packaged capability restriction |
| --- | --- | --- | --- |
| Antigravity | `~/.gemini/config/agents`, project `.agents/agents` | `/agents` or planner delegation. | Subagent flags, file/search tools, sandbox command policy. |
| Claude Code | `~/.claude/agents` or `CLAUDE_CONFIG_DIR/agents`, project `.claude/agents` | `@agent-` autocomplete or explicit delegation. | Tool allowlist excludes shell, edit/write, and spawning. |
| Codex | `~/.codex/agents`, project `.codex/agents` | Explicit named-agent request; inspect activity. | Shell and permission-request features disabled; parent sandbox/approvals still apply. |
| Copilot | `~/.copilot/agents`, project `.github/agents` | Agent picker or delegation request; surface support varies. | `read`/`search` tool list. |
| Cursor | `~/.cursor/agents`, project `.cursor/agents` | Subagent tools/delegation view. | `readonly: true`. |
| Gemini CLI | `~/.gemini/agents`, project `.gemini/agents` | `/agents` and `@name`. | Local agent, `read_file` and `grep_search`. |
| OpenCode v2 | `~/.config/opencode/agents`, project `.opencode/agents` | Parent delegation; API registration query. | `mode: subagent`, deny edit/shell/further subagents. |

For OpenCode registration, run in the target project:

```sh
opencode --standalone api get /api/agent
```

A listing proves registration, not a delegated task. New directories can require
a fresh session. For OpenChamber, the connected OpenCode server must see the files.
Muse documents runtime delegation, but this repository offers no static Muse agent
flavor because the reviewed documentation did not establish a persistent format.

Prompt restrictions and host configuration do not necessarily constrain inherited
MCP tools or other external processes. Claude plugin permission mode is not claimed;
Codex custom agents inherit parent permissions and cannot establish their own
read-only sandbox. Check that the actual tool surface allows the required reading
and skill loading without giving the specialist unintended mutation capabilities.

Reviewer/debugger prompts request relevant skills; some formats also support
preloading. Verify the skills resolved, including scoped plugin names. Missing
skills leave a skill-guided workflow incomplete even if the agent is registered.

Official native-agent references:
[Antigravity](https://antigravity.google/docs/subagents?tab=cli),
[Claude Code](https://code.claude.com/docs/en/sub-agents),
[Codex](https://learn.chatgpt.com/docs/agent-configuration/subagents),
[Copilot](https://docs.github.com/en/copilot/concepts/customizations/custom-agents),
[Cursor](https://cursor.com/docs/subagents),
[Gemini CLI](https://geminicli.com/docs/core/subagents/),
[OpenCode](https://opencode.ai/v2/docs/agents/).
The source for installed restrictions is the [agent adapter](../internal/collection/agents.go),
not a guarantee inferred from an agent's name.

## Integration boundaries

Native skill flavors write only selected skill directories; native agent flavors
write only selected agent directories. They do not edit global instructions or
host settings. Plugin flavors retain their host-specific files. The Codex catalog
updater preserves unrelated entries and rejects invalid JSON.

User and repository instruction files remain under their owner's control. Do not
install this repository's `AGENTS.md` elsewhere as generic host instructions.
Source/package/installer checks establish file contracts, not model compliance.

## Behavioral evidence and limits

Keep these evidence levels separate:

| Level | What it establishes | What it does not establish |
| --- | --- | --- |
| Structural validation | Manifest/frontmatter/link and agent-format contracts. | Rendering or model execution. |
| Installer smoke tests | Isolated placement, merge, backup, conflict, and preservation behavior. | A live host loaded the installed files. |
| Host registration | Skills or agents appear in a named host/environment. | Selection, delegation, or instruction following. |
| Observed task | Artifacts and visible activity from one concrete prompt/revision. | Every prompt, host, or model behaves the same way. |

An earlier local OpenCode v2 standalone API check registered all four agents with
edit/shell/subagent denials. That record established registration only. It did not
exercise a model task. Earlier audits did not run authenticated task prompts or
local Windows PowerShell smoke tests; do not reinterpret those audits as live
host verification.

For current run evidence, see the [documentation exercise](documentation-exercise.md).
For a new host check, record version, skill/target revisions, prompt, visible skill
activity, artifacts, results, and limits. Ask for a relevant task without naming
the skill to test implicit selection; explicitly name it to test its workflow.
Use a simple unrelated question to check that a workflow is not forced unnecessarily.

## Implementation map

| Contract | Source |
| --- | --- |
| Actual destinations and activation hints | [Bash installer](../scripts/install-ai-agent-skills.sh), [Windows installer](../scripts/install-ai-agent-skills.ps1) |
| Agent frontmatter/TOML and permissions | [Agent adapter](../internal/collection/agents.go) |
| Archive components | [Collection packager](../internal/collection/collection.go) |
| Structural and installer coverage | [Collection tests](../internal/collection/collection_test.go), [Bash smoke tests](../scripts/tests/install-smoke.sh), [Windows smoke tests](../scripts/tests/install-smoke.ps1) |
