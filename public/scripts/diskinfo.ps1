# CrystalDiskInfo is a disk health monitoring tool that provides detailed information about 
# storage drives, including temperature, health status, and S.M.A.R.T. (Self-Monitoring, Analysis, and Reporting Technology) attributes.

# Key Features:
# - Monitors and displays health status, temperature, and detailed S.M.A.R.T. information for HDDs and SSDs.
# - Provides real-time alerts for potential drive issues to help prevent data loss.
# - Includes power-on hours, reallocated sector count, and other metrics for in-depth drive analysis.
# - Supports customizable alert thresholds for specific attributes.
# - Portable and easy to use, making it accessible for quick diagnostics.

# Usage Example:
# - Running CrystalDiskInfo provides users with real-time health and performance metrics for their storage devices:
#   CrystalDiskInfo -MonitorHealth -AlertThreshold 80
# - Here, '-MonitorHealth' displays health data, and '-AlertThreshold 80' sets an alert at 80% of the defined thresholds.

# Typical Workflow:
# 1. CrystalDiskInfo scans connected storage drives and displays health, temperature, and S.M.A.R.T. attributes.
# 2. Users review health indicators and configure alerts for specific thresholds if needed.
# 3. Regular monitoring helps detect early signs of drive failure, enabling timely action to prevent data loss.

# CrystalDiskInfo is ideal for users who want to monitor the health and performance of their storage drives 
# and receive alerts about potential issues.

# To execute the script, run the following command in PowerShell:
# irm https://wintools.poziel.dev/diskinfo | iex

# To create a shortcut for CrystalDiskInfo, execute the following line in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path -Path (Get-Location) -ChildPath "CrystalDiskInfo.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = "-ExecutionPolicy Bypass -Command `"Start-Process powershell.exe -verb runas -ArgumentList 'irm https://wintools.poziel.dev/diskinfo | iex'`""; $shortcut.WorkingDirectory = "%windir%\System32\WindowsPowerShell\v1.0"; $shortcut.Description = "CrystalDiskInfo is a tool for monitoring storage drive health and S.M.A.R.T. attributes."; $shortcut.Save()

# Define parameters to pass as a hashtable (flexible to add/remove parameters)
$params = @{
    Url             = "https://sourceforge.net/projects/crystaldiskinfo/files/latest/download"
    Name            = "crystaldiskinfo\crystaldiskinfo.zip"
    ArchiveApp      = "DiskInfo64.exe"
}

# Download, create, and execute the script block with parameters
& ([scriptblock]::Create((Invoke-WebRequest -Uri "https://wintools.poziel.dev/commons/downloadrun.ps1.txt").Content)) @params