# CPU-Z is a lightweight system profiling tool that provides detailed information on the CPU, 
# motherboard, memory, and other hardware components of a Windows system.

# Key Features:
# - Displays detailed CPU information, including core architecture, clock speed, cache levels, and more.
# - Shows motherboard specifications, such as model, chipset, and BIOS version.
# - Provides memory module details, including type, size, and speed.
# - Includes real-time monitoring of CPU core frequencies and voltage.
# - Portable and easy to use for quick system diagnostics and hardware identification.

# Usage Example:
# - Running CPU-Z gives users a comprehensive view of CPU and system specs:
#   CPU-Z -ShowCPUInfo
# - Here, '-ShowCPUInfo' displays detailed processor information for quick review.

# Typical Workflow:
# 1. CPU-Z scans and displays hardware specifications for the CPU, motherboard, memory, and graphics.
# 2. Users can navigate tabs to view detailed component information and monitor live CPU stats.
# 3. Results can be used for system analysis, upgrade planning, or troubleshooting hardware issues.

# CPU-Z is ideal for users looking to understand their hardware components in detail 
# or monitor CPU behavior for diagnostics and performance assessment.

# To execute the script, run the following command in PowerShell:
# irm https://wintools.poziel.dev/cpuz | iex

# To create a shortcut for CPU-Z, execute the following line in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path -Path (Get-Location) -ChildPath "CPU-Z.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = "-ExecutionPolicy Bypass -Command `"Start-Process powershell.exe -verb runas -ArgumentList 'irm https://wintools.poziel.dev/cpuz | iex'`""; $shortcut.WorkingDirectory = "%windir%\System32\WindowsPowerShell\v1.0"; $shortcut.Description = "CPU-Z provides detailed information on the CPU, motherboard, and memory components of a Windows system."; $shortcut.Save()

# Define parameters to pass as a hashtable (flexible to add/remove parameters)
$params = @{
    Url             = "https://download.cpuid.com/cpu-z/cpu-z_2.12-en.zip"
    ArchiveApp      = "cpuz_x64.exe"
}

# Download, create, and execute the script block with parameters
& ([scriptblock]::Create((Invoke-WebRequest -Uri "https://wintools.poziel.dev/commons/downloadrun.ps1.txt").Content)) @params