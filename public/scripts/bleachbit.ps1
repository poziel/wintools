<#
.SYNOPSIS
BleachBit by BleachBit: Clean application caches, temporary files, and browsing traces.

.DESCRIPTION
- Choose which applications and data types to clean.
- Preview selected cleanup operations before deleting files.
- Remove temporary files and application caches.
- Runs from the official portable ZIP without installation.

Downloads the portable application, waits for it to close, and removes the run's temporary files.

.EXAMPLE
irm https://wintools.poziel.dev/bleachbit | iex

.NOTES
Select cleaning options, use Preview to review them, then choose Clean when ready. Deletion is performed only through the application. Close BleachBit when finished.
#>

# To create a shortcut, execute the following command in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path (Get-Location) "BleachBit.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = '-NoProfile -Command "irm https://wintools.poziel.dev/bleachbit | iex"'; $shortcut.Save()

$params = @{
    Url         = "https://github.com/bleachbit/bleachbit"
    GithubMatch = "BleachBit-*-portable.zip"
    ArchiveApp  = "bleachbit.exe"
}

& ([scriptblock]::Create((Invoke-WebRequest -Uri "https://wintools.poziel.dev/commons/downloadrun.ps1.txt" -UseBasicParsing -ErrorAction Stop).Content)) @params
