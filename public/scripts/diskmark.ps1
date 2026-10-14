# CrystalDiskMark is a disk benchmarking tool that measures the read and write speeds of storage devices, 
# providing detailed performance metrics for HDDs, SSDs, and USB drives.

# Key Features:
# - Performs sequential and random read/write tests to assess drive performance.
# - Supports multiple test sizes and configurations to match different use cases.
# - Displays detailed metrics for each test, including MB/s and IOPS (Input/Output Operations Per Second).
# - Offers customizable test parameters, such as queue depth and test duration.
# - Portable and easy to use, suitable for quick and thorough performance testing.

# Usage Example:
# - Running CrystalDiskMark allows users to benchmark their drive with specific parameters:
#   CrystalDiskMark -TestSize 1GB -QueueDepth 32
# - Here, '-TestSize 1GB' sets the test file size, and '-QueueDepth 32' configures the depth for performance testing.

# Typical Workflow:
# 1. CrystalDiskMark runs a series of read and write tests on the selected drive, displaying results in real time.
# 2. Users review performance metrics to understand the speed capabilities of their storage device.
# 3. Results can be compared over time or used to assess the impact of system changes on storage performance.

# CrystalDiskMark is ideal for users wanting to evaluate the performance of their storage devices 
# and compare metrics between different drives or configurations.

# To execute the script, run the following command in PowerShell:
# irm https://wintools.poziel.dev/diskmark | iex

# To create a shortcut for CrystalDiskMark, execute the following line in PowerShell:
# $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path -Path (Get-Location) -ChildPath "CrystalDiskMark.lnk")); $shortcut.TargetPath = "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"; $shortcut.Arguments = "-ExecutionPolicy Bypass -Command `"Start-Process powershell.exe -verb runas -ArgumentList 'irm https://wintools.poziel.dev/diskmark | iex'`""; $shortcut.WorkingDirectory = "%windir%\System32\WindowsPowerShell\v1.0"; $shortcut.Description = "CrystalDiskMark is a tool for benchmarking storage drive read and write speeds."; $shortcut.Save()

# Define parameters to pass as a hashtable (flexible to add/remove parameters)
$params = @{
    Url             = "https://sourceforge.net/projects/crystaldiskmark/files/latest/download"
    Name            = "crystaldiskmark\crystaldiskmark.zip"
    ArchiveApp      = "DiskMark64.exe"
}

# Download, create, and execute the script block with parameters
& ([scriptblock]::Create((Invoke-WebRequest -Uri "https://wintools.poziel.dev/commons/downloadrun.ps1.txt").Content)) @params