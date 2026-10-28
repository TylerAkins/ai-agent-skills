#!/usr/bin/env bash
set -euo pipefail
tree_snapshot() {
  local root=$1 file
  find "$root" -type f -print | LC_ALL=C sort | while IFS= read -r file; do
    shasum -a 256 "$file"
  done
}
repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
work=$(mktemp -d)
work=$(cd "$work" && pwd -P)
trap 'rm -rf "$work"' EXIT
fixtures=${1:-"$work/assets"}
mkdir -p "$fixtures"
if [ "$#" -eq 0 ]; then
  for host in cursor codex claude copilot opencode skills; do
    printf 'Preparing %s test bundle.\n' "$host"
    (cd "$repo_root"; go run ./cmd/skillpack -target "$host" -out "$work/ai-agent-skills-$host")
    tar -czf "$fixtures/ai-agent-skills-$host-v1.0.0.tar.gz" -C "$work" "ai-agent-skills-$host"
  done
  printf '%s\n' '0123456789012345678901234567890123456789' > "$fixtures/SOURCE_COMMIT"
  (cd "$fixtures"; shasum -a 256 ./*.tar.gz SOURCE_COMMIT > SHA256SUMS)
fi
# Fake only the download boundary; exercise extraction, checksums, paths and JSON for real.
mkdir "$work/bin" "$work/home" "$work/project"
cat > "$work/bin/curl" <<'CURL'
#!/usr/bin/env bash
set -euo pipefail
url=$2
if [[ "$url" == */releases/latest ]]; then
  printf '{"tag_name":"v1.0.0"}\n' > "$4"
else
  cp "$INSTALLER_FIXTURES/$(basename "$url")" "$4"
fi
CURL
chmod +x "$work/bin/curl"
export INSTALLER_FIXTURES="$fixtures"
export PATH="$work/bin:$PATH"
(cd "$repo_root"; go build -o "$work/skillpack" ./cmd/skillpack)
export HOME="$work/home"
export CLAUDE_CONFIG_DIR="$HOME/claude profile"
instruction_sentinels=(
  "$HOME/.cursor/rules/user.mdc"
  "$HOME/.codex/AGENTS.md"
  "$HOME/.claude/CLAUDE.md"
  "$CLAUDE_CONFIG_DIR/CLAUDE.md"
  "$HOME/.copilot/copilot-instructions.md"
  "$HOME/.config/opencode/AGENTS.md"
  "$HOME/.gemini/GEMINI.md"
  "$HOME/.agents/AGENTS.md"
)
for file in "${instruction_sentinels[@]}"; do
  mkdir -p "$(dirname "$file")"
  printf 'Keep user instructions\n' > "$file"
done
installer="$repo_root/scripts/install-ai-agent-skills.sh"
mkdir -p "$HOME/.agents/plugins"
printf '%s\n' '{"name":"existing","interface":{"displayName":"Existing"},"plugins":[{"name":"other-plugin","source":"./other"}]}' > "$HOME/.agents/plugins/marketplace.json"
for option in --flavor --version --project --marketplace-root --ref; do
  if bash "$installer" "$option" > "$work/missing-argument.log" 2>&1; then
    printf 'Missing option value was accepted: %s\n' "$option" >&2; exit 1
  fi
  grep -q 'needs a value' "$work/missing-argument.log"
done
for flavor in gemini-project gemini-global muse-project muse-global antigravity-project antigravity-global antigravity-cli-global claude-project cursor-global codex-global claude-global; do
  args=(--flavor "$flavor" --dry-run)
  case "$flavor" in *-project) args+=(--project "$work/project") ;; esac
  bash "$installer" "${args[@]}"
