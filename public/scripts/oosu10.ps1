# O&O ShutUp10++ is a privacy-focused utility for Windows that allows users to control and disable 
# telemetry, tracking, and data-sharing features in Windows 10 and Windows 11, enhancing user privacy.

# Key Features:
# - Provides granular options to disable Windows telemetry, data collection, and personalized ads.
# - Allows users to turn off location tracking, feedback requests, and activity history.
# - Offers a one-click “Recommended Settings” option for quick privacy setup.
# - Allows for easy rollback of changes to restore default settings if needed.
# - Completely portable, requiring no installation and making it easy to use on multiple systems.

# Usage Example:
# - Running O&O ShutUp10++ allows users to select recommended privacy settings:
#   OOSU10 -ApplyRecommended
# - Here, '-ApplyRecommended' applies a set of suggested privacy configurations.

# Typical Workflow:
# 1. O&O ShutUp10++ scans the system and presents a list of privacy settings that can be adjusted.
# 2. Users choose to enable or disable specific settings or apply recommended defaults.
# 3. The tool applies changes, which can be reversed if needed for flexibility.

# O&O ShutUp10++ is an essential tool for privacy-conscious users who want to control data-sharing 
# and tracking features on Windows systems without complex configurations.

# To execute the script, run the following command in PowerShell:
# irm https://wintools.poziel.dev/oosu10 | iex

# To create a shortcut for O&O ShutUp10++, execute the following line in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path -Path (Get-Location) -ChildPath "O&O - ShutUp10++.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = "-ExecutionPolicy Bypass -Command `"Start-Process powershell.exe -verb runas -ArgumentList 'irm https://wintools.poziel.dev/oosu10 | iex'`""; $shortcut.WorkingDirectory = "%windir%\System32\WindowsPowerShell\v1.0"; $shortcut.Description = "O&O ShutUp10++ is a privacy tool for Windows that disables telemetry and tracking features to protect user privacy."; $shortcut.Save()

# Define parameters to pass as a hashtable (flexible to add/remove parameters)
$params = @{
    Url             = "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe"
}

# Download, create, and execute the script block with parameters
& ([scriptblock]::Create((Invoke-WebRequest -Uri "https://wintools.poziel.dev/commons/downloadrun.ps1.txt").Content)) @params