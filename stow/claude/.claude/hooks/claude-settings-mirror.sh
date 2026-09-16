#!/bin/sh
# Mirror ~/.claude/settings.json into the dotfiles repo, minus machine-local state.
#
# Claude Code owns ~/.claude/settings.json and rewrites it (atomically) whenever
# plugins are toggled or auto mode updates its learned config. That replaces any
# stow symlink with a real file, so the repo cannot be the source of truth for it.
# Instead the repo holds a filtered mirror, refreshed by a SessionEnd hook.
#
# Stripped: autoMode (Claude-Code-learned, scoped to whichever project taught it).
# Kept: permissions, env, enabledPlugins, model, statusLine, hooks -- real
# preferences worth reproducing on a new machine.

set -eu

live="$HOME/.claude/settings.json"
[ -f "$live" ] || exit 0

# Resolve this script through its stow symlink to find the repo.
self="$0"
while [ -L "$self" ]; do
  link="$(readlink "$self")"
  case "$link" in
    /*) self="$link" ;;
    *)  self="$(dirname "$self")/$link" ;;
  esac
done
repo="$(cd "$(dirname "$self")/../../../.." && pwd)"
dest="$repo/stow/claude/.claude/settings.json"
[ -d "$(dirname "$dest")" ] || exit 0

command -v python3 >/dev/null 2>&1 || exit 0

CLAUDE_MIRROR_LIVE="$live" CLAUDE_MIRROR_DEST="$dest" python3 - <<'PY'
import collections, json, os, sys

live = os.environ["CLAUDE_MIRROR_LIVE"]
dest = os.environ["CLAUDE_MIRROR_DEST"]

try:
    with open(live) as f:
        data = json.load(f, object_pairs_hook=collections.OrderedDict)
except (OSError, ValueError):
    sys.exit(0)

# Machine-local / project-scoped keys that should not travel in the repo.
for key in ("autoMode",):
    data.pop(key, None)

new = json.dumps(data, indent=2) + "\n"

try:
    with open(dest) as f:
        if f.read() == new:
            sys.exit(0)
except OSError:
    pass

tmp = dest + ".tmp"
with open(tmp, "w") as f:
    f.write(new)
os.replace(tmp, dest)
PY
