#!/usr/bin/env bash
# macOS/Linux installer: release bundles by default; Go is needed only with --from-source.
# Windows uses install-ai-agent-skills.ps1 with the same release contracts.
set -euo pipefail
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck source=scripts/lib/install.sh
source "$script_dir/lib/install.sh"

action=install
flavor=
version=
source_mode=false
ref=
project=
marketplace_root=
mode=
yes=false
dry_run=false
if [ "${1:-}" = install ] || [ "${1:-}" = update ]; then action=$1; shift; fi
while [ "$#" -gt 0 ]; do
  case "$1" in
    --flavor|--version|--project|--marketplace-root|--ref)
      if [ "$#" -lt 2 ]; then fail "$1 needs a value."; fi
      if [ -z "$2" ]; then fail "$1 needs a value."; fi
      case "$1" in
        --flavor) flavor=$2 ;; --version) version=$2 ;; --project) project=$2 ;;
        --marketplace-root) marketplace_root=$2 ;; --ref) ref=$2 ;;
      esac
      shift 2 ;;
    --from-source) source_mode=true; shift ;;
    --replace|--merge)
      [ -z "$mode" ] || fail "Choose only one of --replace and --merge."
      mode=${1#--}; shift ;;
    --yes) yes=true; shift ;;
    --dry-run) dry_run=true; shift ;;
    --help|-h) usage; exit 0 ;;
    *) fail "Unknown option: $1. Use --help." ;;
  esac
done
if [ "$flavor" = list ]; then usage; exit 0; fi
if [ -z "$flavor" ]; then
  usage
  [ -t 0 ] || fail "Choose a flavor with --flavor."
  printf '\nFlavor: '
  read -r flavor
fi
skills_only=false
agents_only=false
agent_format=
catalog=
source_path=
case "$flavor" in
  cursor) host=cursor; destination="$HOME/.cursor/plugins/local/ai-agent-skills" ;;
  cursor-global) skills_only=true; host=cursor; destination="$HOME/.cursor/skills" ;;
  codex-desktop)
    host=codex; destination="$HOME/.codex/plugins/ai-agent-skills"
    catalog="$HOME/.agents/plugins/marketplace.json"
    source_path="./.codex/plugins/ai-agent-skills" ;;
  codex-marketplace)
    [ -n "$marketplace_root" ] || fail "Use --marketplace-root with a full directory path."
    require_absolute "$marketplace_root"
    host=codex; destination="$marketplace_root/plugins/ai-agent-skills"
    catalog="$marketplace_root/.agents/plugins/marketplace.json"
    source_path="./plugins/ai-agent-skills" ;;
  codex-global) skills_only=true; host=codex; destination="$HOME/.agents/skills" ;;
  claude) host=claude; destination="$HOME/.local/share/ai-agent-skills/claude" ;;
  claude-global) skills_only=true; host=claude; destination="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills" ;;
  copilot-staging) host=copilot; destination="$HOME/.local/share/ai-agent-skills/copilot" ;;
  copilot-global) skills_only=true; host=copilot; destination="$HOME/.copilot/skills" ;;
  copilot-skills|codex-skills|opencode-project|gemini-project|muse-project|antigravity-project|claude-project)
    [ -n "$project" ] || fail "Use --project with the full path to an existing project."
    require_absolute "$project"
    [ -d "$project" ] || fail "Project directory does not exist: $project"
    skills_only=true
    case "$flavor" in
      copilot-skills) host=copilot; destination="$project/.github/skills" ;;
      codex-skills) host=codex; destination="$project/.agents/skills" ;;
      claude-project) host=claude; destination="$project/.claude/skills" ;;
      opencode-project) host=opencode; destination="$project/.opencode/skills" ;;
      gemini-project) host=skills; destination="$project/.gemini/skills" ;;
      muse-project|antigravity-project) host=skills; destination="$project/.agents/skills" ;;
    esac ;;
  opencode-global) skills_only=true; host=opencode; destination="$HOME/.config/opencode/skills" ;;
  opencode-agents-global) agents_only=true; host=opencode; destination="$HOME/.config/opencode/agents" ;;
  claude-agents-global) agents_only=true; host=claude; destination="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/agents" ;;
  codex-agents-global) agents_only=true; host=codex; destination="$HOME/.codex/agents" ;;
  cursor-agents-global) agents_only=true; host=native-agents; agent_format=cursor; destination="$HOME/.cursor/agents" ;;
  copilot-agents-global) agents_only=true; host=native-agents; agent_format=copilot; destination="$HOME/.copilot/agents" ;;
  gemini-agents-global) agents_only=true; host=native-agents; agent_format=gemini; destination="$HOME/.gemini/agents" ;;
  antigravity-agents-global) agents_only=true; host=native-agents; agent_format=antigravity; destination="$HOME/.gemini/config/agents" ;;
  opencode-agents-project|claude-agents-project|codex-agents-project|cursor-agents-project|copilot-agents-project|gemini-agents-project|antigravity-agents-project)
    [ -n "$project" ] || fail "Use --project with the full path to an existing project."
    require_absolute "$project"
    [ -d "$project" ] || fail "Project directory does not exist: $project"
    agents_only=true
    case "$flavor" in
      opencode-*) host=opencode; destination="$project/.opencode/agents" ;;
      claude-*) host=claude; destination="$project/.claude/agents" ;;
      codex-*) host=codex; destination="$project/.codex/agents" ;;
      cursor-*) host=native-agents; agent_format=cursor; destination="$project/.cursor/agents" ;;
      copilot-*) host=native-agents; agent_format=copilot; destination="$project/.github/agents" ;;
      gemini-*) host=native-agents; agent_format=gemini; destination="$project/.gemini/agents" ;;
      antigravity-*) host=native-agents; agent_format=antigravity; destination="$project/.agents/agents" ;;
    esac ;;
  gemini-global) skills_only=true; host=skills; destination="$HOME/.gemini/skills" ;;
  muse-global) skills_only=true; host=skills; destination="$HOME/.agents/skills" ;;
  antigravity-global) skills_only=true; host=skills; destination="$HOME/.gemini/config/skills" ;;
  antigravity-cli-global) skills_only=true; host=skills; destination="$HOME/.gemini/antigravity-cli/skills" ;;
  *) fail "Unknown flavor: $flavor. Use --flavor list." ;;
