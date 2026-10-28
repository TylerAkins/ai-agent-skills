# Host Skill Compatibility

Skill inventory and subagent formats reviewed against official host documentation
on October 28, 2026. This inventory covers the hosts and
installation surfaces documented by this repository. Host
documentation establishes discovery and invocation mechanisms, not that a model
will always select or follow a skill.

Use the [installer reference](installer-reference.md) for commands and destinations.
This guide covers host discovery, selection behavior, optional agents, and the
limits of the compatibility evidence.

## Inventory and compatibility

| Host | Compatibility details |
| --- | --- |
| [Cursor IDE and CLI](https://cursor.com/docs/skills) | **Native skill discovery:** Project `.agents/skills`, `.cursor/skills`, `.claude/skills`, and `.codex/skills`; matching user directories under `~`.<br>**Automatic selection:** Yes. Cursor presents available skills and the agent selects based on context. CLI supports skills and the rules system.<br>**Persistent global instructions:** Cursor user rules in Customize; CLI also reads `AGENTS.md` and `CLAUDE.md`.<br>**Existing integration:** Cursor plugin bundle with skills, an always-on routing rule, and four investigation agents. Cursor CLI loads local plugins via `--plugin-dir` or its local-plugin settings.<br>**Verified gaps:** The plugin rule previously routed every covered task through `using-skills`. The native global skill path was not offered by the shell installers; `cursor-global` now provides it without plugin activation. |
| [Codex CLI, IDE extension, and ChatGPT desktop app](https://developers.openai.com/codex/skills/) | **Native skill discovery:** Project `.agents/skills` and user `~/.agents/skills`, plus plugin skills.<br>**Automatic selection:** Yes. Codex can implicitly invoke skills when the task matches their descriptions.<br>**Persistent global instructions:** `~/.codex/AGENTS.md`.<br>**Existing integration:** Native skills and agent installs, plus a portable plugin with a local marketplace for ChatGPT desktop activation.<br>**Verified gaps:** The desktop plugin still requires user activation in the app; the installer does not register a CLI marketplace. Native agents are installed separately. |
| [Claude Code CLI and IDE extension](https://code.claude.com/docs/en/skills) | **Native skill discovery:** Project `.claude/skills` and user `~/.claude/skills`, or paths under `CLAUDE_CONFIG_DIR`, plus plugin skills.<br>**Automatic selection:** Yes. Claude can load a skill automatically when relevant to its description.<br>**Persistent global instructions:** `~/.claude/CLAUDE.md`, relocated under `CLAUDE_CONFIG_DIR` when set.<br>**Existing integration:** Claude plugin with four agents, or persistent native agent and skill installs.<br>**Verified gaps:** Plugin loading with `--plugin-dir` lasts one session. Direct installation shadows Claude's bundled `/code-review` skill, while `/review` remains an alias. |
| [GitHub Copilot app, CLI, IDEs, cloud agent, and code review](https://docs.github.com/en/copilot/concepts/customizations/agent-skills) | **Native skill discovery:** Project `.github/skills`, `.claude/skills`, or `.agents/skills`; personal `~/.copilot/skills` or `~/.agents/skills`. Surface support varies.<br>**Automatic selection:** Yes. Copilot decides from the request and skill description.<br>**Persistent global instructions:** The CLI supports `~/.copilot/copilot-instructions.md`; repository instructions are available on supported surfaces. Personal local skills and instructions do not automatically become cloud-agent resources.<br>**Existing integration:** Project and personal skills; optional portable plugin staging only.<br>**Verified gaps:** Cloud use requires repository-hosted skills. The installer does not create a Copilot plugin marketplace, and staged plugin files alone do not activate a plugin. |
| [OpenCode CLI, desktop, and IDE integrations](https://opencode.ai/v2/docs/skills/) | **Native skill discovery:** Project `.opencode/skills`, `.agents/skills`, and `.claude/skills`; global `~/.config/opencode/skills`, `~/.agents/skills`, and `~/.claude/skills`.<br>**Automatic selection:** Model-mediated. OpenCode advertises permitted skill descriptions at model steps and exposes a `skill` tool to load a selected skill.<br>**Persistent global instructions:** `~/.config/opencode/AGENTS.md`.<br>**Existing integration:** Separate project and global skill and agent installs.<br>**Verified gaps:** No host-level guarantee that the model calls the skill tool. The installer intentionally does not edit global instructions. |
| [Gemini CLI](https://geminicli.com/docs/cli/skills) | **Native skill discovery:** Project `.gemini/skills` or `.agents/skills`; user `~/.gemini/skills` or `~/.agents/skills`.<br>**Automatic selection:** Yes. The model can activate a matching skill through `activate_skill`; the CLI asks the user to approve access to its directory.<br>**Persistent global instructions:** `GEMINI.md`, including user-level context.<br>**Existing integration:** Project and global skills-only installs.<br>**Verified gaps:** Skill activation includes a consent step. Google documents a migration path to Antigravity CLI for some Gemini CLI users, so users should follow the surface-specific current path. |
| [Muse Code CLI](https://meta-models.github.io/muse-code-sdk/next/guides/extend/skills) | **Native skill discovery:** User `$CONFIG_DIR/skills` (`$XDG_CONFIG_HOME/muse/skills` when set, otherwise `~/.config/muse/skills`), `~/.agents/skills`, and compatible Claude/Codex roots; project `.agents/skills`, `.claude/skills`, and `.codex/skills`. Project skills require workspace trust.<br>**Automatic selection:** Model-mediated. Muse sends skill descriptions in its startup catalog; the model can load a matching skill with `read_skill` or the user can invoke it by name.<br>**Persistent global instructions:** The cited skill reference does not establish a separate persistent global instruction file.<br>**Existing integration:** Project and global `.agents/skills` installs.<br>**Verified gaps:** Project skills are unavailable in untrusted workspaces. Muse Code 1.3.0 documents a 24,000-byte shared catalog budget and description compression; actual selection remains model-dependent. |
| [Antigravity app and standalone IDE](https://antigravity.google/docs/skills) | **Native skill discovery:** Project `.agents/skills` (legacy `.agent/skills`); global `~/.gemini/config/skills`. The standalone IDE also accepts legacy `~/.gemini/antigravity/skills`.<br>**Automatic selection:** Yes. The agent reads relevant skills automatically based on the prompt.<br>**Persistent global instructions:** Global rules are supported.<br>**Existing integration:** Project and app/IDE global skills-only installs.<br>**Verified gaps:** None in the documented path or package. Invocation is still an agent decision, not an installer guarantee. |
| [Antigravity CLI](https://antigravity.google/docs/skills) | **Native skill discovery:** Project `.agents/skills`; global `~/.gemini/antigravity-cli/skills`.<br>**Automatic selection:** Yes. The CLI sees skill descriptions and automatically reads a skill it judges relevant.<br>**Persistent global instructions:** Global `~/.gemini/GEMINI.md`.<br>**Existing integration:** Project and CLI-specific global skills-only installs.<br>**Verified gaps:** The app/IDE and CLI global directories differ; using the wrong flavor leaves files undiscovered by that surface. |
| Other [Vercel Skills CLI targets](https://github.com/vercel-labs/skills/blob/main/docs/agents.md) | **Native skill discovery:** The external adapter writes to its listed host path; location and surface vary.<br>**Automatic selection:** Unknown for each product unless covered above.<br>**Persistent global instructions:** Not configured by this repository or the Vercel installer.<br>**Existing integration:** Optional third-party installation path only.<br>**Verified gaps:** Host documentation, client differences, and automatic invocation were not audited individually; see the target list below. |
| [OpenChamber](https://docs.openchamber.dev/skills) | **Native skill discovery:** Skills are managed in Settings > Skills, with personal and project scopes.<br>**Selection:** The documented use is explicit: type `$` and choose a skill to attach it to the chat. The docs do not establish automatic selection.<br>**Existing integration:** No OpenChamber-specific package. Skills created or installed in OpenChamber can be selected in its chat.<br>**Verified gaps:** The docs do not establish that files installed by this repository’s external installer are visible in OpenChamber. |
### Distribution mechanisms

The canonical content remains `skills/<name>/SKILL.md` and supporting files.
The release workflow prepares these archives. The current published release is
[v1.1.0](https://github.com/TylerAkins/ai-agent-skills/releases/tag/v1.1.0); older
releases may not contain the agent bundles described here:

| Release archive | Hosts | Package components |
| --- | --- | --- |
| `cursor` | Cursor | Canonical skills, Cursor plugin manifest, routing rule, four agents, license |
| `claude` | Claude Code | Canonical skills, Claude plugin manifest, four agents, license |
| `portable` | Codex and Copilot | Canonical skills, portable plugin manifest, license |
| `skills` | OpenCode, Gemini CLI, Muse Code, Antigravity | Canonical skills and license, without a plugin manifest |
| `opencode` | OpenCode native agents | Canonical skills, OpenCode Markdown agents, license |
| `codex` | Codex native agents | Canonical skills, Codex TOML agents, portable plugin manifest, license |

The native shell installers provide 27 flavors across eight host families. The
six agent-only flavors install to native global or project agent directories;
they do not install skills. `codex-global` and `muse-global` share
`~/.agents/skills`. Project `.agents/skills` is also recognized by multiple
compatible hosts. See the [full flavor list](installer-reference.md#options-and-destinations).

## Specialized subagents

The four canonical prompts in `agents/` are the Cursor and Claude plugin agents.
The packager generates OpenCode v2 Markdown and Codex TOML from those prompts.
No agent pins a model. They are subagents, not default primary agents. Install
the relevant skills separately for native agent-only flavors. The `skills` archive
remains skills-only for the other hosts. OpenCode agent-only flavors use the new
`opencode` archive rather than the shared `skills` archive. Codex agent-only
flavors use the `codex` archive rather than the shared `portable` archive.
Claude uses the Claude archive. Releases without the four agent definitions
cannot install the agent flavors.

| Host | Agent behavior and limits |
| --- | --- |
| [OpenCode v2](https://opencode.ai/v2/docs/agents/) | **Discovery and invocation:** Global/project `agents/*.md`, with `mode: subagent`; ask the parent to launch one through its subagent tool, or let the model choose when allowed. `opencode --standalone api get /api/agent` lists registered agents in the current location.<br>**Skill loading:** Prompt explicitly requests the `skill` tool for required skills and dependencies. The agent reports unavailable skills.<br>**Read-only boundary:** Agent rules deny `edit`, `shell`, and further `subagent` calls. Other externally configured tools or parent instructions may require separate controls; restricting shell also prevents local command-based reproduction. |
| [Claude Code](https://code.claude.com/docs/en/sub-agents) | **Discovery and invocation:** Global/project `agents/*.md` or plugin `agents/`; ask Claude to use a named subagent or select one from `@agent-` autocomplete. A newly created agents directory may require a session restart.<br>**Skill loading:** Reviewer and debugger request preloading of named skills through `skills`; verify they resolved. Advisor and dependency investigator load applicable skills using the Skill tool. Plugin skills may have scoped names.<br>**Read-only boundary:** `tools` allowlist excludes shell, edit, write, and agent-spawn tools. Plugin subagents ignore `permissionMode`; no permission mode is claimed. Other inherited configuration and external tools must be assessed separately. |
| [Codex](https://developers.openai.com/codex/agent-configuration/subagents) | **Discovery and invocation:** Global/project `.codex/agents/*.toml`; explicitly request a named agent. Agent activity appears in the client. Automatic delegation also depends on instructions and model behavior.<br>**Skill loading:** `developer_instructions` asks agents to load relevant skills and report missing dependencies. No Codex custom-agent skill preloading is assumed.<br>**Read-only boundary:** `features.shell_tool = false` and `features.request_permissions_tool = false` narrow capabilities, but custom agents inherit the parent's sandbox and approvals. The prompt cannot enforce a separate read-only sandbox; verify another read-only inspection tool is available before delegating. |
| [OpenChamber](https://docs.openchamber.dev/providers/) | **Discovery and invocation:** Uses the connected OpenCode server's agents. Project/global definitions must be visible on that server's filesystem, not just the OpenChamber client.<br>**Skill loading:** Uses the server's OpenCode skill discovery. OpenChamber's `$` picker attaches a skill explicitly; automatic skill use remains model-mediated.<br>**Read-only boundary:** Uses the OpenCode agent rules and the server's effective permissions. OpenChamber's own permission controls do not turn a Codex agent into an OpenCode agent. |

All four return findings or advice to the caller, never changes or published
results. A prompt restriction does not constrain unlisted third-party MCP tools
or external processes. Explicit invocation is a request to the host, not proof
of execution; inspect the delegation trace. Missing skills invalidate claims of
a complete skill-guided workflow, even if an agent is registered.

For troubleshooting, verify the agent file, the matching skill folder, and the
server's location first. Then list agents in OpenCode, check Claude's `@agent-`
autocomplete or Codex's agent activity, and start a new session if the host has cached a newly
created directory. An installed file proves placement only. Structural parser
and installer tests do not prove a model delegated, loaded skills, or respected
instructions. See [agent install and update paths](installer-reference.md#specialized-agent-installations).

The README also offers the third-party [Open Skills CLI](https://github.com/vercel-labs/skills),
which can install into many additional agent-specific locations. Its supported-agent
list and behavior belong to that external tool and change independently. Using it
does not add routing instructions to those agents.

The upstream [supported agents table](https://github.com/vercel-labs/skills/blob/main/docs/agents.md),
checked on the review date above, also lists these targets. Names already covered in
the matrix inherit that row only for their documented native behavior; the remaining
products have not had their own official skill-invocation documentation reviewed in
this audit. For those targets, discovery, automatic selection, global instructions,
and surface differences remain unknown. The Vercel adapter path is not evidence of
automatic invocation.

<details>
<summary><strong>External installer targets not maintained by this repository</strong></summary>

The paths below are owned by the external adapter. Entries that also appear in the
main matrix are listed here to make the adapter inventory complete. Path differences
are not overrides of the host's official documentation.

| Agent | `--agent` | Project path | Global path |
| --- | --- | --- | --- |
| AiderDesk | `aider-desk` | `.aider-desk/skills/` | `~/.aider-desk/skills/` |
| Amp, Replit, Universal | `amp`, `replit`, `universal` | `.agents/skills/` | `~/.config/agents/skills/` |
| Antigravity | `antigravity` | `.agents/skills/` | `~/.gemini/antigravity/skills/` |
| Antigravity CLI | `antigravity-cli` | `.agents/skills/` | `~/.gemini/antigravity-cli/skills/` |
| AstrBot | `astrbot` | `data/skills/` | `~/.astrbot/data/skills/` |
| Autohand Code CLI | `autohand-code` | `.autohand/skills/` | `~/.autohand/skills/` |
| Augment | `augment` | `.augment/skills/` | `~/.augment/skills/` |
| IBM Bob | `bob` | `.bob/skills/` | `~/.bob/skills/` |
| Claude Code | `claude-code` | `.claude/skills/` | `~/.claude/skills/` |
| OpenClaw | `openclaw` | `skills/` | `~/.openclaw/skills/` |
| Cline, Codex, Dexto, fx, Kimi Code CLI, Loaf, Pi, Sarvam Code, Warp, Zed | `cline`, `codex`, `dexto`, `fx`, `kimi-code-cli`, `loaf`, `pi`, `sarvam-code`, `warp`, `zed` | `.agents/skills/` | `~/.agents/skills/` |
| CodeArts Agent | `codearts-agent` | `.codeartsdoer/skills/` | `~/.codeartsdoer/skills/` |
| CodeBuddy | `codebuddy` | `.codebuddy/skills/` | `~/.codebuddy/skills/` |
| Codemaker | `codemaker` | `.codemaker/skills/` | `~/.codemaker/skills/` |
| Code Studio | `codestudio` | `.codestudio/skills/` | `~/.codestudio/skills/` |
| Command Code | `command-code` | `.commandcode/skills/` | `~/.commandcode/skills/` |
| Continue | `continue` | `.continue/skills/` | `~/.continue/skills/` |
| Cortex Code | `cortex` | `.cortex/skills/` | `~/.snowflake/cortex/skills/` |
| Crush | `crush` | `.crush/skills/` | `~/.config/crush/skills/` |
| Cursor | `cursor` | `.agents/skills/` | `~/.cursor/skills/` |
| Deep Agents | `deepagents` | `.agents/skills/` | `~/.deepagents/agent/skills/` |
| Devin for Terminal | `devin` | `.devin/skills/` | `~/.config/devin/skills/` |
| Droid | `droid` | `.agents/skills/` | `~/.factory/skills/` |
| Eve | `eve` | `agent/skills/` | Project-only |
| Firebender | `firebender` | `.agents/skills/` | `~/.firebender/skills/` |
| ForgeCode | `forgecode` | `.forge/skills/` | `~/.forge/skills/` |
| Gemini CLI | `gemini-cli` | `.agents/skills/` | `~/.gemini/skills/` |
| GitHub Copilot | `github-copilot` | `.agents/skills/` | `~/.copilot/skills/` |
| Goose | `goose` | `.goose/skills/` | `~/.config/goose/skills/` |
| Grok Build | `grok` | `.grok/skills/` | `~/.grok/skills/` |
| Hermes Agent | `hermes-agent` | `.hermes/skills/` | `~/.hermes/skills/` |
| inference.sh | `inference-sh` | `.inferencesh/skills/` | `~/.inferencesh/skills/` |
| Jazz | `jazz` | `.jazz/skills/` | `~/.jazz/skills/` |
| Junie | `junie` | `.junie/skills/` | `~/.junie/skills/` |
| iFlow CLI | `iflow-cli` | `.iflow/skills/` | `~/.iflow/skills/` |
| Kilo Code | `kilo` | `.agents/skills/` | `~/.kilo/skills/` |
| Kimchi | `kimchi` | `.kimchi/skills/` | `~/.config/kimchi/harness/skills/` |
| Kiro CLI | `kiro-cli` | `.kiro/skills/` | `~/.kiro/skills/` |
| Kode | `kode` | `.kode/skills/` | `~/.kode/skills/` |
| Lingma | `lingma` | `.lingma/skills/` | `~/.lingma/skills/` |
| MCPJam | `mcpjam` | `.mcpjam/skills/` | `~/.mcpjam/skills/` |
| MiniMax Code | `minimax-code` | `.minimax/skills/` | `~/.minimax/skills/` |
| Mistral Vibe | `mistral-vibe` | `.vibe/skills/` | `~/.vibe/skills/` |
| Moxby | `moxby` | `.moxby/skills/` | `~/.moxby/skills/` |
| Mux | `mux` | `.mux/skills/` | `~/.mux/skills/` |
| OpenCode | `opencode` | `.agents/skills/` | `~/.config/opencode/skills/` |
| OpenHands | `openhands` | `.openhands/skills/` | `~/.openhands/skills/` |
| Ona | `ona` | `.ona/skills/` | `~/.ona/skills/` |
| Posit Assistant | `posit-assistant` | `.posit/assistant/skills/` | `~/.posit/assistant/skills/` |
| Qoder | `qoder` | `.qoder/skills/` | `~/.qoder/skills/` |
| Qoder CN | `qoder-cn` | `.qoder/skills/` | `~/.qoder-cn/skills/` |
| Qwen Code | `qwen-code` | `.qwen/skills/` | `~/.qwen/skills/` |
| Reasonix | `reasonix` | `.reasonix/skills/` | `~/.reasonix/skills/` |
| Rovo Dev | `rovodev` | `.rovodev/skills/` | `~/.rovodev/skills/` |
| Roo Code | `roo` | `.roo/skills/` | `~/.roo/skills/` |
| Tabnine CLI | `tabnine-cli` | `.tabnine/agent/skills/` | `~/.tabnine/agent/skills/` |
| Terramind | `terramind` | `.terramind/skills/` | `~/.terramind/skills/` |
| Tinycloud | `tinycloud` | `.tinycloud/skills/` | `~/.tinycloud/skills/` |
| Trae | `trae` | `.trae/skills/` | `~/.trae/skills/` |
| Trae CN | `trae-cn` | `.trae/skills/` | `~/.trae-cn/skills/` |
| Windsurf | `windsurf` | `.windsurf/skills/` | `~/.codeium/windsurf/skills/` |
| ZCode | `zcode` | `.zcode/skills/` | `~/.zcode/skills/` |
| Zencoder, Zenflow | `zencoder`, `zenflow` | `.zencoder/skills/` | `~/.zencoder/skills/` |
| Neovate | `neovate` | `.neovate/skills/` | `~/.neovate/skills/` |
| Pochi | `pochi` | `.pochi/skills/` | `~/.pochi/skills/` |
| PromptScript | `promptscript` | `.agents/skills/` | Project-only |
| AdaL | `adal` | `.adal/skills/` | `~/.adal/skills/` |

</details>

The Vercel Antigravity adapter's app target is `~/.gemini/antigravity/skills`.
Google documents `~/.gemini/config/skills` for the Antigravity app and IDE, while
the IDE accepts the adapter path as a legacy location. The native `antigravity-global`
flavor targets the documented app/IDE path; use `antigravity-cli-global` for the CLI.

## Integration boundaries

The collection provides host packages and native skill or agent files. Host
documentation describes discovery and invocation, but selection and instruction
following remain model behavior. The installer does not promise that a host will
load or follow a skill.

Native skill flavors write only to their documented skill directory. They do not
edit global instruction files or host settings. Plugin flavors retain their
host-specific behavior; the Codex local marketplace updater preserves unrelated
marketplace entries and instruction files. The Claude native global flavors honor
`CLAUDE_CONFIG_DIR` when set. See the [installer reference](installer-reference.md)
for exact destinations and the [packaging reference](plugins.md) for package
contents.

## Behavioral evidence and limits

Structural package and installer tests verify manifests, paths, skill content,
agent YAML/TOML parsing, merging, backups, marketplace preservation, and
user-instruction-file preservation. In an isolated project, a local OpenCode v2
`--standalone` API request registered all four packaged agents as subagents with
edit/shell/subagent denials. This establishes OpenCode registration, not a
model's delegation or skill use.

No actual task prompts were run during the earlier skill-selection audit or
this agent-registration check. Cursor CLI, Codex CLI, and
OpenCode executables were present, but delegation tests would require an authenticated
model request. No paid model API was invoked. Claude Code, Copilot, Gemini CLI,
Antigravity, and Muse executables were unavailable in this environment. OpenChamber
was not run. These integrations have structural or documentation evidence only.
PowerShell smoke tests were authored but not run locally because `pwsh` was
unavailable; Windows CI must run them before claiming Windows behavior.

| Prompt | Expected skill | Observed result |
| --- | --- | --- |
| “Review my branch against main.” | `code-review` | Not run |
| “Find and fix why this function fails.” | `root-cause-debug` | Not run |
| “Plan the implementation of this feature.” | `agent-planning` | Not run |
| “Implement the accepted plan.” | `implement-plan` | Not run |
| “Optimize this slow SQL query.” | `writing-optimized-sql` | Not run |
| “Write regression tests for this behavior.” | `test-authoring` | Not run |
| “Explain how this subsystem works.” | `explain-it` | Not run |
| “What is 17 times 29?” | No skill | Not run |

No multi-model comparison was performed.

To check activation without naming a skill, ask for a task such as “Review my branch
against main” or “Write regression tests for this behavior.” Inspect the host's
visible skill/tool activity or skill panel, then verify the workflow's instructions
were followed. A skills list, successful install, or slash-command entry proves
discovery only.

## Official references

- [Cursor skills and CLI](https://cursor.com/docs/skills), [CLI use](https://cursor.com/docs/cli/using), [CLI plugin parameters](https://cursor.com/docs/cli/reference/parameters), [CLI plugin changelog](https://cursor.com/docs/cli/changelog)
- [Codex skills](https://developers.openai.com/codex/skills/), [global instructions](https://developers.openai.com/codex/guides/agents-md)
- [Claude Code skills](https://code.claude.com/docs/en/skills), [plugin loading](https://code.claude.com/docs/en/plugins/loading), [config directory](https://code.claude.com/docs/en/claude-directory), [environment variables](https://code.claude.com/docs/en/env-vars)
- [Copilot skills](https://docs.github.com/en/copilot/concepts/customizations/agent-skills), [Copilot CLI instructions](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions)
- [OpenCode skills](https://opencode.ai/v2/docs/skills/), [OpenCode instructions](https://opencode.ai/v2/docs/instructions/)
- [Gemini CLI skills](https://geminicli.com/docs/cli/skills), [Gemini CLI context](https://geminicli.com/docs/cli/gemini-md/)
- [Antigravity skills](https://antigravity.google/docs/skills), [Antigravity CLI features](https://antigravity.google/docs/cli/features)
- [Muse Code skills](https://meta-models.github.io/muse-code-sdk/next/guides/extend/skills)
- [OpenChamber skills](https://docs.openchamber.dev/skills)
- [OpenCode v2 agents](https://opencode.ai/v2/docs/agents/), [OpenCode API](https://opencode.ai/v2/docs/api)
- [Claude Code subagents](https://code.claude.com/docs/en/sub-agents), [Codex subagents](https://developers.openai.com/codex/agent-configuration/subagents)
