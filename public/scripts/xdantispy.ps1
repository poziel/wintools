# xd-AntiSpy by Builtbybel is a privacy tool for Windows that allows users to disable various telemetry 
# and data collection features, enhancing control over personal data and system privacy.

# Key Features:
# - Disables Windows telemetry, diagnostics, and other data-sharing features.
# - Blocks Microsoft’s data collection servers to prevent external tracking.
# - Allows selective deactivation of Cortana, location tracking, and personalized ads.
# - Includes options for advanced network and firewall settings to further secure data.
# - Offers a simple, checkbox-based interface for easy configuration without deep system adjustments.

# Usage Example:
# - Running xd-AntiSpy lets users apply preferred privacy settings quickly:
#   xdAntiSpy -BlockTelemetry -DisableCortana
# - Here, '-BlockTelemetry' halts data collection services, and '-DisableCortana' deactivates Cortana.

# Typical Workflow:
# 1. xd-AntiSpy scans the system and provides a list of privacy-related options.
# 2. Users select specific items they want to disable to increase privacy.
# 3. Changes are applied immediately, with the option to reverse settings if needed.

# xd-AntiSpy is an effective tool for users focused on maximizing Windows privacy by blocking data collection 
# and limiting tracking features, without complex configurations.

# To execute the script, run the following command in PowerShell:
# irm https://wintools.poziel.dev/xdantispy | iex

# To create a shortcut for xd-AntiSpy by Builtbybel, execute the following line in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path -Path (Get-Location) -ChildPath "Builtbybel - xd-AntiSpy.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = "-ExecutionPolicy Bypass -Command `"Start-Process powershell.exe -verb runas -ArgumentList 'irm https://wintools.poziel.dev/xdantispy | iex'`""; $shortcut.WorkingDirectory = "%windir%\System32\WindowsPowerShell\v1.0"; $shortcut.Description = "xd-AntiSpy by Builtbybel helps users disable telemetry and tracking features on Windows for improved privacy."; $shortcut.Save()

# Define parameters to pass as a hashtable (flexible to add/remove parameters)
$params = @{
    Url             = "https://github.com/builtbybel/xd-AntiSpy"
    GithubMatch     = "xd-AntiSpy.zip"
    ArchiveApp      = "xd-AntiSpy.exe"
}

# Download, create, and execute the script block with parameters
& ([scriptblock]::Create((Invoke-WebRequest -Uri "https://wintools.poziel.dev/commons/downloadrun.ps1.txt").Content)) @params