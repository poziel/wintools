# Windows Utility by Chris Titus Tech is a comprehensive PowerShell-based tool designed to optimize, 
# debloat, and customize Windows systems for improved performance, security, and user experience.

# Key Features:
# - Offers automated scripts for system cleanup, including removing bloatware and unnecessary background services.
# - Includes options for privacy and security enhancements, such as disabling telemetry and unwanted tracking features.
# - Allows customization of system settings for optimal performance, like tweaking power options and disabling visual effects.
# - Supports bulk uninstallation of pre-installed apps and bundled software, freeing up system resources.
# - Provides advanced network and firewall settings for enhanced security and control.

# Usage Example:
# - Users can run Windows Utility in a PowerShell terminal and select various options from a menu-based interface:
#   WindowsUtility -Debloat -Optimize -SecurityEnhancements
# - Here, '-Debloat' removes unnecessary apps, '-Optimize' applies performance settings, 
#   and '-SecurityEnhancements' configures additional privacy protections.

# Typical Workflow:
# 1. Windows Utility scans the system and presents a menu of available tasks.
# 2. The user selects tasks like debloating, performance tweaks, and security enhancements.
# 3. Windows Utility applies the selected settings and provides a summary of actions taken.

# Windows Utility is ideal for users looking to streamline and secure their Windows setup, 
# giving them better performance and more control over their system environment.

# To execute the script, run the following command in PowerShell:
# irm https://wintools.poziel.dev/winutils | iex

# To create a shortcut for Windows Utility by Chris Titus Tech, execute the following line in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path -Path (Get-Location) -ChildPath "Chris Titus Tech - Windows Utility.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = "-ExecutionPolicy Bypass -Command `"Start-Process powershell.exe -verb runas -ArgumentList 'irm https://wintools.poziel.dev/winutils | iex'`""; $shortcut.WorkingDirectory = "%windir%\System32\WindowsPowerShell\v1.0"; $shortcut.Description = "Windows Utility by Chris Titus Tech is a PowerShell tool for optimizing, debloating, and securing Windows systems."; $shortcut.Save()

irm https://christitus.com/win | iex