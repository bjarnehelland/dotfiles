#!/usr/bin/env bash
# Back up Elgato Stream Deck profiles into the dotfiles repo.
#
# Produces streamdeck/profiles.streamDeckProfilesBackup — the same zip format
# the Stream Deck app writes from Preferences -> Profiles -> Backup, so it can
# be restored with the app's own "Restore" button. See streamdeck/README.md.
set -euo pipefail

SD_DIR="$HOME/Library/Application Support/com.elgato.StreamDeck"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$REPO_DIR/streamdeck/profiles.streamDeckProfilesBackup"

# The app bumps this suffix on schema migrations (ProfilesV2 -> ProfilesV3 in
# app v7). Fail loudly rather than silently backing up a directory the app has
# stopped reading.
PROFILES_DIR="$SD_DIR/ProfilesV3"
if [ ! -d "$PROFILES_DIR" ]; then
	echo "error: $PROFILES_DIR not found." >&2
	echo "Stream Deck has likely migrated to a new profile schema. Check for a" >&2
	echo "ProfilesV4 (or later) directory in $SD_DIR and update this script." >&2
	exit 1
fi

if pgrep -qx "Stream Deck"; then
	echo "note: Stream Deck is running; quit it first if you just made changes"
	echo "      that have not been flushed to disk."
fi

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

mkdir -p "$STAGE/Profiles" "$STAGE/Resources"
rsync -a --exclude '.DS_Store' "$PROFILES_DIR"/ "$STAGE/Profiles"/
if [ -f "$SD_DIR/Resources/manifest.json" ]; then
	cp -p "$SD_DIR/Resources/manifest.json" "$STAGE/Resources/manifest.json"
else
	printf '{\n  "resources": null\n}' >"$STAGE/Resources/manifest.json"
fi

# Everything above preserves source mtimes, but the two staged parents are
# created fresh each run. Pin them so an unchanged profile set re-zips to the
# same bytes and does not show up as a repo change.
touch -t 202001010000.00 "$STAGE/Profiles" "$STAGE/Resources"

mkdir -p "$(dirname "$OUT")"
rm -f "$OUT"
# -X drops uid/gid and extra timestamp fields, so an unchanged profile set
# produces a byte-identical archive and the repo stays clean.
(cd "$STAGE" && zip -q -r -X -0 "$OUT" Resources Profiles)

echo "Wrote $OUT"
find "$STAGE/Profiles" -maxdepth 2 -name manifest.json -print0 |
	while IFS= read -r -d '' f; do
		python3 - "$f" <<-'PY'
			import json, sys
			d = json.load(open(sys.argv[1]))
			print(f"  {d.get('Device', {}).get('Model', '?')}: {d.get('Name', '?')}")
		PY
	done
