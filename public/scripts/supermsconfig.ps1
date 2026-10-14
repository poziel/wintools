# SuperMSConfig by Builtbybel is an advanced system configuration tool for Windows that extends the 
# functionality of the classic MSConfig utility, offering more control over startup, services, and system settings.

# Key Features:
# - Provides in-depth management options for startup programs and background services.
# - Allows users to disable, enable, or delay startup items to optimize boot time.
# - Includes tools for managing Windows services with detailed descriptions and recommendations.
# - Offers control over scheduled tasks and other system settings for enhanced performance.
# - Supports exporting and importing configurations for easy system setup and recovery.

# Usage Example:
# - Running SuperMSConfig offers a comprehensive view of startup items and services for customization:
#   SuperMSConfig -ManageStartup -OptimizeBoot
# - Here, '-ManageStartup' enables startup item control, and '-OptimizeBoot' adjusts settings to improve boot performance.

# Typical Workflow:
# 1. SuperMSConfig scans and lists all startup items, services, and scheduled tasks.
# 2. Users manage individual items to enable, disable, or delay based on system requirements.
# 3. Configuration changes are applied, optimizing system performance and startup efficiency.

# SuperMSConfig by Builtbybel is ideal for power users who want enhanced control over their Windows startup 
# and services beyond the basic MSConfig options.

# To execute the script, run the following command in PowerShell:
# irm https://wintools.poziel.dev/supermsconfig | iex

# To create a shortcut for SuperMSConfig by Builtbybel, execute the following line in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path -Path (Get-Location) -ChildPath "Builtbybel - SuperMSConfig.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = "-ExecutionPolicy Bypass -Command `"Start-Process powershell.exe -verb runas -ArgumentList 'irm https://wintools.poziel.dev/supermsconfig | iex'`""; $shortcut.WorkingDirectory = "%windir%\System32\WindowsPowerShell\v1.0"; $shortcut.Description = "SuperMSConfig by Builtbybel is an advanced tool for managing Windows startup, services, and system settings."; $shortcut.Save()

# Define parameters to pass as a hashtable (flexible to add/remove parameters)
$params = @{
    Url             = "https://github.com/builtbybel/SuperMSConfig"
    GithubMatch     = "SuperMSConfig"
}

# Download, create, and execute the script block with parameters
& ([scriptblock]::Create((Invoke-WebRequest -Uri "https://wintools.poziel.dev/commons/downloadrun.ps1.txt").Content)) @params