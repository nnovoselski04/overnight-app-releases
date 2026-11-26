#!/bin/bash
# Copyright (c) 2026 NDX Group. All rights reserved. Overnight is proprietary software: see LICENSE.
# Installs or repairs Overnight on a Mac.
#   curl -fsSL https://raw.githubusercontent.com/nnovoselski04/overnight-app-releases/main/get-overnight.sh | bash
# It downloads the newest Overnight for this Mac's chip and puts it in Applications.
# Your videos, settings and sign-ins are not touched.
set -u
LATEST='https://github.com/nnovoselski04/overnight-app-releases/releases/latest/download'
stop() { printf '\n[STOP] %s\n' "$1" >&2; exit 1; }
[ "$(uname -s)" = Darwin ] || stop 'This script is for a Mac. On Windows use get-overnight.ps1.'
if [ "$(uname -m)" = arm64 ] || [ "$(sysctl -n sysctl.proc_translated 2>/dev/null)" = 1 ]; then DMG='Overnight-Mac-AppleChip.dmg'; else DMG='Overnight-Mac-Intel.dmg'; fi
DL="$(mktemp -d "${TMPDIR:-/tmp}/overnight-install.XXXXXX")" || stop 'A temporary folder could not be made.'
MNT="$DL/mount"
cleanup() { hdiutil detach "$MNT" -quiet 2>/dev/null; rm -rf "$DL"; }
trap cleanup EXIT
echo "Downloading Overnight for this Mac ($DMG)..."
curl -fL --retry 5 --retry-delay 3 -o "$DL/$DMG" "$LATEST/$DMG" || stop 'The download did not finish, or there is no Mac version out yet. Check the internet connection and run the same command again.'
mkdir -p "$MNT"
hdiutil attach "$DL/$DMG" -nobrowse -readonly -mountpoint "$MNT" -quiet || stop 'The download could not be opened. Run the same command again.'
[ -d "$MNT/Overnight.app" ] || stop 'The download does not hold Overnight. Nothing was changed.'
if pgrep -x Overnight >/dev/null 2>&1; then echo 'Overnight is open: closing it.'; osascript -e 'tell application "Overnight" to quit' >/dev/null 2>&1; sleep 3; fi
echo 'Putting Overnight in Applications...'
if [ -d /Applications/Overnight.app ]; then mv /Applications/Overnight.app "$DL/old.app" || stop 'The Overnight in Applications could not be replaced. Quit Overnight and run the same command again.'; fi
if ! ditto "$MNT/Overnight.app" /Applications/Overnight.app; then
  rm -rf /Applications/Overnight.app
  [ -d "$DL/old.app" ] && mv "$DL/old.app" /Applications/Overnight.app
  stop 'Overnight could not be copied into Applications. The one you had is back.'
fi
open /Applications/Overnight.app
echo 'Overnight is installed and open. Sign in to Skool in it to start.'
