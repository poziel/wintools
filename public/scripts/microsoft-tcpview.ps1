<#
.SYNOPSIS
TCPView by Microsoft Sysinternals: Inspect TCP and UDP endpoints and the processes that own them.

.DESCRIPTION
- Display local and remote addresses and ports.
- Identify the process associated with each endpoint.
- Highlight connection changes as the view refreshes.
- Save connection listings for troubleshooting.

Downloads the portable application, waits for it to close, and removes the run's temporary files.

.EXAMPLE
irm https://wintools.poziel.dev/microsoft-tcpview | iex

.NOTES
Review the live connection list and identify the process or port of interest. Close TCPView when finished.
#>

# To create a shortcut, execute the following command in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path (Get-Location) "TCPView.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = '-NoProfile -Command "irm https://wintools.poziel.dev/microsoft-tcpview | iex"'; $shortcut.Save()

$params = @{
    Url        = "https://download.sysinternals.com/files/TCPView.zip"
    ArchiveApp = "tcpview64.exe"
}

& ([scriptblock]::Create((Invoke-WebRequest -Uri "https://wintools.poziel.dev/commons/downloadrun.ps1.txt" -UseBasicParsing -ErrorAction Stop).Content)) @params