done
for flavor in cursor cursor-global codex-desktop codex-marketplace codex-global claude claude-global claude-project copilot-staging copilot-skills copilot-global codex-skills opencode-project opencode-global gemini-project gemini-global muse-project muse-global antigravity-project antigravity-global antigravity-cli-global; do
  printf 'Testing %s.\n' "$flavor"
  original_home=$HOME
  if [ "$flavor" = codex-global ]; then
    HOME="$work/codex-global-home"
    mkdir -p "$HOME"
    mkdir -p "$HOME/.codex" "$HOME/.agents"
    printf 'Keep alternate-home instructions\n' > "$HOME/.codex/AGENTS.md"
    printf 'Keep alternate-home instructions\n' > "$HOME/.agents/AGENTS.md"
  fi
  args=(--flavor "$flavor" --version v1.0.0 --yes)
  case "$flavor" in
    codex-marketplace) args+=(--marketplace-root "$work/marketplace") ;;
    *-skills|*-project) args+=(--project "$work/project") ;;
  esac
  if [ "$flavor" = muse-project ] || [ "$flavor" = antigravity-project ]; then
    mkdir -p "$work/$flavor"
    args=(--flavor "$flavor" --version v1.0.0 --yes --project "$work/$flavor")
  fi
  bash "$installer" "${args[@]}"
  case "$flavor" in
    copilot-global) skill_root="$HOME/.copilot/skills" ;;
    cursor-global) skill_root="$HOME/.cursor/skills" ;;
    codex-global) skill_root="$HOME/.agents/skills" ;;
    claude-global) skill_root="$CLAUDE_CONFIG_DIR/skills" ;;
    claude-project) skill_root="$work/project/.claude/skills" ;;
    copilot-skills) skill_root="$work/project/.github/skills" ;;
    codex-skills) skill_root="$work/project/.agents/skills" ;;
    opencode-project) skill_root="$work/project/.opencode/skills" ;;
    opencode-global) skill_root="$HOME/.config/opencode/skills" ;;
    gemini-project) skill_root="$work/project/.gemini/skills" ;;
    gemini-global) skill_root="$HOME/.gemini/skills" ;;
    muse-project) skill_root="$work/muse-project/.agents/skills" ;;
    muse-global) skill_root="$HOME/.agents/skills" ;;
    antigravity-project) skill_root="$work/antigravity-project/.agents/skills" ;;
    antigravity-global) skill_root="$HOME/.gemini/config/skills" ;;
    antigravity-cli-global) skill_root="$HOME/.gemini/antigravity-cli/skills" ;;
    *) skill_root= ;;
  esac
  install_root=$skill_root
  if [ -z "$install_root" ]; then
    case "$flavor" in
      cursor) install_root="$HOME/.cursor/plugins/local/ai-agent-skills" ;;
      codex-desktop) install_root="$HOME/.codex/plugins/ai-agent-skills" ;;
      codex-marketplace) install_root="$work/marketplace/plugins/ai-agent-skills" ;;
      claude) install_root="$HOME/.local/share/ai-agent-skills/claude" ;;
      copilot-staging) install_root="$HOME/.local/share/ai-agent-skills/copilot" ;;
    esac
  fi
  if [ -n "$skill_root" ]; then
    test -f "$skill_root/test-authoring/SKILL.md"
    test -f "$skill_root/test-authoring/references/scope-and-state.md"
    test ! -e "$skill_root/plugin.json"
    mkdir -p "$skill_root/unrelated"
    printf 'Keep me\n' > "$skill_root/unrelated/file"
    printf 'Old content\n' > "$skill_root/test-authoring/SKILL.md"
  fi
  if bash "$installer" "${args[@]}" > "$work/refusal.log" 2>&1; then
    printf 'Existing installation was overwritten without permission.\n' >&2; exit 1
  fi
  case "$flavor" in
    *-skills|cursor-global|codex-global|claude-global|claude-project|copilot-global|opencode-*|gemini-*|muse-*|antigravity-*) bash "$installer" update "${args[@]}" --merge ;;
    *) bash "$installer" update "${args[@]}" ;;
  esac
  before_snapshot=$(tree_snapshot "$install_root")
  case "$flavor" in
    *-skills|cursor-global|codex-global|claude-global|claude-project|copilot-global|opencode-*|gemini-*|muse-*|antigravity-*) bash "$installer" update "${args[@]}" --merge ;;
    *) bash "$installer" update "${args[@]}" ;;
  esac
  test "$before_snapshot" = "$(tree_snapshot "$install_root")"
  if [ -n "$skill_root" ]; then
    test "$(cat "$skill_root/unrelated/file")" = 'Keep me'
    grep -q 'name: test-authoring' "$skill_root/test-authoring/SKILL.md"
    test "$(find "$skill_root" -mindepth 1 -maxdepth 1 -type d -name test-authoring | wc -l | tr -d ' ')" = 1
  fi
  if [ "$flavor" = codex-global ]; then
    test "$(cat "$HOME/.codex/AGENTS.md")" = 'Keep alternate-home instructions'
    test "$(cat "$HOME/.agents/AGENTS.md")" = 'Keep alternate-home instructions'
  fi
  HOME=$original_home
