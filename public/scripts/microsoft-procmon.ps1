# Process Monitor by Microsoft is a real-time monitoring tool that captures detailed events related to file system, 
# registry, and process activity, enabling users to track down and troubleshoot complex system issues.

# Key Features:
# - Monitors and logs file system, registry, network, and process events in real time.
# - Provides filtering options to isolate specific types of events or actions, streamlining troubleshooting.
# - Includes event detail views, showing process information, time stamps, and action results for each event.
# - Allows users to save and export captured data for deeper analysis or future reference.
# - Offers stack trace capture to help diagnose issues at the code or function call level.

# Usage Example:
# - Running Process Monitor initiates real-time event logging, which can be filtered for specific actions:
#   ProcessMonitor -Filter "Registry" -SaveLog "C:\Logs\RegistryMonitor.pml"
# - Here, '-Filter "Registry"' limits output to registry events, and '-SaveLog' exports results for later review.

# Typical Workflow:
# 1. Process Monitor begins logging all specified system events and provides live updates in the interface.
# 2. The user applies filters to focus on relevant event types (e.g., registry access).
# 3. Captured events are reviewed in detail or exported for further analysis, enabling precise troubleshooting.

# Process Monitor is ideal for IT professionals and power users who need granular visibility into 
# system behavior, especially for diagnosing hard-to-find issues in applications or system configurations.

# To execute the script, run the following command in PowerShell:
# irm https://wintools.poziel.dev/microsoft-procmon | iex

# To create a shortcut for Process Monitor by Microsoft, execute the following line in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path -Path (Get-Location) -ChildPath "Microsoft - Process Monitor.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = "-ExecutionPolicy Bypass -Command `"Start-Process powershell.exe -verb runas -ArgumentList 'irm https://wintools.poziel.dev/microsoft-procmon | iex'`""; $shortcut.WorkingDirectory = "%windir%\System32\WindowsPowerShell\v1.0"; $shortcut.Description = "Process Monitor by Microsoft captures real-time file, registry, and process events to aid in system troubleshooting."; $shortcut.Save()

# Define parameters to pass as a hashtable (flexible to add/remove parameters)
$params = @{
    Url             = "https://download.sysinternals.com/files/ProcessMonitor.zip"
    ArchiveApp      = "Procmon.exe"
}

# Download, create, and execute the script block with parameters
& ([scriptblock]::Create((Invoke-WebRequest -Uri "https://wintools.poziel.dev/commons/downloadrun.ps1.txt").Content)) @params