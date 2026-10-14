# Optimizer by Hellzerg is a versatile tool for optimizing Windows systems, providing options to 
# disable unnecessary services, remove bloatware, improve performance, and enhance user privacy.

# Key Features:
# - Disables telemetry, data collection, and other background services that may impact privacy.
# - Removes pre-installed Windows apps and bloatware to free up system resources.
# - Configures system settings for performance improvements, including disabling animations and startup delays.
# - Offers a built-in firewall management tool to restrict unwanted connections.
# - Portable and open-source, making it easy to customize and use on multiple systems.

# Usage Example:
# - Running Optimizer allows users to select from various optimization options:
#   Optimizer -DisableTelemetry -RemoveBloat
# - Here, '-DisableTelemetry' disables data collection, while '-RemoveBloat' removes pre-installed apps.

# Typical Workflow:
# 1. Optimizer scans the system and lists available options for privacy, performance, and bloatware removal.
# 2. Users select the tasks they wish to perform, such as disabling telemetry or optimizing settings.
# 3. The tool applies the selected changes, resulting in a leaner and more privacy-conscious setup.

# Optimizer by Hellzerg is ideal for users looking for a one-stop tool to enhance system performance 
# and privacy on Windows with minimal configuration.

# To execute the script, run the following command in PowerShell:
# irm https://wintools.poziel.dev/optimizer | iex

# To create a shortcut for Optimizer by Hellzerg, execute the following line in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path -Path (Get-Location) -ChildPath "Hellzerg - Optimizer.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = "-ExecutionPolicy Bypass -Command `"Start-Process powershell.exe -verb runas -ArgumentList 'irm https://wintools.poziel.dev/optimizer | iex'`""; $shortcut.WorkingDirectory = "%windir%\System32\WindowsPowerShell\v1.0"; $shortcut.Description = "Optimizer by Hellzerg is a tool for enhancing Windows privacy, removing bloatware, and optimizing performance."; $shortcut.Save()

# Define parameters to pass as a hashtable (flexible to add/remove parameters)
$params = @{
    Url             = "https://github.com/hellzerg/optimizer"
}

# Download, create, and execute the script block with parameters
& ([scriptblock]::Create((Invoke-WebRequest -Uri "https://wintools.poziel.dev/commons/downloadrun.ps1.txt").Content)) @params