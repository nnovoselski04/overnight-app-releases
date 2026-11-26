# Guide for an AI agent: install or repair Overnight

You were asked to install Overnight, or to fix an Overnight that does not work. Overnight is a desktop app. Its
installers are the release files of this repository. Follow these steps and tell the person what you did in plain,
short sentences.

## Rules

- Do not use administrator rights. Overnight installs for the signed-in user.
- Never delete or change the person's data: `%APPDATA%\Overnight` on Windows, `~/Library/Application Support/Overnight`
  on a Mac, and their videos folder. Installing again keeps all of it.
- Download only from `github.com/nnovoselski04/overnight-app-releases` and
  `raw.githubusercontent.com/nnovoselski04/overnight-app-releases`.
- Do not ask for, read or type the person's passwords or Skool sign-in. They sign in themselves, inside the app.

## Windows

1. Check it is 64-bit Windows 10 or 11 and that the drive holding `%TEMP%` and `%LOCALAPPDATA%` has 6 GB free.
2. Save the script, read it, then run it:
   ```powershell
   $d = Join-Path $env:TEMP 'overnight-agent'; New-Item -ItemType Directory -Force $d | Out-Null
   curl.exe -fsSL -o "$d\get-overnight.ps1" https://raw.githubusercontent.com/nnovoselski04/overnight-app-releases/main/get-overnight.ps1
   powershell -NoProfile -ExecutionPolicy Bypass -File "$d\get-overnight.ps1"
   ```
   The download is about 1.2 GB, so give the command at least 30 minutes before you call it stuck.
3. The script ends with "Overnight is installed and opens by itself." Anything else ends with a `[STOP]` line that
   says why and what to do. Tell the person that line.

The same steps repair an installed Overnight: the script puts the newest version on over it.

## Mac

```bash
curl -fsSL https://raw.githubusercontent.com/nnovoselski04/overnight-app-releases/main/get-overnight.sh | bash
```

If it says there is no Mac version out yet, tell the person so and stop.

## What a `[STOP]` line means

| Line | Cause | What to do |
|---|---|---|
| The newest Overnight could not be read from github.com | Offline, or github.com is blocked | Check `curl.exe -I https://github.com`, then run again |
| The download did not finish | The connection was cut | Run again: it carries on where it stopped |
| The download does not match the release | Antivirus web scanning or a proxy changed the file | Run again; if it repeats, ask the person to pause web scanning |
| Drive has ... free | Not enough disk space | Ask the person what to free; do not delete their files yourself |
| The installer stopped (code N) | The installer failed | Run again once; if it repeats, give the person the window's text to post in the Overnight community |

## After installing

Overnight opens and asks for the person's Skool sign-in. They do that themselves. The app then sets up the tools it
needs by itself.

<!-- Copyright (c) 2026 NDX Group. All rights reserved. Overnight is proprietary software: see LICENSE. -->
