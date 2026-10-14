# Block Razer Utility Script by Chris Titus Tech is a lightweight PowerShell tool to disable the 
# automatic launch of Razer Synapse software and related services on Windows, minimizing background resource usage.

# Key Features:
# - Disables startup entries for Razer Synapse to prevent it from auto-launching.
# - Stops and disables Razer services running in the background, freeing up system resources.
# - Reversible, allowing users to re-enable Razer services if needed.

# Usage Example:
# - Running the script in a PowerShell terminal immediately halts Razer services:
#   BlockRazerUtility -Disable
# - Using '-Disable' stops and disables all relevant Razer services on startup.

# Typical Workflow:
# 1. The script identifies and disables startup entries and running Razer services.
# 2. Razer software no longer launches on system startup, reducing background processes.

# Block Razer Utility is ideal for users wanting to optimize system performance by preventing 
# unnecessary Razer software from running in the background.

# To execute the script, run the following command in PowerShell:
# irm https://wintools.poziel.dev/blockrazer | iex

# To create a shortcut for Block Razer Utility Script by Chris Titus Tech, execute the following line in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path -Path (Get-Location) -ChildPath "Chris Titus Tech - Block Razer Utility.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = "-ExecutionPolicy Bypass -Command `"Start-Process powershell.exe -verb runas -ArgumentList 'irm https://wintools.poziel.dev/blockrazer | iex'`""; $shortcut.WorkingDirectory = "%windir%\System32\WindowsPowerShell\v1.0"; $shortcut.Description = "Block Razer Utility Script by Chris Titus Tech disables Razer Synapse auto-launch and background services for a lighter startup."; $shortcut.Save()

irm https://raw.githubusercontent.com/ChrisTitusTech/block-razer/main/block.ps1 | iex