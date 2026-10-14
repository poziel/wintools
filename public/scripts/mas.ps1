

# To execute the script, run the following command in PowerShell:
# irm https://wintools.poziel.dev/mas | iex

# To create a shortcut for Microsoft Activation Scripts by MASSGRAVE, execute the following line in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path -Path (Get-Location) -ChildPath "MASSGRAVE - Microsoft Activation Scripts.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = "-ExecutionPolicy Bypass -Command `"Start-Process powershell.exe -verb runas -ArgumentList 'irm https://wintools.poziel.dev/mas | iex'`""; $shortcut.WorkingDirectory = "%windir%\System32\WindowsPowerShell\v1.0"; $shortcut.Description = "Microsoft Activation Scripts (MAS) by MASSGRAVE is a script suite for activating Windows and Office products with flexible options."; $shortcut.Save()

irm https://get.activated.win | iex