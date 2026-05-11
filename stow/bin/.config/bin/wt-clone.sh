#!/usr/bin/env bash
# wt-clone — clone a repo in bare-worktree layout
#
# Usage:
#   wt-clone <repo-url> [target-dir]
#
# Example:
#   wt-clone git@github.com:stacc/bolig-opf.git
#   wt-clone git@github.com:stacc/bolig-opf.git ~/code/bolig-opf

set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $(basename "$0") <repo-url> [target-dir]" >&2
  exit 1
fi

REPO_URL="$1"

# Derive target dir from repo URL if not given:
#   git@github.com:stacc/bolig-opf.git -> bolig-opf
#   https://github.com/stacc/bolig-opf -> bolig-opf
if [[ $# -eq 2 ]]; then
  TARGET="$2"
else
  TARGET=$(basename "$REPO_URL" .git)
fi

if [[ -e "$TARGET" ]]; then
  echo "error: '$TARGET' already exists" >&2
  exit 1
fi

echo "→ Creating $TARGET"
mkdir -p "$TARGET"
cd "$TARGET"

echo "→ Bare cloning into .bare"
git clone --bare "$REPO_URL" .bare

echo "→ Pointing .git at .bare"
echo "gitdir: ./.bare" > .git

echo "→ Fixing fetch refspec so 'git fetch' populates refs/remotes/origin/*"
git config --file .bare/config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch origin

# Figure out the default branch from the remote (works even if it's not 'main')
DEFAULT_BRANCH=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||' || echo "")
if [[ -z "$DEFAULT_BRANCH" ]]; then
  # Fallback: try main, then master
  if git show-ref --verify --quiet refs/remotes/origin/main; then
    DEFAULT_BRANCH="main"
  elif git show-ref --verify --quiet refs/remotes/origin/master; then
    DEFAULT_BRANCH="master"
  else
    echo "error: could not determine default branch" >&2
    exit 1
  fi
fi

echo "→ Adding worktree for default branch: $DEFAULT_BRANCH"
git worktree add "$DEFAULT_BRANCH" "$DEFAULT_BRANCH"

echo
echo "✓ Done. Layout:"
echo "  $TARGET/"
echo "  ├── .bare/"
echo "  ├── .git"
echo "  └── $DEFAULT_BRANCH/"
echo
echo "Next:"
echo "  cd $TARGET/$DEFAULT_BRANCH"
echo "  # bootstrap as needed: bun install, direnv allow, etc."
echo
echo "Add more worktrees with:"
echo "  cd $TARGET && git worktree add <name> -b feature/<name>"
