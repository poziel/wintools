# HWiNFO is a comprehensive hardware information and diagnostic tool that provides in-depth system 
# information, sensor monitoring, and reporting for Windows systems.

# Key Features:
# - Displays detailed information on system components, including CPU, GPU, memory, and storage.
# - Provides real-time sensor monitoring for temperatures, voltages, and fan speeds.
# - Includes customizable reports for system diagnostics and health checks.
# - Allows users to set alerts and notifications based on sensor thresholds.
# - Supports extensive logging options, enabling users to track performance over time.

# Usage Example:
# - Running HWiNFO allows users to view live hardware stats and save detailed reports:
#   HWiNFO -MonitorSensors -CreateReport
# - Here, '-MonitorSensors' enables live monitoring, while '-CreateReport' generates a full hardware report.

# Typical Workflow:
# 1. HWiNFO scans the system and displays a complete overview of all hardware components.
# 2. Users can monitor real-time data from system sensors or run diagnostics.
# 3. Reports are generated as needed, with options for alerts and historical logging.

# HWiNFO is ideal for users who want detailed visibility into their hardware’s performance and status, 
# making it an essential tool for enthusiasts and professionals.

# To execute the script, run the following command in PowerShell:
# irm https://wintools.poziel.dev/hwinfo | iex

# To create a shortcut for HWiNFO, execute the following line in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path -Path (Get-Location) -ChildPath "HWiNFO.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = "-ExecutionPolicy Bypass -Command `"Start-Process powershell.exe -verb runas -ArgumentList 'irm https://wintools.poziel.dev/hwinfo | iex'`""; $shortcut.WorkingDirectory = "%windir%\System32\WindowsPowerShell\v1.0"; $shortcut.Description = "HWiNFO provides in-depth hardware information and monitoring for system diagnostics."; $shortcut.Save()

# Define parameters to pass as a hashtable (flexible to add/remove parameters)
$params = @{
    Url             = "https://sourceforge.net/projects/hwinfo/files/latest/download"
    Name            = "HWiNFO64\HWiNFO64.zip"
    ArchiveApp      = "HWiNFO64.exe"
}

# Download, create, and execute the script block with parameters
& ([scriptblock]::Create((Invoke-WebRequest -Uri "https://wintools.poziel.dev/commons/downloadrun.ps1.txt").Content)) @params