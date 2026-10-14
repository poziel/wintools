# O&O AppBuster is a free Windows tool that helps users manage and remove unwanted pre-installed applications, 
# or "bloatware," from Windows 10 and Windows 11 systems. This includes system apps, bundled apps, 
# and other installed software that may not be easily uninstallable through regular settings.

# Key Features:
# - Lists all pre-installed apps on a Windows system, including hidden and protected system apps.
# - Allows selective removal of unwanted applications, including bundled software and unnecessary system apps.
# - Supports reinstallation of previously removed apps in case they are needed later.
# - Provides an overview of app usage, helping users decide which apps to keep or remove.
# - Offers "Undo" functionality, allowing users to restore removed apps.

# Usage Example:
# - Running O&O AppBuster allows users to go through a list of installed applications and 
#   select which to uninstall for a cleaner, leaner system.
# - Users can also remove specific system apps, which are not usually accessible via regular uninstallation.

# Typical Workflow:
# 1. O&O AppBuster scans the system for all installed applications and displays them in a categorized list.
# 2. The user reviews the applications and selects unwanted ones for removal.
# 3. O&O AppBuster uninstalls the selected apps and updates the list, with an option to restore if needed.

# O&O AppBuster is ideal for users looking to declutter their Windows experience by removing unnecessary 
# or unwanted apps, freeing up system resources, and enhancing system performance.

# To execute the script, run the following command in PowerShell:
# irm https://wintools.poziel.dev/ooapb | iex

# To create a shortcut for O&O AppBuster, execute the following line in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path -Path (Get-Location) -ChildPath "O&O - AppBuster.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = "-ExecutionPolicy Bypass -Command `"Start-Process powershell.exe -verb runas -ArgumentList 'irm https://wintools.poziel.dev/ooapb | iex'`""; $shortcut.WorkingDirectory = "%windir%\System32\WindowsPowerShell\v1.0"; $shortcut.Description = "O&O AppBuster helps users remove pre-installed bloatware and system apps on Windows for a cleaner, more efficient system."; $shortcut.Save()

# Define parameters to pass as a hashtable (flexible to add/remove parameters)
$params = @{
    Url             = "https://dl5.oo-software.com/files/ooappbuster/OOAPB.exe"
}

# Download, create, and execute the script block with parameters
& ([scriptblock]::Create((Invoke-WebRequest -Uri "https://wintools.poziel.dev/commons/downloadrun.ps1.txt").Content)) @params