done
for host in opencode claude codex; do
  for scope in global project; do
    flavor="$host-agents-$scope"
    args=(--flavor "$flavor" --version v1.0.0 --yes)
    if [ "$scope" = project ]; then args+=(--project "$work/project"); root="$work/project/.$host/agents"; else
      case "$host" in
        opencode) root="$HOME/.config/opencode/agents" ;;
        claude) root="$CLAUDE_CONFIG_DIR/agents" ;;
        codex) root="$HOME/.codex/agents" ;;
      esac
    fi
    bash "$installer" "${args[@]}"
    extension=md
    if [ "$host" = codex ]; then extension=toml; fi
    for agent in architecture-advisor dependency-investigator independent-reviewer root-cause-investigator; do test -f "$root/$agent.$extension"; done
    test ! -e "$root/skills"
    printf 'Keep unrelated agent\n' > "$root/custom.$extension"
    printf 'User modification\n' > "$root/independent-reviewer.$extension"
    if bash "$installer" update "${args[@]}" > "$work/agent-refusal.log" 2>&1; then
      printf 'Agent update replaced a custom definition without merge consent.\n' >&2; exit 1
    fi
    test "$(cat "$root/independent-reviewer.$extension")" = 'User modification'
    bash "$installer" update "${args[@]}" --merge
    test "$(cat "$root/custom.$extension")" = 'Keep unrelated agent'
    grep -q 'Do not' "$root/independent-reviewer.$extension"
    snapshot=$(tree_snapshot "$root")
    bash "$installer" update "${args[@]}" --merge
    test "$snapshot" = "$(tree_snapshot "$root")"
  done
done
for file in "${instruction_sentinels[@]}"; do
  test "$(cat "$file")" = 'Keep user instructions'
done
unset CLAUDE_CONFIG_DIR
claude_default_root="$HOME/.claude/skills"
bash "$installer" --flavor claude-global --version v1.0.0 --yes
test -f "$claude_default_root/test-authoring/SKILL.md"
bash "$installer" update --flavor claude-global --version v1.0.0 --merge --yes
test -f "$claude_default_root/test-authoring/SKILL.md"
export CLAUDE_CONFIG_DIR="$HOME/claude profile"
jq -e '.name == "existing" and .interface.displayName == "Existing" and ([.plugins[] | select(.name == "other-plugin")] | length == 1) and ([.plugins[] | select(.name == "ai-agent-skills")] | length == 1)' "$HOME/.agents/plugins/marketplace.json" >/dev/null
mkdir -p "$work/project/.agents/skills/unrelated"
printf 'Keep me\n' > "$work/project/.agents/skills/unrelated/file"
bash "$installer" update --flavor codex-skills --project "$work/project" --merge --yes
test "$(cat "$work/project/.agents/skills/unrelated/file")" = 'Keep me'
printf 'Customized\n' > "$HOME/.cursor/plugins/local/ai-agent-skills/custom.txt"
bash "$installer" update --flavor cursor --version v1.0.0 --yes
test ! -e "$HOME/.cursor/plugins/local/ai-agent-skills/custom.txt"
find "$HOME/.cursor/plugins" -path '*/previous/custom.txt' -type f | grep -q .
bash "$installer" update --flavor cursor --dry-run > "$work/dry-run"
grep -q 'Dry run' "$work/dry-run"
mkdir -p "$work/corrupt"
cp "$fixtures/"* "$work/corrupt/"
printf 'broken\n' >> "$work/corrupt/ai-agent-skills-cursor-v1.0.0.tar.gz"
if INSTALLER_FIXTURES="$work/corrupt" bash "$installer" update --flavor cursor --version v1.0.0 --yes > "$work/corrupt.log" 2>&1; then
  printf 'Corrupt archive was accepted.\n' >&2; exit 1
