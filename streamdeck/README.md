# Stream Deck profiles

`profiles.streamDeckProfilesBackup` is a full export of all Stream Deck
profiles, in the app's own backup format (a zip of `Profiles/` + `Resources/`).

Unlike the rest of this repo, Stream Deck is **not** managed with stow. The app
rewrites its profile directory on every edit and renames it wholesale on schema
migrations — `ProfilesV2` became `ProfilesV3` in app v7, which silently
orphaned the old symlink and left this repo holding dead data for months. A
snapshot you take deliberately is harder to get wrong.

## Back up

```sh
make streamdeck
```

Quit Stream Deck first if you have just made changes, so they are flushed to
disk. The archive is byte-reproducible, so re-running with no profile changes
leaves the repo clean. Commit the result.

## Restore

In the Stream Deck app: **Preferences → Profiles**, then use the
backup/restore control and pick `profiles.streamDeckProfilesBackup`.

If the app's restore is unavailable or refuses the file, install it by hand:

```sh
SD="$HOME/Library/Application Support/com.elgato.StreamDeck"
osascript -e 'quit app "Stream Deck"'
mkdir -p "$SD/ProfilesV3"
unzip -o streamdeck/profiles.streamDeckProfilesBackup 'Profiles/*' -d /tmp/sdrestore
cp -R /tmp/sdrestore/Profiles/. "$SD/ProfilesV3/"
open -a "Elgato Stream Deck"
```

## Caveats

- Profiles reference plugins by ID but do not contain them. Plugins live in
  `com.elgato.StreamDeck/Plugins/` and are installed separately from the
  Marketplace; buttons for a missing plugin restore as blank.
- Profiles are bound to a device model (currently `20GBA9901`, `UI Stream Deck`
  and `AI Stream Deck`). Restoring onto different hardware will not map them.
- `scripts/streamdeck-backup.sh` hardcodes `ProfilesV3`. It fails loudly rather
  than silently backing up nothing if Elgato migrates the schema again — if
  that happens, update the path in the script.
