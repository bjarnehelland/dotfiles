#!/usr/bin/env bash
# wt-add — add a new worktree and bootstrap it
#
# Run from the repo root (the dir containing .bare/ and .git).
#
# Usage:
#   wt-add [--claude] <name> [base-branch]
#
# Examples:
#   wt-add feature-auth                       # branches off origin/HEAD
#   wt-add bugfix-123 main                    # branches off main
#   wt-add review-pr-456 origin/main          # branches off a remote ref
#   wt-add --claude feature-auth              # bootstrap, then exec `claude`

set -euo pipefail

LAUNCH_CLAUDE=0
if [[ "${1:-}" == "--claude" ]]; then
  LAUNCH_CLAUDE=1
  shift
fi

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $(basename "$0") [--claude] <name> [base-branch]" >&2
  exit 1
fi

NAME="$1"
BASE="${2:-}"

# Sanity check: are we in a bare-worktree layout?
if [[ ! -d .bare ]] || [[ ! -f .git ]]; then
  echo "error: must be run from the bare-worktree root (containing .bare/ and .git)" >&2
  exit 1
fi

if [[ -e "$NAME" ]]; then
  echo "error: '$NAME' already exists" >&2
  exit 1
fi

echo "→ Fetching latest from origin"
git fetch origin

if [[ -n "$BASE" ]]; then
  echo "→ Adding worktree '$NAME' branching from '$BASE'"
  git worktree add "$NAME" -b "$NAME" "$BASE"
else
  echo "→ Adding worktree '$NAME' branching from origin/HEAD"
  git worktree add "$NAME" -b "$NAME"
fi

cd "$NAME"

# --- Bootstrap steps ---
# Customize this block for your projects.

if [[ -f .envrc ]] && command -v direnv >/dev/null 2>&1; then
  echo "→ direnv allow"
  direnv allow
fi

if [[ -f bun.lock || -f bun.lockb ]] && command -v bun >/dev/null 2>&1; then
  echo "→ bun install"
  bun install
elif [[ -f package-lock.json ]] && command -v npm >/dev/null 2>&1; then
  echo "→ npm install"
  npm install
elif [[ -f pnpm-lock.yaml ]] && command -v pnpm >/dev/null 2>&1; then
  echo "→ pnpm install"
  pnpm install
fi

# Copy any gitignored files you want present in every worktree.
# (Claude Code's .worktreeinclude handles this for --worktree, but not
# for manual git worktree add, so we do it here too.)
ROOT=$(git rev-parse --show-toplevel)
PARENT=$(dirname "$ROOT")
for f in .env .env.local; do
  if [[ -f "$PARENT/$f" && ! -f "$f" ]]; then
    echo "→ Copying $f from sibling"
    cp "$PARENT/$f" "$f"
  fi
done

echo
echo "✓ Worktree ready at: $(pwd)"

if [[ $LAUNCH_CLAUDE -eq 1 ]]; then
  if ! command -v claude >/dev/null 2>&1; then
    echo "warning: --claude given but 'claude' not on PATH" >&2
    exit 0
  fi
  echo "→ Launching claude"
  exec claude
else
  echo "  Run: cd $(pwd) && claude"
fi
