# Overnight

Installers for Overnight, the app for members of the Overnight community. The app needs a membership: it asks for
your Skool sign-in when it opens. Style packs are not here; the app downloads them for members.

## Windows (64-bit, Windows 10 or 11)

**[Download Overnight for Windows](https://github.com/nnovoselski04/overnight-app-releases/releases/latest/download/Overnight-Setup.exe)**

1. Open the downloaded file.
2. Windows may say "Windows protected your PC". Click **More info**, then **Run anyway**.
3. Overnight installs and opens. Sign in to Skool in it.

Or paste this into PowerShell. It downloads the same installer, checks it, and runs it:

```powershell
irm https://raw.githubusercontent.com/nnovoselski04/overnight-app-releases/main/get-overnight.ps1 | iex
```

## Mac

When a Mac version is out, paste this into Terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/nnovoselski04/overnight-app-releases/main/get-overnight.sh | bash
```

## Let Claude do it

In Claude Code, or another AI agent that can run commands on your computer, paste one of these:

```text
Install Overnight on this computer. The guide is here: https://github.com/nnovoselski04/overnight-app-releases
```

```text
Fix Overnight for me: https://github.com/nnovoselski04/overnight-app-releases
```

The agent reads [FOR-AI-ASSISTANTS.md](FOR-AI-ASSISTANTS.md) and follows it.

## Updates

Overnight updates itself. A new version downloads in the background. It installs only when you press Update now at the top of the window.

## If something is wrong

Run the install command again: it puts the newest Overnight on over the one you have. Your videos, settings and
sign-ins stay. To check a download by hand, each release has `SHA256SUMS.txt`; in PowerShell:
`Get-FileHash .\Overnight-Setup.exe`.

<!-- Copyright (c) 2026 NDX Group. All rights reserved. Overnight is proprietary software: see LICENSE. -->
