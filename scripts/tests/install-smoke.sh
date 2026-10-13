#!/usr/bin/env bash
set -euo pipefail
repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
work=$(mktemp -d)
work=$(cd "$work" && pwd -P)
trap 'rm -rf "$work"' EXIT
fixtures=${1:-"$work/assets"}
mkdir -p "$fixtures"
if [ "$#" -eq 0 ]; then
  for host in cursor codex claude copilot opencode; do
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
export HOME="$work/home"
installer="$repo_root/scripts/install-ai-agent-skills.sh"
mkdir -p "$HOME/.agents/plugins"
printf '%s\n' '{"name":"existing","interface":{"displayName":"Existing"},"plugins":[{"name":"other-plugin","source":"./other"}]}' > "$HOME/.agents/plugins/marketplace.json"
for flavor in cursor codex-desktop codex-marketplace claude copilot-staging copilot-skills codex-skills opencode-project opencode-global; do
  printf 'Testing %s.\n' "$flavor"
  args=(--flavor "$flavor" --version v1.0.0 --yes)
  case "$flavor" in
    codex-marketplace) args+=(--marketplace-root "$work/marketplace") ;;
    *-skills|opencode-project) args+=(--project "$work/project") ;;
  esac
  bash "$installer" "${args[@]}"
  if bash "$installer" "${args[@]}" > "$work/refusal.log" 2>&1; then
    printf 'Existing installation was overwritten without permission.\n' >&2; exit 1
  fi
  case "$flavor" in
    *-skills|opencode-*) bash "$installer" update "${args[@]}" --merge ;;
    *) bash "$installer" update "${args[@]}" ;;
  esac
done
jq -e '.name == "existing" and .interface.displayName == "Existing" and ([.plugins[] | select(.name == "other-plugin")] | length == 1) and ([.plugins[] | select(.name == "ai-agent-skills")] | length == 1)' "$HOME/.agents/plugins/marketplace.json" >/dev/null
mkdir "$work/project/.agents/skills/unrelated"
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
printf 'All installer flavors, updates, preservation, and failure checks passed.\n'