fi
test -f "$HOME/.cursor/plugins/local/ai-agent-skills/.cursor-plugin/plugin.json"

for checksum_case in missing duplicate; do
  mkdir "$work/$checksum_case"
  cp "$fixtures/"* "$work/$checksum_case/"
  if [ "$checksum_case" = missing ]; then
    grep -v 'ai-agent-skills-cursor-v1.0.0.tar.gz' "$fixtures/SHA256SUMS" > "$work/$checksum_case/SHA256SUMS"
  else
    grep 'ai-agent-skills-cursor-v1.0.0.tar.gz' "$fixtures/SHA256SUMS" >> "$work/$checksum_case/SHA256SUMS"
  fi
  if INSTALLER_FIXTURES="$work/$checksum_case" bash "$installer" update --flavor cursor --version v1.0.0 --yes > "$work/$checksum_case.log" 2>&1; then
    printf 'Invalid checksum list accepted: %s\n' "$checksum_case" >&2; exit 1
  fi
  grep -q 'Missing or duplicate checksum' "$work/$checksum_case.log"
done
printf 'Preserve old plugin\n' > "$HOME/.codex/plugins/ai-agent-skills/local-change.txt"
cp "$HOME/.agents/plugins/marketplace.json" "$work/catalog-before"
cat > "$work/bin/mv" <<'MV'
#!/usr/bin/env bash
set -euo pipefail
target=
for argument in "$@"; do target=$argument; done
case "$target" in */marketplace.json) exit 17 ;; esac
exec /bin/mv "$@"
MV
chmod +x "$work/bin/mv"
if bash "$installer" update --flavor codex-desktop --version v1.0.0 --yes > "$work/catalog-write.log" 2>&1; then
  printf 'Catalog write failure was ignored.\n' >&2; exit 1
fi
rm "$work/bin/mv"
test "$(cat "$HOME/.codex/plugins/ai-agent-skills/local-change.txt")" = 'Preserve old plugin'
cmp "$work/catalog-before" "$HOME/.agents/plugins/marketplace.json"
printf 'not-json\n' > "$HOME/.agents/plugins/marketplace.json"
if bash "$installer" update --flavor codex-desktop --version v1.0.0 --yes > "$work/bad-catalog.log" 2>&1; then
  printf 'Invalid catalog was replaced.\n' >&2; exit 1
fi
test "$(cat "$HOME/.agents/plugins/marketplace.json")" = not-json
ln -s "$work/project" "$work/alias"
if bash "$installer" --flavor codex-skills --project "$work/alias" --merge --yes > "$work/symlink.log" 2>&1; then
  printf 'Symlink destination was accepted.\n' >&2; exit 1
fi
cat > "$work/bin/go" <<'GO'
#!/usr/bin/env bash
[ "${GOTOOLCHAIN:-}" = local ] || exit 19
printf 'go1.26.0\n'
GO
chmod +x "$work/bin/go"
if bash "$installer" update --flavor cursor --from-source --version v1.0.0 --yes > "$work/old-go.log" 2>&1; then
  printf 'Old Go was accepted.\n' >&2; exit 1
fi
grep -q 'Go >= 1.27.1' "$work/old-go.log"
rm "$work/bin/go"
# Both archive generations remain usable. Shared names win when both are listed.
mkdir "$work/shared-assets" "$work/shared-build"
for target in portable skills; do
  "$work/skillpack" -root "$repo_root" -target "$target" -out "$work/shared-build/ai-agent-skills-$target"
  tar -czf "$work/shared-assets/ai-agent-skills-$target-v1.0.0.tar.gz" -C "$work/shared-build" "ai-agent-skills-$target"