esac
require_absolute "$HOME"
require_absolute "$destination"
[ -z "$ref" ] || "$source_mode" || fail "--ref requires --from-source."
if [ -n "$version" ]; then valid_version "$version"; fi
if [ -n "$ref" ]; then
  [ "$ref" = main ] || valid_version "$ref"
  [ -z "$version" ] || [ "$version" = "$ref" ] || fail "--version and --ref disagree."
fi
[ "$mode" != merge ] || "$skills_only" || "$agents_only" || fail "--merge applies only to skills-only or agents-only flavors."
# Updates to shared skills still require an explicit replacement/merge decision.
if [ "$action" = update ] && ! "$skills_only" && ! "$agents_only" && [ -z "$mode" ]; then mode=replace; fi
check_path "$destination"
[ -z "$catalog" ] || check_path "$catalog"
if [ -e "$destination" ]; then
  [ -d "$destination" ] || fail "Destination is not a directory: $destination"
  [ -n "$mode" ] || fail "Destination exists. Choose --replace or --merge (skills only)."
fi
printf 'Action: %s\nFlavor: %s\nDestination: %s\nVersion: %s\n' "$action" "$flavor" "$destination" "${ref:-${version:-latest published release}}"
[ -z "$catalog" ] || printf 'Marketplace: %s\n' "$catalog"
if "$dry_run"; then printf 'Dry run: no downloads or changes.\n'; exit 0; fi
for tool in curl tar shasum jq; do need "$tool"; done
if [ -e "$destination" ] && ! "$yes"; then
  [ -t 0 ] || fail "Use --yes to confirm the selected $mode operation without a prompt."
  printf 'This will %s files at %s. Continue? [y/N] ' "$mode" "$destination"
  read -r answer
  case "$answer" in y|Y|yes) ;; *) fail "Cancelled." ;; esac
