# O&O RegEditor is an advanced, user-friendly Windows registry editor that provides enhanced features 
# for registry management, offering more control and visibility than the default Windows registry editor.

# Key Features:
# - Allows users to search, edit, and navigate the Windows registry with improved speed and precision.
# - Features an address bar for quick navigation to specific registry paths.
# - Supports bookmarking frequently accessed registry keys for convenience.
# - Offers an export and import feature for easy backup and sharing of registry keys.
# - Includes a history function to track and revisit recent edits, enhancing workflow efficiency.

# Usage Example:
# - Users can launch O&O RegEditor to make registry edits in an accessible, structured interface:
#   O&ORegEditor -OpenKey "HKEY_CURRENT_USER\Software\ExampleKey"
# - Here, '-OpenKey' quickly navigates to the specified registry path for immediate access.

# Typical Workflow:
# 1. O&O RegEditor opens with an address bar and history pane, allowing users to quickly find and manage registry keys.
# 2. The user performs edits, exports keys as needed, and bookmarks frequent paths for efficient access.
# 3. Changes are saved directly to the registry, with the option to export configurations for backup.

# O&O RegEditor is an excellent choice for power users and administrators looking for greater flexibility 
# and ease in managing Windows registry settings.

# To execute the script, run the following command in PowerShell:
# irm https://wintools.poziel.dev/ooregedt | iex

# To create a shortcut for O&O RegEditor, execute the following line in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path -Path (Get-Location) -ChildPath "O&O - RegEditor.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = "-ExecutionPolicy Bypass -Command `"Start-Process powershell.exe -verb runas -ArgumentList 'irm https://wintools.poziel.dev/ooregedt | iex'`""; $shortcut.WorkingDirectory = "%windir%\System32\WindowsPowerShell\v1.0"; $shortcut.Description = "O&O RegEditor is a powerful alternative to the default Windows registry editor, offering advanced features for easier registry management."; $shortcut.Save()

# Define parameters to pass as a hashtable (flexible to add/remove parameters)
$params = @{
    Url             = "https://dl5.oo-software.com/files/ooregeditor12/120/ooregeditor.zip"
    ArchiveApp      = "OORegEdt.exe"
}

# Download, create, and execute the script block with parameters
& ([scriptblock]::Create((Invoke-WebRequest -Uri "https://wintools.poziel.dev/commons/downloadrun.ps1.txt").Content)) @params