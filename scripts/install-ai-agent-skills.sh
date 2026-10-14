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
catalog=
source_path=
case "$flavor" in
  cursor) host=cursor; destination="$HOME/.cursor/plugins/local/ai-agent-skills" ;;
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
  claude) host=claude; destination="$HOME/.local/share/ai-agent-skills/claude" ;;
  copilot-staging) host=copilot; destination="$HOME/.local/share/ai-agent-skills/copilot" ;;
  copilot-global) skills_only=true; host=copilot; destination="$HOME/.copilot/skills" ;;
  copilot-skills|codex-skills|opencode-project|gemini-project|muse-project|antigravity-project)
    [ -n "$project" ] || fail "Use --project with the full path to an existing project."
    require_absolute "$project"
    [ -d "$project" ] || fail "Project directory does not exist: $project"
    skills_only=true
    case "$flavor" in
      copilot-skills) host=copilot; destination="$project/.github/skills" ;;
      codex-skills) host=codex; destination="$project/.agents/skills" ;;
      opencode-project) host=opencode; destination="$project/.opencode/skills" ;;
      gemini-project) host=skills; destination="$project/.gemini/skills" ;;
      muse-project|antigravity-project) host=skills; destination="$project/.agents/skills" ;;
    esac ;;
  opencode-global) skills_only=true; host=opencode; destination="$HOME/.config/opencode/skills" ;;
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
[ "$mode" != merge ] || "$skills_only" || fail "--merge applies only to skills-only flavors."
# Updates to shared skills still require an explicit replacement/merge decision.
if [ "$action" = update ] && ! "$skills_only" && [ -z "$mode" ]; then mode=replace; fi
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
if "$skills_only"; then payload="$work/package/skills"; else payload="$work/package"; fi
[ -d "$payload" ] || fail "Bundle is missing skills."
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
  cursor) printf 'Reload Cursor (Developer: Reload Window), then check Customize for the plugin and skills.\n' ;;
  codex-desktop) printf 'Quit and reopen ChatGPT/Codex. Open Plugins and install ai-agent-skills from your local marketplace.\n' ;;
  codex-marketplace) printf 'In the app, add a plugin marketplace with this full source path: %s\n' "$marketplace_root" ;;
  claude) printf 'Launch Claude Code with: claude --plugin-dir "%s"\n' "$destination" ;;
  copilot-staging) printf 'This stages the bundle only. Copilot needs a marketplace under Customize > Plugins.\nSee https://docs.github.com/en/copilot/concepts/agents/about-plugins\n' ;;
  antigravity-*) printf 'Start a new Antigravity session and invoke /agent-planning. In the IDE, inspect skills in the Customizations menu.\n' ;;
  gemini-*) printf 'In Gemini CLI, run /skills reload and /skills list, then request a skill.\n' ;;
  muse-*) printf 'In Muse Code, run /skills reload. Use muse skills list to check discovery; project skills require a trusted workspace.\n' ;;
  *) printf 'Start a new host session and check for the installed skills.\n' ;;
esac
printf 'For updates, refresh/reinstall the host plugin if its cached copy remains stale.\n'
