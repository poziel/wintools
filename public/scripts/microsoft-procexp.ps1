# Process Explorer by Microsoft is an advanced task manager utility that provides in-depth insight 
# into active processes and system resource usage, allowing users to monitor, analyze, and manage system performance.

# Key Features:
# - Displays a hierarchical view of all running processes, with detailed information on resource consumption.
# - Allows users to view specific process attributes, including CPU, memory, and I/O usage, as well as active threads and handles.
# - Supports real-time monitoring and identification of resource-intensive processes.
# - Features a powerful search tool to locate which processes are using specific files or DLLs.
# - Includes process killing and suspension options for direct control over unwanted or problematic processes.

# Usage Example:
# - Running Process Explorer offers an interface to monitor and manage system processes effectively:
#   ProcessExplorer -MonitorCPU -ViewDetails
# - Here, '-MonitorCPU' shows CPU usage per process, and '-ViewDetails' reveals detailed information on each process.

# Typical Workflow:
# 1. Process Explorer lists all running processes with a tree view showing parent-child relationships.
# 2. Users can click on processes to view extensive details or suspend/kill them if needed.
# 3. Real-time metrics help in identifying performance bottlenecks or troubleshooting specific system issues.

# Process Explorer is a go-to tool for users and IT professionals needing deeper insight into system activity, 
# offering more control and detail than the standard Windows Task Manager.

# To execute the script, run the following command in PowerShell:
# irm https://wintools.poziel.dev/microsoft-procexp | iex

# To create a shortcut for Process Explorer by Microsoft, execute the following line in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path -Path (Get-Location) -ChildPath "Microsoft - Process Explorer.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = "-ExecutionPolicy Bypass -Command `"Start-Process powershell.exe -verb runas -ArgumentList 'irm https://wintools.poziel.dev/microsoft-procexp | iex'`""; $shortcut.WorkingDirectory = "%windir%\System32\WindowsPowerShell\v1.0"; $shortcut.Description = "Process Explorer by Microsoft is a task management utility offering detailed insights into system processes and resource usage."; $shortcut.Save()

# Define parameters to pass as a hashtable (flexible to add/remove parameters)
$params = @{
    Url             = "https://download.sysinternals.com/files/ProcessExplorer.zip"
    ArchiveApp      = "procexp.exe"
}

# Download, create, and execute the script block with parameters
& ([scriptblock]::Create((Invoke-WebRequest -Uri "https://wintools.poziel.dev/commons/downloadrun.ps1.txt").Content)) @params