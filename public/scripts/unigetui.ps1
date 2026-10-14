# UniGetUI is a user interface for the UniGet package manager, allowing users to find, install, and manage 
# software packages on Windows in a simplified, visual environment.

# Key Features:
# - Provides an intuitive UI for browsing and installing software packages available through UniGet.
# - Supports multiple package sources, ensuring access to a wide variety of software.
# - Allows users to manage installed software, including updating and uninstalling packages as needed.
# - Offers search functionality to quickly locate specific applications.
# - Simplifies package management for users who prefer a graphical interface over command-line operations.

# Usage Example:
# - Running UniGetUI launches a graphical interface for interacting with the UniGet package manager:
#   UniGetUI -Launch
# - Here, '-Launch' opens the interface, where users can browse and install packages.

# Typical Workflow:
# 1. Users open UniGetUI to access the UniGet package manager in a graphical interface.
# 2. They search for, select, and install packages directly from the UI.
# 3. UniGetUI handles the installation process, tracking packages for easy updates and removal.

# UniGetUI is perfect for users who want the functionality of UniGet with the convenience of a graphical interface, 
# making it easy to manage software packages on Windows.

# To execute the script, run the following command in PowerShell:
# irm https://wintools.poziel.dev/unigetui | iex

# To create a shortcut for UniGetUI, execute the following line in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path -Path (Get-Location) -ChildPath "UniGetUI.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = "-ExecutionPolicy Bypass -Command `"Start-Process powershell.exe -verb runas -ArgumentList 'irm https://wintools.poziel.dev/unigetui | iex'`""; $shortcut.WorkingDirectory = "%windir%\System32\WindowsPowerShell\v1.0"; $shortcut.Description = "UniGetUI provides a user-friendly interface for managing software packages with UniGet."; $shortcut.Save()

# Define parameters to pass as a hashtable (flexible to add/remove parameters)
$params = @{
    Url             = "https://github.com/marticliment/UniGetUI"
    GithubMatch     = "UniGetUI.Installer"
    AppArgs         = '/CURRENTUSER /VERYSILENT /PORTABLE /DIR="{installdir}\UniGetUI_Portable"'
}

# Download, create, and execute the script block with parameters
& ([scriptblock]::Create((Invoke-WebRequest -Uri "https://wintools.poziel.dev/commons/downloadrun.ps1.txt").Content)) @params