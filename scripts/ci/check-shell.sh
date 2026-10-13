#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

file_list=$(mktemp)
trap 'rm -f "$file_list"' EXIT
git ls-files --cached --others --exclude-standard -z -- '*.sh' > "$file_list"

scripts=()
while IFS= read -r -d '' file; do
  scripts+=("$file")
done < "$file_list"

if [ "${#scripts[@]}" -eq 0 ]; then
  printf 'No shell scripts found.\n'
  exit 0
fi

command -v shellcheck >/dev/null || {
  printf 'ShellCheck is required. Install it before running this check.\n' >&2
  exit 1
}
printf 'ShellCheck version: '
shellcheck --version
for file in "${scripts[@]}"; do
  printf 'Checking %s\n' "$file"
  shellcheck -x -- "$file"
done
printf 'Checked %s shell scripts.\n' "${#scripts[@]}"
