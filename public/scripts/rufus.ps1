<#
.SYNOPSIS
Rufus by Akeo Consulting: Create bootable USB drives from Windows, Linux, and recovery ISO images.

.DESCRIPTION
- Write bootable ISO images to USB drives.
- Choose partition scheme and target system.
- Format USB media through the graphical interface.
- Uses the portable x64 release.

Downloads the portable application, waits for it to close, and removes the run's temporary files.

.EXAMPLE
irm https://wintools.poziel.dev/rufus | iex

.NOTES
Select the USB device and ISO, review the settings, and start writing in Rufus. Writing reformats the selected drive. Wait for completion before closing Rufus.
#>

# To create a shortcut, execute the following command in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path (Get-Location) "Rufus.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = '-NoProfile -Command "irm https://wintools.poziel.dev/rufus | iex"'; $shortcut.Save()

$params = @{
    Url         = "https://github.com/pbatard/rufus"
    GithubMatch = "rufus-*p.exe"
    AppAdmin    = $true
}

& ([scriptblock]::Create((Invoke-WebRequest -Uri "https://wintools.poziel.dev/commons/downloadrun.ps1.txt" -UseBasicParsing -ErrorAction Stop).Content)) @params
