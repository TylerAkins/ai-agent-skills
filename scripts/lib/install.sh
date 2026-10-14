#!/usr/bin/env bash
# Shared release/installation mechanics. Source from the entrypoint; do not execute directly.
# Globals are supplied by that entrypoint and checked when ShellCheck follows the source.
# shellcheck disable=SC2154
set -euo pipefail

fail() { printf '%s\n' "$*" >&2; exit 1; }
need() {
  command -v "$1" >/dev/null && return
  case "$1" in
    jq) fail "Install jq: brew install jq (macOS), or your Linux package manager." ;;
    *) fail "Required tool is missing: $1." ;;
  esac
}
valid_version() { [[ "$1" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || fail "Version must look like v1.0.0."; }
require_absolute() {
  case "$1" in /*) ;; *) fail "Use an absolute path: $1" ;; esac
  case "/$1/" in */../*|*/./* ) fail "Use a normalized path: $1" ;; esac
  [ "$1" != / ] || fail "The filesystem root is not an installation destination."
}
check_path() {
  local path=$1
  while [ "$path" != / ]; do
    [ ! -L "$path" ] || fail "Refusing a symlink destination or parent: $path"
    path=$(dirname "$path")
  done
}
usage() {
  cat <<'HELP'
Usage: bash scripts/install-ai-agent-skills.sh [install|update] --flavor NAME [options]
Flavors:
  cursor             Cursor plugin and routing rule
  codex-desktop      Codex plugin and personal marketplace
  codex-marketplace  Codex plugin in --marketplace-root
  claude             Claude Code plugin
  copilot-staging    Portable plugin staging only
  copilot-skills     Project .github/skills (--project required)
  codex-skills       Project .agents/skills (--project required)
  opencode-project   Project .opencode/skills (--project required)
  opencode-global    User ~/.config/opencode/skills
  gemini-project     Project .gemini/skills (--project required)
  gemini-global      User ~/.gemini/skills
  muse-project       Project .agents/skills (--project required)
  muse-global        User ~/.agents/skills (shared with other agents)
  antigravity-project    Project .agents/skills (--project required)
  antigravity-global     App/IDE ~/.gemini/config/skills
  antigravity-cli-global CLI ~/.gemini/antigravity-cli/skills
  list               Show this list
Options:
  --version v1.0.0    Published release; default is latest stable release
  --from-source      Build a temporary checkout (requires Go >= 1.27.1)
  --ref main         With --from-source, explicitly build main instead of a release tag
  --project PATH     Existing project, absolute path
  --marketplace-root PATH  Local Codex marketplace, absolute path
  --replace          Replace the selected directory; keep a backup
  --merge            Replace incoming skill folders, preserve unknown folders
  --yes              Confirm replacement without prompting
  --dry-run          Show destinations without downloads or writes
HELP
}
prepare_bundle() {
  local archive url expected line entry listing
  if "$source_mode"; then
    need git
    command -v go >/dev/null || fail "Go >= 1.27.1 is required: brew install go or https://go.dev/dl/"
    local major minor patch installed
    installed=$(GOTOOLCHAIN=local go env GOVERSION)
    [[ "$installed" =~ ^go([0-9]+)\.([0-9]+)(\.([0-9]+))?$ ]] || fail "Use stable Go >= 1.27.1: brew install go or https://go.dev/dl/"
    major=${BASH_REMATCH[1]}; minor=${BASH_REMATCH[2]}; patch=${BASH_REMATCH[4]:-0}
    if (( major < 1 || (major == 1 && minor < 27) || (major == 1 && minor == 27 && patch < 1) )); then
      fail "Go >= 1.27.1 is required: brew install go or https://go.dev/dl/"
    fi
    printf 'Building %s from %s.\n' "$host" "${ref:-$version}"
    git clone --quiet --depth 1 --branch "${ref:-$version}" https://github.com/TylerAkins/ai-agent-skills.git "$work/source"
    (cd "$work/source" || exit; GOTOOLCHAIN=local go run ./cmd/skillpack -target "$host" -out "$work/package")
    return
  fi
  archive="ai-agent-skills-$host-$version.tar.gz"
  url="https://github.com/TylerAkins/ai-agent-skills/releases/download/$version"
  printf 'Downloading %s.\n' "$archive"
  curl -fsSL "$url/$archive" -o "$work/$archive"
  curl -fsSL "$url/SHA256SUMS" -o "$work/SHA256SUMS"
  curl -fsSL "$url/SOURCE_COMMIT" -o "$work/SOURCE_COMMIT"
  : > "$work/selected-checksums"
  for expected in "$archive" SOURCE_COMMIT; do
    line=$(awk -v file="$expected" '$2 == file || $2 == "./" file {print}' "$work/SHA256SUMS")
    if [ -z "$line" ] || [ "$(printf '%s\n' "$line" | wc -l | tr -d ' ')" != 1 ]; then
      fail "Missing or duplicate checksum for $expected."
    fi
    [[ "$line" =~ ^[a-fA-F0-9]{64}[[:space:]] ]] || fail "Invalid checksum entry."
    printf '%s\n' "$line" >> "$work/selected-checksums"
  done
  (cd "$work" || exit; shasum -a 256 --check selected-checksums)
  listing=$(tar -tzf "$work/$archive")
  [ -n "$listing" ] || fail "Empty release archive."
  while IFS= read -r entry; do
    case "$entry" in
      "ai-agent-skills-$host"|"ai-agent-skills-$host/"*) ;;
      *) fail "Unexpected archive path: $entry" ;;
    esac
    case "/$entry/" in */../*|*/./*) fail "Unsafe archive path: $entry" ;; esac
  done <<< "$listing"
  # Release bundles contain only regular files and directories, never links/devices.
  tar -tvzf "$work/$archive" > "$work/archive-types"
  if LC_ALL=C grep -q '^[^d-]' "$work/archive-types"; then fail "Release archive contains unsupported file types."; fi
  tar -xzf "$work/$archive" -C "$work"
  mv "$work/ai-agent-skills-$host" "$work/package"
}
prepare_catalog() {
  local existing="$work/existing-marketplace.json"
  if [ -e "$catalog" ]; then
    [ -f "$catalog" ] || fail "Marketplace is not a regular file: $catalog"
    cp "$catalog" "$existing"
  else
    printf '%s\n' '{"name":"ai-agent-skills-local","interface":{"displayName":"AI Agent Skills"},"plugins":[]}' > "$existing"
  fi
  jq -e 'type == "object" and (.name | type == "string") and (.plugins | type == "array")' "$existing" >/dev/null || fail "Invalid existing marketplace; no changes made."
  jq --arg path "$source_path" '
    .interface.displayName //= "AI Agent Skills" |
    .plugins = ([.plugins[] | select(.name != "ai-agent-skills")] + [{
      name: "ai-agent-skills", source: {source: "local", path: $path},
      policy: {installation: "AVAILABLE", authentication: "ON_INSTALL"}, category: "Productivity"
    }])' "$existing" > "$work/marketplace.json"
}
install_payload() {
  local parent stage backup item
  parent=$(dirname "$destination")
  mkdir -p "$parent"
  stage=$(mktemp -d "$parent/.ai-agent-skills-stage.XXXXXX")
  # The entrypoint EXIT trap cleans this path after failures.
  # shellcheck disable=SC2034
  install_stage=$stage
  # Build a complete candidate on the destination filesystem before replacing anything.
  if [ "$mode" = merge ] && [ -d "$destination" ]; then
    cp -R "$destination" "$stage/content"
    for item in "$payload"/*; do
      [ -d "$item" ] || continue
      rm -rf "$stage/content/$(basename "$item")"
      cp -R "$item" "$stage/content/"
    done
  else
    cp -R "$payload" "$stage/content"
  fi
  if [ -d "$destination" ]; then
    check_path "$parent/../.ai-agent-skills-backups"
    mkdir -p "$parent/../.ai-agent-skills-backups"
    backup=$(mktemp -d "$parent/../.ai-agent-skills-backups/backup.XXXXXX")
    # The entrypoint uses this path for catalog-commit rollback.
    # shellcheck disable=SC2034
    previous_backup="$backup/previous"
    mv "$destination" "$backup/previous"
    if ! mv "$stage/content" "$destination"; then
      mv "$backup/previous" "$destination"
      rmdir "$backup"
      rm -rf "$stage"
      fail "Installation failed; previous directory restored."
    fi
    printf 'Previous files saved at %s/previous.\n' "$backup"
  else
    mv "$stage/content" "$destination"
  fi
  rmdir "$stage"
}
