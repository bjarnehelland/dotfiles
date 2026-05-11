#!/usr/bin/env bash
# claude-worktree-create — WorktreeCreate hook for bare-worktree layouts.
#
# Reads {"name": "<n>"} from stdin. If the current repo is a bare-worktree
# layout (has .bare/ alongside .git), creates the worktree as a sibling
# directory inside the repo root and prints its path to stdout. Otherwise
# falls back to Claude Code's default location under .claude/worktrees/.
#
# Bootstrap (direnv, bun install, env copy) runs after creation. All
# diagnostic output goes to stderr so it doesn't pollute the path Claude
# Code reads from stdout.

set -euo pipefail

# Read the hook payload. Claude Code passes JSON on stdin.
INPUT=$(cat)
NAME=$(printf '%s' "$INPUT" | jq -r '.name // empty')

if [[ -z "$NAME" ]]; then
  echo "claude-worktree-create: no name in input" >&2
  exit 1
fi

# Find the repo root. If we're inside a worktree of a bare layout,
# `git rev-parse --git-common-dir` points at .bare; its parent is the root.
GIT_COMMON_DIR=$(git rev-parse --git-common-dir 2>/dev/null || echo "")
if [[ -z "$GIT_COMMON_DIR" ]]; then
  echo "claude-worktree-create: not inside a git repo" >&2
  exit 1
fi

# Resolve to absolute path
GIT_COMMON_DIR=$(cd "$GIT_COMMON_DIR" && pwd)

# Detect bare-worktree layout: .git common dir basename is ".bare"
if [[ "$(basename "$GIT_COMMON_DIR")" == ".bare" ]]; then
  ROOT=$(dirname "$GIT_COMMON_DIR")
  DEST="$ROOT/$NAME"
else
  # Not a bare-worktree layout — fall back to default placement under
  # .claude/worktrees/ at the repo top level.
  TOPLEVEL=$(git rev-parse --show-toplevel)
  DEST="$TOPLEVEL/.claude/worktrees/$NAME"
  mkdir -p "$TOPLEVEL/.claude/worktrees"
fi

if [[ -e "$DEST" ]]; then
  echo "claude-worktree-create: '$DEST' already exists" >&2
  exit 1
fi

BRANCH="worktree-$NAME"

echo "→ Creating worktree at $DEST on branch $BRANCH" >&2

# Branch from origin/HEAD if available, otherwise current HEAD.
if git show-ref --verify --quiet refs/remotes/origin/HEAD; then
  git worktree add "$DEST" -b "$BRANCH" origin/HEAD >&2
else
  git worktree add "$DEST" -b "$BRANCH" >&2
fi

# --- Bootstrap ---
# Run in a subshell so we don't change the parent's cwd.
(
  cd "$DEST"

  if [[ -f .envrc ]] && command -v direnv >/dev/null 2>&1; then
    echo "→ direnv allow" >&2
    direnv allow >&2 || true
  fi

  if [[ -f bun.lock || -f bun.lockb ]] && command -v bun >/dev/null 2>&1; then
    echo "→ bun install" >&2
    bun install >&2 || true
  elif [[ -f pnpm-lock.yaml ]] && command -v pnpm >/dev/null 2>&1; then
    echo "→ pnpm install" >&2
    pnpm install >&2 || true
  elif [[ -f package-lock.json ]] && command -v npm >/dev/null 2>&1; then
    echo "→ npm install" >&2
    npm install >&2 || true
  fi
)

# Print the worktree path to stdout. This is the value Claude Code uses
# as the session's working directory — keep it clean (no log lines).
echo "$DEST"
