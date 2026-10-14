<#
.SYNOPSIS
WizTree by Antibody Software: Visual disk space analyzer for finding large files and folders.

.DESCRIPTION
- Scan disk usage and inspect a visual treemap.
- Sort files and folders by size.
- Export scan results for later comparison.
- Portable x64 version; free for personal use.

Downloads the portable application, waits for it to close, and removes the run's temporary files.

.EXAMPLE
irm https://wintools.poziel.dev/wiztree | iex

.NOTES
Select a drive, scan its contents, and inspect the largest files. Close WizTree when finished.
#>

# To create a shortcut, execute the following command in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path (Get-Location) "WizTree.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = '-NoProfile -Command "irm https://wintools.poziel.dev/wiztree | iex"'; $shortcut.Save()

$params = @{
    Url        = "https://diskanalyzer.com/files/wiztree_4_33_portable.zip"
    ArchiveApp = "WizTree64.exe"
}

& ([scriptblock]::Create((Invoke-WebRequest -Uri "https://wintools.poziel.dev/commons/downloadrun.ps1.txt" -UseBasicParsing -ErrorAction Stop).Content)) @params
