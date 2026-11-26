# Copyright (c) 2026 NDX Group. All rights reserved. Overnight is proprietary software: see LICENSE.
# Installs or repairs Overnight on 64-bit Windows 10 or 11, for the signed-in user. No administrator rights.
#   irm https://raw.githubusercontent.com/nnovoselski04/overnight-app-releases/main/get-overnight.ps1 | iex
# It downloads the newest installer, checks it against the release's SHA-256 list, and runs it.
# Your videos, settings and sign-ins are not touched.
# OVERNIGHT_INSTALL_FROM: tests only, another address that holds SHA256SUMS.txt and Overnight-Setup.exe.
# OVERNIGHT_INSTALL_DRY: tests only, download and check but do not run the installer.
& {
    $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
    $ProgressPreference = 'SilentlyContinue'
    $latest = 'https://github.com/nnovoselski04/overnight-app-releases/releases/latest/download'
    if ($env:OVERNIGHT_INSTALL_FROM) { $latest = $env:OVERNIGHT_INSTALL_FROM.TrimEnd('/') }
    $name = 'Overnight-Setup.exe'
    function Stop-Here([string]$why, [string]$next) {
        Write-Host ''
        Write-Host "[STOP] $why" -ForegroundColor Red
        if ($next) { Write-Host "       $next" }
        throw 'Overnight was not installed.'
    }
    if (-not [Environment]::Is64BitOperatingSystem) { Stop-Here 'Overnight needs 64-bit Windows.' '' }
    try { [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12 } catch { }
    $dir = Join-Path $env:TEMP 'overnight-install'
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $file = Join-Path $dir $name
    $sumsFile = Join-Path $dir 'SHA256SUMS.txt'

    Write-Host 'Looking up the newest Overnight...'
    try { Invoke-WebRequest -UseBasicParsing -Uri "$latest/SHA256SUMS.txt" -OutFile $sumsFile }
    catch { Stop-Here 'The newest Overnight could not be read from github.com.' 'Check that github.com opens in your browser, then run the same command again.' }
    $want = $null
    foreach ($line in Get-Content -LiteralPath $sumsFile) {
        if ($line -match '^([0-9a-fA-F]{64})\s+\*?(.+?)\s*$' -and $Matches[2] -eq $name) { $want = $Matches[1].ToUpper() }
    }
    if (-not $want) { Stop-Here 'The release has no checksum for the installer, so nothing was downloaded.' 'Run the same command again in a few minutes.' }

    $have = $null
    if (Test-Path -LiteralPath $file) { $have = (Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash }
    if ($have -ne $want) {
        $drive = $dir.Substring(0, 1)
        $free = (Get-PSDrive -Name $drive).Free
        if ($free -lt 6GB) { Stop-Here ("Drive {0}: has {1:N1} GB free and the install needs about 6 GB." -f $drive, ($free / 1GB)) 'Free some space, then run the same command again.' }
        Write-Host 'Downloading Overnight (about 1.2 GB). A download that was cut carries on where it stopped.'
        $curl = Join-Path $env:SystemRoot 'System32\curl.exe'
        if (Test-Path -LiteralPath $curl) {
            & $curl -fL --retry 5 --retry-delay 3 -C - -o $file "$latest/$name"
            if ($LASTEXITCODE -ne 0) {
                Remove-Item -LiteralPath $file -Force -ErrorAction SilentlyContinue
                & $curl -fL --retry 5 --retry-delay 3 -o $file "$latest/$name"
            }
            if ($LASTEXITCODE -ne 0) { Stop-Here 'The download did not finish.' 'Check the internet connection, then run the same command again.' }
        } else {
            try { Invoke-WebRequest -UseBasicParsing -Uri "$latest/$name" -OutFile $file }
            catch { Stop-Here 'The download did not finish.' 'Check the internet connection, then run the same command again.' }
        }
        $have = (Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash
    }
    if ($have -ne $want) {
        Remove-Item -LiteralPath $file -Force -ErrorAction SilentlyContinue
        Stop-Here 'The download does not match the release, so it was deleted and not run.' 'An antivirus or a proxy may have changed it. Run the same command again.'
    }
    if ($env:OVERNIGHT_INSTALL_DRY) { Write-Host "Checked: $file matches the release. Test mode, so it was not run."; return }

    $open = @(Get-Process -Name 'Overnight' -ErrorAction SilentlyContinue)
    if ($open.Count -gt 0) { Write-Host 'Overnight is open. The installer closes it; unsaved typing in a chat box is lost.' }
    Write-Host 'Installing Overnight. This takes a few minutes.'
    $p = Start-Process -FilePath $file -ArgumentList '/S', '--force-run' -PassThru -Wait
    if ($p.ExitCode -ne 0) { Stop-Here "The installer stopped (code $($p.ExitCode))." 'Run the same command again. If it stops again, post this window in the Overnight community.' }
    Remove-Item -LiteralPath $dir -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host ''
    Write-Host 'Overnight is installed and opens by itself. Sign in to Skool in it to start.' -ForegroundColor Green
}