done
cp "$fixtures/"* "$work/shared-assets/"
(cd "$work/shared-assets"; shasum -a 256 ./*.tar.gz SOURCE_COMMIT > SHA256SUMS)
for flavor in codex-desktop copilot-staging copilot-global opencode-global; do
  args=(update --flavor "$flavor" --version v1.0.0 --yes)
  if [ "$flavor" = copilot-global ]; then args+=(--merge); fi
  expected=portable
  if [ "$flavor" = opencode-global ]; then args+=(--merge); expected=skills; fi
  # Restore the catalog damaged by the invalid-catalog check above.
  cp "$work/catalog-before" "$HOME/.agents/plugins/marketplace.json"
  INSTALLER_FIXTURES="$work/shared-assets" bash "$installer" "${args[@]}" > "$work/shared-$flavor.log"
  grep -q "Downloading ai-agent-skills-$expected-v1.0.0.tar.gz" "$work/shared-$flavor.log"
done
mkdir "$work/shared-only"
cp "$work/shared-assets/"* "$work/shared-only/"
for target in codex copilot opencode; do rm "$work/shared-only/ai-agent-skills-$target-v1.0.0.tar.gz"; done
(cd "$work/shared-only"; shasum -a 256 ./*.tar.gz SOURCE_COMMIT > SHA256SUMS)
for flavor in codex-desktop copilot-staging copilot-global opencode-global; do
  args=(update --flavor "$flavor" --version v1.0.0 --yes)
  if [ "$flavor" = opencode-global ] || [ "$flavor" = copilot-global ]; then args+=(--merge); fi
  INSTALLER_FIXTURES="$work/shared-only" bash "$installer" "${args[@]}" > "$work/shared-only.log"
done
mkdir "$work/legacy-opencode"
cp "$fixtures/"* "$work/legacy-opencode/"
rm "$work/legacy-opencode/ai-agent-skills-skills-v1.0.0.tar.gz"
(cd "$work/legacy-opencode"; shasum -a 256 ./*.tar.gz SOURCE_COMMIT > SHA256SUMS)
INSTALLER_FIXTURES="$work/legacy-opencode" bash "$installer" update --flavor opencode-global --version v1.0.0 --merge --yes > "$work/legacy-opencode.log"
grep -q 'Downloading ai-agent-skills-opencode-v1.0.0.tar.gz' "$work/legacy-opencode.log"

printf 'Preserve selected plugin\n' > "$HOME/.local/share/ai-agent-skills/copilot/sentinel"
for failure in corrupt duplicate missing-download wrong-root; do
  mkdir "$work/shared-$failure"
  cp "$work/shared-assets/"* "$work/shared-$failure/"
  archive=ai-agent-skills-portable-v1.0.0.tar.gz
  case "$failure" in
    corrupt) printf 'broken\n' >> "$work/shared-$failure/$archive" ;;
    duplicate) grep "$archive" "$work/shared-assets/SHA256SUMS" >> "$work/shared-$failure/SHA256SUMS" ;;
    missing-download) rm "$work/shared-$failure/$archive" ;;
    wrong-root)
      cp "$fixtures/ai-agent-skills-copilot-v1.0.0.tar.gz" "$work/shared-$failure/$archive"
      (cd "$work/shared-$failure"; shasum -a 256 ./*.tar.gz SOURCE_COMMIT > SHA256SUMS) ;;
  esac
  if INSTALLER_FIXTURES="$work/shared-$failure" bash "$installer" update --flavor copilot-staging --version v1.0.0 --yes > "$work/shared-failure.log" 2>&1; then
    printf 'Shared archive failure was ignored: %s\n' "$failure" >&2; exit 1
  fi
  test "$(cat "$HOME/.local/share/ai-agent-skills/copilot/sentinel")" = 'Preserve selected plugin'
done
printf 'All installer flavors, updates, preservation, and failure checks passed.\n'