fi
work=$(mktemp -d)
install_stage=
catalog_temp=
previous_backup=
trap 'rm -rf "$work"; if [ -n "$install_stage" ]; then rm -rf "$install_stage"; fi; if [ -n "$catalog_temp" ]; then rm -f "$catalog_temp"; fi' EXIT
if [ -z "$ref" ] && [ -z "$version" ]; then
  curl -fsSL "https://api.github.com/repos/TylerAkins/ai-agent-skills/releases/latest" -o "$work/release.json"
  version=$(jq -er '.tag_name' "$work/release.json")
  valid_version "$version"
fi
prepare_bundle
if "$skills_only"; then payload="$work/package/skills"; elif "$agents_only"; then payload="$work/package/agents"; [ -z "$agent_format" ] || payload="$payload/$agent_format"; else payload="$work/package"; fi
[ -d "$work/package/skills" ] || fail "Bundle is missing skills."
[ -d "$payload" ] || fail "Bundle is missing selected component: $payload"
if [ -n "$catalog" ]; then
  prepare_catalog
  mkdir -p "$(dirname "$catalog")"
  catalog_temp=$(mktemp "$catalog.XXXXXX")
  cp "$work/marketplace.json" "$catalog_temp"
fi
install_payload
if [ -n "$catalog" ]; then
  if ! mv "$catalog_temp" "$catalog"; then
    rm -rf "$destination"
    if [ -n "$previous_backup" ]; then
      mv "$previous_backup" "$destination"
      rmdir "$(dirname "$previous_backup")"
    fi
    fail "Marketplace update failed; the previous installation was restored."
  fi
  catalog_temp=
fi
printf 'Installed %s at %s.\n' "$flavor" "$destination"
case "$flavor" in
  cursor-agents-*) printf 'Start a new Cursor session and look for the specialist in the subagent tools.\n' ;;
  copilot-agents-*) printf 'Open the Copilot agent picker or ask Copilot to delegate to the named specialist.\n' ;;
  gemini-agents-*) printf 'In Gemini CLI, run /agents and invoke a specialist with @name.\n' ;;
  antigravity-agents-*) printf 'In Antigravity, open /agents to find the specialist.\n' ;;
  opencode-agents-*) printf 'Start a new OpenCode session and ask the parent agent to use the named subagent.\n' ;;
  claude-agents-*) printf 'Start a new Claude Code session and select the specialist from @agent- autocomplete.\n' ;;
  codex-agents-*) printf 'Start a new Codex session and request the named specialist.\n' ;;
  cursor) printf 'Reload Cursor (Developer: Reload Window), then check Customize for the plugin and skills.\n' ;;
  cursor-global) printf 'Start a new Cursor session and check Customize > Skills. Native skill selection applies when relevant.\n' ;;
  codex-desktop) printf 'Quit and reopen ChatGPT/Codex. Open Plugins and install ai-agent-skills from your local marketplace.\n' ;;
  codex-marketplace) printf 'In the app, add a plugin marketplace with this full source path: %s\n' "$marketplace_root" ;;
  codex-global) printf 'Start a new Codex CLI or IDE session. Codex discovers skills in ~/.agents/skills and selects them when relevant.\n' ;;
  claude) printf 'Launch Claude Code with: claude --plugin-dir "%s"\n' "$destination" ;;
  claude-global|claude-project) printf 'Start a new Claude Code session and check /skills. Claude selects matching skills automatically.\n' ;;
  copilot-staging) printf 'This stages the bundle only. Copilot needs a marketplace under Customize > Plugins.\nSee https://docs.github.com/en/copilot/concepts/agents/about-plugins\n' ;;
  antigravity-*) printf 'Start a new Antigravity session and describe the task normally. In the IDE, inspect active skills in the Customizations menu.\n' ;;
  gemini-*) printf 'In Gemini CLI, run /skills reload and /skills list, then describe the task normally and approve skill activation when prompted.\n' ;;
  muse-*) printf 'In Muse Code, run /skills reload. Use muse skills list to check discovery; project skills require a trusted workspace.\n' ;;
  *) printf 'Start a new host session and check for the installed skills.\n' ;;
esac
if "$skills_only" || "$agents_only"; then
  printf 'For updates, use update with --merge (PowerShell: -Action Update -Merge) to preserve unrelated files. Incoming names are replaced; the previous directory is backed up.\n'
else
  printf 'For updates, refresh/reinstall the host plugin if its cached copy remains stale.\n'
fi
