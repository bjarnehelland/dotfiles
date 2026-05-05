#!/usr/bin/env bash
#
# Clone repos from GitHub via a multi-select picker (gum).
# Lists non-archived repos from the configured orgs/users, filters out the
# ones already cloned locally, and clones the selected ones via SSH into
# ~/Code/<owner>/<repo>.

set -o errexit
set -o pipefail

CODE_ROOT="${CODE_ROOT:-$HOME/Code}"
OWNERS=("bjarnehelland" "stacc")
GH_LIMIT=1000

reset_color=$(tput sgr 0)
info()    { printf "%s[*] %s%s\n" "$(tput setaf 4)" "$1" "$reset_color"; }
success() { printf "%s[*] %s%s\n" "$(tput setaf 2)" "$1" "$reset_color"; }
warn()    { printf "%s[*] %s%s\n" "$(tput setaf 3)" "$1" "$reset_color"; }
err()     { printf "%s[!] %s%s\n" "$(tput setaf 1)" "$1" "$reset_color" >&2; }

require() {
  command -v "$1" >/dev/null || { err "$1 not found in PATH"; exit 1; }
}

require gh
require gum
require git

if ! gh auth status >/dev/null 2>&1; then
  err "gh is not authenticated — run 'gh auth login' first"
  exit 1
fi

info "Fetching repos from: ${OWNERS[*]}"

# Build the candidate list: <owner>/<repo>, skipping ones already on disk.
candidates=()
for owner in "${OWNERS[@]}"; do
  while IFS= read -r repo; do
    [[ -z "$repo" ]] && continue
    local_path="$CODE_ROOT/$repo"
    if [[ -d "$local_path/.git" ]]; then
      continue
    fi
    candidates+=("$repo")
  done < <(gh repo list "$owner" --limit "$GH_LIMIT" --no-archived --json nameWithOwner --jq '.[].nameWithOwner' 2>/dev/null)
done

if [[ ${#candidates[@]} -eq 0 ]]; then
  success "All repos for ${OWNERS[*]} are already cloned. Nothing to do."
  exit 0
fi

info "Pick repos to clone (type to filter, tab to toggle, enter to confirm):"
selected=$(printf '%s\n' "${candidates[@]}" | gum filter --no-limit --height 20 --header "Repos to clone")

if [[ -z "$selected" ]]; then
  warn "No repos selected"
  exit 0
fi

while IFS= read -r repo; do
  [[ -z "$repo" ]] && continue
  dest="$CODE_ROOT/$repo"
  mkdir -p "$(dirname "$dest")"
  info "Cloning $repo → $dest"
  git clone "git@github.com:${repo}.git" "$dest"
  if command -v zoxide >/dev/null; then
    zoxide add "$dest" >/dev/null
  fi
  success "Cloned $repo"
done <<< "$selected"
