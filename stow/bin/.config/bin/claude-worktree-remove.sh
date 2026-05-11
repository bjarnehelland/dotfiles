#!/usr/bin/env bash
# claude-worktree-remove — WorktreeRemove hook companion to create.
#
# Reads {"path": "<absolute path>"} from stdin. Removes the worktree
# at that path. Forces removal so uncommitted changes don't block —
# Claude Code only invokes this after the user opted into removal.

set -euo pipefail

INPUT=$(cat)
WT_PATH=$(printf '%s' "$INPUT" | jq -r '.path // empty')

if [[ -z "$WT_PATH" ]]; then
  echo "claude-worktree-remove: no path in input" >&2
  exit 1
fi

if [[ ! -d "$WT_PATH" ]]; then
  echo "claude-worktree-remove: '$WT_PATH' does not exist, nothing to do" >&2
  exit 0
fi

echo "→ Removing worktree $WT_PATH" >&2
git -C "$WT_PATH" worktree remove --force "$WT_PATH" >&2

# Best-effort: also delete the auto-created branch.
BRANCH="worktree-$(basename "$WT_PATH")"
if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
  echo "→ Deleting branch $BRANCH" >&2
  git branch -D "$BRANCH" >&2 || true
fi
