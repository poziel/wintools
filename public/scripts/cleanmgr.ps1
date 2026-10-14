# Cleanmgr+ by Builtbybel is a lightweight tool designed to replace and enhance the classic Windows Disk Cleanup utility, 
# offering additional cleanup options and an updated interface for removing unnecessary files and freeing up disk space.

# Key Features:
# - Provides all the cleanup options found in the original Windows Disk Cleanup tool, with added customizations.
# - Allows removal of temporary files, system cache, Windows Update remnants, and more to optimize storage.
# - Includes advanced cleanup for system areas not accessible in the default Disk Cleanup tool.
# - Features a modern and user-friendly interface with checkboxes for easy selection of cleanup options.
# - Offers automation options, allowing scheduled or one-click cleanups for regular maintenance.

# Usage Example:
# - Running Cleanmgr+ gives users access to an expanded cleanup menu, allowing tailored disk cleanup:
#   CleanmgrPlus -Run -Advanced
# - Here, '-Run' initiates a cleanup with the selected options, and '-Advanced' includes additional system areas.

# Typical Workflow:
# 1. Cleanmgr+ scans the system and presents a list of removable file types and cache locations.
# 2. The user selects cleanup categories and initiates the process to free up disk space.
# 3. Cleanmgr+ removes unnecessary files, providing a summary of reclaimed storage.

# Cleanmgr+ is ideal for users seeking a thorough, user-friendly disk cleanup tool with more control 
# and advanced options than the standard Windows utility.

# To execute the script, run the following command in PowerShell:
# irm https://wintools.poziel.dev/cleanmgr | iex

# To create a shortcut for Cleanmgr+ by Builtbybel, execute the following line in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path -Path (Get-Location) -ChildPath "Builtbybel - Cleanmgr+.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = "-ExecutionPolicy Bypass -Command `"Start-Process powershell.exe -verb runas -ArgumentList 'irm https://wintools.poziel.dev/cleanmgr | iex'`""; $shortcut.WorkingDirectory = "%windir%\System32\WindowsPowerShell\v1.0"; $shortcut.Description = "Cleanmgr+ by Builtbybel enhances the classic Windows Disk Cleanup with more options and an intuitive interface for deep cleaning."; $shortcut.Save()

# Define parameters to pass as a hashtable (flexible to add/remove parameters)
$params = @{
    Url             = "https://github.com/builtbybel/CleanmgrPlus"
    GithubMatch     = "cleanmgrplus.zip"
    ArchiveApp      = "Cleanmgr+.exe"
}

# Download, create, and execute the script block with parameters
& ([scriptblock]::Create((Invoke-WebRequest -Uri "https://wintools.poziel.dev/commons/downloadrun.ps1.txt").Content)) @params