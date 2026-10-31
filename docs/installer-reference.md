# Installer reference

Use the [README's flavor sections](../README.md#native-shell-installer) for complete
install, activation, and update commands for all 35 flavors. This reference covers
options, destinations, conflicts, source builds, and recovery. Run helper commands
from a checkout of this repository.

[Activate](#activate-an-installation) · [Update](#updates-and-customizations) · [Agents](#specialized-agent-installations) · [Options](#options-and-destinations) · [Source/manual](#source-builds-and-manual-installation) · [Recover/remove](#troubleshooting-and-uninstall)

## Prerequisites and checkout

Install the target host and Git. Release installs require:

| Platform | Runtime and tools |
| --- | --- |
| macOS/Linux | Bash, curl, tar, shasum, and jq. Install missing tools with your package manager. |
| Windows | PowerShell 7.4+ (`pwsh`). Release mode uses .NET archive APIs and needs neither Bash nor jq. |

```sh
git clone https://github.com/TylerAkins/ai-agent-skills.git
cd ai-agent-skills
```

In PowerShell, use `Set-Location ai-agent-skills` for the second command.
List the flavors without changing any files:

```sh
bash scripts/install-ai-agent-skills.sh --flavor list
```

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor list
```

Default installation fetches the latest stable published release. It does not
install unpublished content from your checkout. Git is needed for the checkout
and source mode; release extraction itself does not require Go.

## Activate an installation

Use the activation steps in the [matching flavor section](../README.md#skills-and-plugins).
Native skills normally require discovery in the appropriate session or workspace.
Plugin files may also require app activation or refreshing a cached plugin.

A list entry proves discovery. Confirm execution by making a relevant request,
checking visible skill/tool activity, and assessing the result. Agent registration,
delegation, and skill use are separate checks. The helper does not authenticate
Jira/GitHub, publish a marketplace, or edit global instruction files.

See [host compatibility](host-compatibility.md) for surface-specific discovery.

## Updates and customizations

1. In the installer checkout, run `git pull --ff-only` to get installer fixes.
2. Compare locally customized skills or agents with incoming versions.
3. Run the update command from the original flavor section, retaining the same project or marketplace root.
4. Review the reported backup location, repeat activation, and verify the new session uses the intended copy.

| Mode | Existing destination behavior |
| --- | --- |
| Ordinary install | Refuses an existing directory without an explicit merge/replace choice. |
| Plugin update | Defaults to replacing the selected plugin directory and backing it up. |
| Skills/agents merge | Preserves unrelated names; replaces incoming skill folders or agent files and backs up the old directory. |
| Replace | Replaces the entire selected directory and backs up the previous contents. |

Skills-only and agents-only updates still require `--merge` / `-Merge` or an
explicit replace decision. Merge also works for first installs into a shared
skills directory. It does not merge edits inside a same-named skill or agent.
Do not use whole-directory replacement where unrelated content must survive.

Existing destinations prompt for confirmation. `--yes` / `-Yes` confirms the
selected operation in noninteractive scripts; it does not choose merge for you.
Backups are stored under `.ai-agent-skills-backups` relative to the destination's
parent hierarchy, and the installer prints the exact path. Preserve that output
when you may need recovery.

Global `codex-global` and `muse-global` share `.agents/skills`. Project Codex,
Muse, and Antigravity flavors also share `.agents/skills`. A second flavor targeting
an occupied shared directory needs an explicit merge decision, not a second
ordinary install.

## Specialized agent installations

The four agents are `independent-reviewer`, `root-cause-investigator`,
`dependency-investigator`, and `architecture-advisor`. Use one of the 14
[agent flavors](../README.md#optional-subagents) alongside the matching skills.
Claude and Cursor plugins already contain agents; the desktop portable plugin
and Open Skills CLI installs do not.

Agent flavors touch only the selected `agents` directory. They do not install
skills or change primary-agent configuration. Each update replaces the four
incoming names; preserve local edits before merging. Older releases without the
required agent archive cannot supply these flavors.

Use [host discovery and capability limits](host-compatibility.md#specialized-subagents)
to verify registration and actual delegation. For remote clients, definitions
must exist on the server filesystem where the agent runtime runs.

## Options and destinations

| Operation | Bash | PowerShell |
| --- | --- | --- |
| Choose flavor | `--flavor NAME` | `-Flavor NAME` |
| Update | `update` before the flags | `-Action Update` |
| Pin published release | `--version vMAJOR.MINOR.PATCH` | `-Version vMAJOR.MINOR.PATCH` |
| Build remote source | `--from-source` | `-FromSource` |
| Choose source ref | `--ref main` or release tag | `-Ref main` or release tag |
| Existing project | `--project PATH` | `-Project PATH` |
| Separate marketplace | `--marketplace-root PATH` | `-MarketplaceRoot PATH` |
| Merge skills/agents | `--merge` | `-Merge` |
| Replace directory | `--replace` | `-Replace` |
| Confirm chosen mode | `--yes` | `-Yes` |
| Preview without writes | `--dry-run` | `-DryRun` |
| Help | `--help` or `-h` | `-?` |

Merge and replace are mutually exclusive. Source ref requires source mode and
accepts `main` or a version tag. If version and ref are both set, they must agree.
Project paths must exist and be absolute; marketplace roots must be absolute.
Symlink destinations and parents are rejected, as are Windows junctions.

PowerShell also accepts `-HomeDirectory` for isolated staging. Hosts do not
automatically discover that alternate profile. Bash uses its `HOME` environment.
Dry runs resolve and validate destinations without downloads or writes; occupied
targets still require the proper merge/replace decision.

For example, preview an update to a native skill installation:

```sh
bash scripts/install-ai-agent-skills.sh update --flavor opencode-global --merge --dry-run
```

```powershell
./scripts/install-ai-agent-skills.ps1 -Action Update -Flavor opencode-global -Merge -DryRun
```

### Destination inventory

`~` means the current user profile, `$PROJECT` is the selected project, and
`$ROOT` is the chosen marketplace root. These are destination labels, not commands.

| Flavor | Destination |
| --- | --- |
| `antigravity-agents-global` | `~/.gemini/config/agents` |
| `antigravity-agents-project` | `$PROJECT/.agents/agents` |
| `antigravity-cli-global` | `~/.gemini/antigravity-cli/skills` |
| `antigravity-global` | `~/.gemini/config/skills` |
| `antigravity-project` | `$PROJECT/.agents/skills` |
| `claude` | `~/.local/share/ai-agent-skills/claude` |
| `claude-agents-global` | `~/.claude/agents` |
| `claude-agents-project` | `$PROJECT/.claude/agents` |
| `claude-global` | `~/.claude/skills` |
| `claude-project` | `$PROJECT/.claude/skills` |
| `codex-agents-global` | `~/.codex/agents` |
| `codex-agents-project` | `$PROJECT/.codex/agents` |
| `codex-desktop` | `~/.codex/plugins/ai-agent-skills` |
| `codex-global` | `~/.agents/skills` |
| `codex-marketplace` | `$ROOT/plugins/ai-agent-skills` |
| `codex-skills` | `$PROJECT/.agents/skills` |
| `copilot-agents-global` | `~/.copilot/agents` |
| `copilot-agents-project` | `$PROJECT/.github/agents` |
| `copilot-global` | `~/.copilot/skills` |
| `copilot-skills` | `$PROJECT/.github/skills` |
| `copilot-staging` | `~/.local/share/ai-agent-skills/copilot` |
| `cursor` | `~/.cursor/plugins/local/ai-agent-skills` |
| `cursor-agents-global` | `~/.cursor/agents` |
| `cursor-agents-project` | `$PROJECT/.cursor/agents` |
| `cursor-global` | `~/.cursor/skills` |
| `gemini-agents-global` | `~/.gemini/agents` |
| `gemini-agents-project` | `$PROJECT/.gemini/agents` |
| `gemini-global` | `~/.gemini/skills` |
| `gemini-project` | `$PROJECT/.gemini/skills` |
| `muse-global` | `~/.agents/skills` |
| `muse-project` | `$PROJECT/.agents/skills` |
| `opencode-agents-global` | `~/.config/opencode/agents` |
| `opencode-agents-project` | `$PROJECT/.opencode/agents` |
| `opencode-global` | `~/.config/opencode/skills` |
| `opencode-project` | `$PROJECT/.opencode/skills` |

Claude global skills and agents use an absolute `CLAUDE_CONFIG_DIR` when set.
Codex desktop writes a personal catalog at `~/.agents/plugins/marketplace.json`;
a separate marketplace writes `$ROOT/.agents/plugins/marketplace.json`.
The updater preserves unrelated catalog entries and refuses invalid existing JSON.
Neither flavor registers a CLI marketplace or edits Codex configuration.

## Source builds and manual installation

Source mode requires Git and stable Go 1.27.1 or newer. It clones a remote release
tag into a temporary directory and builds that revision. Select `main` explicitly
to build remote main. Automatic Go toolchain downloads are disabled.

```sh
bash scripts/install-ai-agent-skills.sh --flavor opencode-global --from-source --ref main
```

```powershell
./scripts/install-ai-agent-skills.ps1 -Flavor opencode-global -FromSource -Ref main
```

For an existing destination, use the same update and merge controls as release
mode. These commands do not build unpublished changes in the current checkout.
For those changes, build a package locally with the [packager](plugins.md#validate-and-build),
or copy the complete `skills/` contents into a supported native directory:

| Host | Project skills directory |
| --- | --- |
| Antigravity, Codex, Muse Code | `.agents/skills/` |
| Claude Code | `.claude/skills/` |
| GitHub Copilot | `.github/skills/` |
| Cursor | `.cursor/skills/` |
| Gemini CLI | `.gemini/skills/` |
| OpenCode | `.opencode/skills/` |

Keep sibling skills and all supporting resources together. Compare same-named
folders before replacing them, preserve unrelated files, and repeat discovery
checks. Manual copies use checkout content and need explicit copying again to
update. They do not install plugin rules, native agents, or repository instructions.
Do not copy this repository's `AGENTS.md` into another project as generic setup.

## Troubleshooting and uninstall

| Symptom | Next action |
| --- | --- |
| Destination exists | Inspect its contents; choose merge for skills/agents or deliberate plugin replacement. |
| An update loses local edits | Compare with the printed backup. Merge replaces incoming names, including customized contents. |
| Old skills remain active | Check duplicate sources, refresh/reinstall the cached plugin, and start a new session. |
| Plugin absent | Follow activation for that flavor and check account/team policy. |
| Download/checksum/archive error | Stop and inspect the selected release assets. Use a known published tag; do not bypass checks. |
| Invalid marketplace JSON | Repair or restore the catalog before retrying. |
| Windows script blocked | Use PowerShell 7.4+ and follow device policy; the installer does not change execution policy. |
| Missing runtime/tool | Install the prerequisite listed above, then retry. |

Downloads verify the selected archive and `SOURCE_COMMIT` against release
`SHA256SUMS`. Checksum data comes from the same release source, not signed
provenance. Unsafe archive paths and unsupported entry types are rejected.

For rollback, stop the affected host, inspect the printed backup and current
contents, and restore only the selected installation. Preserve newer unrelated
files in shared destinations. For a marketplace install, also reconcile its
catalog entry with the restored plugin.

To uninstall, disable/uninstall the host plugin first, then remove only its
installation. Remove only this collection's skill folders or four agent files
from shared directories. For Codex marketplaces, remove only `ai-agent-skills`
from the catalog and preserve other entries. Keep backups until recovery is no
longer needed.

## Implementation map

| Contract | Source |
| --- | --- |
| Bash flavors, paths, arguments, and activation messages | [Bash installer](../scripts/install-ai-agent-skills.sh) |
| Windows flavors, paths, archive checks, and transaction | [PowerShell installer](../scripts/install-ai-agent-skills.ps1) |
| Release selection, checksum checks, merge, backup, and catalog handling | [Bash library](../scripts/lib/install.sh) |
| Isolated installation/update cases | [Bash smoke tests](../scripts/tests/install-smoke.sh), [Windows smoke tests](../scripts/tests/install-smoke.ps1) |
| Published asset names | [Release workflow](../.github/workflows/release.yml) |
