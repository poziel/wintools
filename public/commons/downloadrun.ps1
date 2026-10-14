<#
.SYNOPSIS
Downloads an executable from a specified URL or GitHub repository and runs it, with optional cleanup.

.DESCRIPTION
The `downloadrun` function downloads a file from either a direct URL or the latest release of a GitHub repository.
It then executes a specified file inside the downloaded or uncompressed contents and optionally cleans up afterward.

.EXAMPLE
downloadrun -url "https://github.com/username/repository" -tmp "C:\CustomTemp" -match "specificfile.exe"
Downloads `specificfile.exe` from the latest release of the specified GitHub repo, stores it in "C:\CustomTemp", and executes it.

.EXAMPLE
& ([scriptblock]::Create((Invoke-WebRequest -Uri "https://wintools.poziel.dev/commons/downloadrun.ps1.txt").Content)) @params
Calls the `downloadrun` script remotely with parameters stored in the `@params` hashtable.
#>

param (
    [string]$Url,                       # The URL of the file or GitHub repository in the format "owner/repo"
    [string]$Name = $null,              # Optional. Specifies the name for the executable folder. Defaults to the downloaded file name if omitted
    [string]$Tmp = "$env:TEMP\`$tmp",   # Optional. Specifies a temporary folder to store the downloaded executable. Defaults to the system temporary folder
    [string]$GithubMatch = "*",         # Optional. Specifies a pattern to match the file on the GitHub page or URL
    [string]$ArchiveApp = "*",          # Optional. Specifies the name of the file to execute within the archive. Defaults to the first `.exe` file found
    [string]$AppArgs = $null,           # Optional. A string of arguments to pass to the executable upon execution
    [switch]$AppAdmin,                  # Optional. If specified, starts the program with administrator privileges
    [switch]$NoCleanup,                 # Optional. If specified, don't deletes the program folder after execution
    [switch]$Wait                       # Optional. If specified, waits for user input before exiting
)

function ExtractFiles {
    param (
        [string]$Source,        # Path to the compressed file
        [string]$Destination    # Path to extract contents to
    )

    # Ensure destination directory exists
    if (!(Test-Path -Path $Destination)) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }

    # Determine file extension and handle accordingly
    switch -regex ($Source) {
        "\.zip$" {
            Write-Output "Uncompressing ZIP file..."
            Expand-Archive -Path $Source -DestinationPath $Destination -Force
        }
        "\.tar$" {
            Write-Output "Uncompressing TAR file..."
            Expand-TarFile -tarFilePath $Source -destinationPath $Destination
        }
        "\.tar\.gz$" {
            Write-Output "Uncompressing TAR.GZ file..."
            $tempTar = Join-Path -Path $Destination -ChildPath "temp.tar"
            [System.IO.Compression.CompressionFileExtensions]::ExtractToDirectory($Source, $Destination)
            Expand-TarFile -tarFilePath $tempTar -destinationPath $Destination
            Remove-Item -Path $tempTar -Force
        }
        "\.tar\.bz2$" {
            Write-Output "Uncompressing TAR.BZ2 file..."
            $tempTar = Join-Path -Path $Destination -ChildPath "temp.tar"
            # Use an external tool or library here for .bz2 if available
            # Extract the TAR file within
            [System.IO.Compression.ZipFile]::ExtractToDirectory($Source, $Destination)
            Remove-Item -Path $tempTar -Force
        }
        "\.(7z|s7z|iso|jar|phar|war|wim|xar|rar)$" {
            # This method would work if 7-Zip is installed on the system, but as the principle
            # is to be portable, it's commented out. If 7-Zip is available, uncomment the following lines:

            # Write-Output "Uncompressing $($Source | Split-Path -Leaf) using 7-Zip..."
            # $7zipPath = "C:\Program Files\7-Zip\7z.exe" # Change this if 7z.exe is located elsewhere
            # & $7zipPath x $Source -o"$Destination" -aoa | Out-Null
            throw "Unsupported file type: $Source"
        }
        default {
            throw "Unsupported file type: $Source"
        }
    }
}

# Generate the Unix timestamp and unique ID
$timestamp = [math]::Round((New-TimeSpan -Start (Get-Date -Date "1970-01-01 00:00:00Z") -End (Get-Date).ToUniversalTime()).TotalSeconds).ToString()
$uuid = [guid]::NewGuid().ToString()

# Validate URL
if (-not $Url) {
    Write-Output "Error: The 'url' parameter is required."
    return
}

# Check if the temp folder exists; create it if necessary
if (!(Test-Path -Path $Tmp)) {
    # Create the folder
    New-Item -ItemType Directory -Path $Tmp -Force | Out-Null
    
    # Set the folder attribute to 'Hidden'
    (Get-Item -Path $Tmp).Attributes = 'Hidden'
}

# Replace custom variables in the arguments
$Tmp = $Tmp -replace "\{tmp\}", [regex]::Escape($env:TEMP)
$Tmp = $Tmp -replace "\{timestamp\}", [regex]::Escape($timestamp)
$Tmp = $Tmp -replace "\{uuid\}", [regex]::Escape($uuid)

# Set error handling
try {
    # Check if the URL points to a GitHub repository or a direct URL
    if ($Url -match "^https://github\.com/([^/]+)/([^/]+)") {
        $repoOwner = $matches[1]
        $repoName = $matches[2]
        $apiUrl = "https://api.github.com/repos/$repoOwner/$repoName/releases/latest"
        
        Write-Output "Fetching latest release information from GitHub for $repoOwner/$repoName..."
        # Retrieve latest release information from GitHub
        $response = Invoke-RestMethod -Uri $apiUrl -Headers @{ "User-Agent" = "PowerShell" }

        # Filter assets based on the 'match' pattern for GitHub
        $asset = $response.assets | Where-Object { $_.name -match "^$GithubMatch(\..+)?$" } | Select-Object -First 1
        if ($null -eq $asset) {
            Write-Output "No file matching '$GithubMatch' found in the latest release for $repoOwner/$repoName. Exiting."
            return
        }

        $downloadUrl = $asset.browser_download_url
        Write-Output "Matched file URL: $downloadUrl"

    } else {
        # Assume it's a direct URL
        $downloadUrl = $Url
        Write-Output "Using provided URL: $downloadUrl"
    }

    # # Set the app folder name based on the provided `name` or derive from the download URL
    # if (-not $Name) {
    #     $Name = ([System.IO.Path]::GetFileNameWithoutExtension($downloadUrl) -replace '[^a-zA-Z0-9]', '')
    # }
    # $Name = $Name -replace "\{timestamp\}", [regex]::Escape($timestamp)
    # $Name = $Name -replace "\{uuid\}", [regex]::Escape($uuid)

    # # Define the folder and path for the executable
    # $appFolder = Join-Path -Path $Tmp -ChildPath $Name
    # $appPath = Join-Path -Path $appFolder -ChildPath ([System.IO.Path]::GetFileName($downloadUrl))

    # Parse `$ArchiveApp` to determine folder and file names
    if ($Name -match "\\|/") {
        # If `$Name` includes a path (e.g., "hwinfo\latest" or "hwinfo\app.zip")
        $folderName = Split-Path -Path $Name -Parent
        $fileName = Split-Path -Path $Name -Leaf
    } else {
        # If `$Name` only specifies a name without path separators
        $folderName = $null
        $fileName = $Name
    }

    # Set folder name based on `$Name` or fallback to calculated name from `$downloadUrl`
    if ($folderName) {
        $Name = $folderName
    } elseif (-not $Name) {
        $Name = ([System.IO.Path]::GetFileNameWithoutExtension($downloadUrl) -replace '[^a-zA-Z0-9]', '')
    }

    # Apply replacements for `{timestamp}` and `{uuid}` in `$Name` if they exist
    $Name = $Name -replace "\{timestamp\}", [regex]::Escape($timestamp)
    $Name = $Name -replace "\{uuid\}", [regex]::Escape($uuid)

    # Define `$appFolder` and `$appPath`
    $appFolder = Join-Path -Path $Tmp -ChildPath $Name

    # Set file name based on `$fileName` or fallback to default from `$downloadUrl`
    Write-Output "File name: $fileName"
    if ($fileName -and $fileName -ne "*") {
        if ($fileName -like "*.") {
            # If `$fileName` ends with `.*`, retain the original file extension from the download URL
            $defaultExtension = [System.IO.Path]::GetExtension($downloadUrl)
            $appPath = Join-Path -Path $appFolder -ChildPath ($fileName.TrimEnd('.') + $defaultExtension)
        } else {
            # Use `$fileName` as-is
            $appPath = Join-Path -Path $appFolder -ChildPath $fileName
        }
    } else {
        # Default to the original downloaded file name
        $appPath = Join-Path -Path $appFolder -ChildPath ([System.IO.Path]::GetFileName($downloadUrl))
    }

    # Log the application name at the top of the script
    $length = 100 
    $padding = [Math]::Max(0, ($length - $Name.Length) / 2)
    $centeredName = (' ' * [Math]::Floor($padding)) + $Name + (' ' * [Math]::Ceiling($padding))
    Write-Output ""
    Write-Output ('-' * $length)
    Write-Output $centeredName
    Write-Output ('-' * $length)
    Write-Output ""

    # Delete the existing folder if it exists then create a new folder
    if (Test-Path -Path $appFolder) {
        Write-Output "Folder already exists. Deleting existing folder..."
        Remove-Item -Path $appFolder -Recurse -Force
    }
    New-Item -ItemType Directory -Path $appFolder -Force | Out-Null

    # Download the file to the specified folder with progress bar
    Write-Output "Downloading file from $downloadUrl to $appPath..."
    Start-BitsTransfer -Source $downloadUrl -Destination $appPath

    # Check if the downloaded file is a compressed file
    if ($appPath -match "\.zip$") {
        ExtractFiles -Source $appPath -Destination $appFolder

        # Determine file to execute based on `$ArchiveApp`
        if ($ArchiveApp -ne "*") {
            # If `$ArchiveApp` is specified, find the specified file recursively in the uncompressed folder
            $targetFile = Get-ChildItem -Path $appFolder -Recurse -Filter $ArchiveApp | Select-Object -First 1
            if (-not $targetFile) {
                Write-Error "No file matching '$ArchiveApp' was found in the extracted files."
                return
            }
        } else {
            # If `$ArchiveApp` is not specified, find the first executable file (.exe)
            $targetFile = Get-ChildItem -Path $appFolder -Recurse -Filter "*.exe" | Select-Object -First 1
            if (-not $targetFile) {
                Write-Error "No executable file found in the extracted files."
                return
            }
        }
        $targetFile = Join-Path -Path $appFolder -ChildPath $targetFile
    } else {
        # If it's not a compressed file, set the downloaded path as the target file
        $targetFile = $appPath
    }

    # Run the determined file with optional arguments
    $startArgs = @{
        FilePath = $targetFile
        Wait = $true
    }
    if ($AppArgs) {
        $AppArgs = $AppArgs -replace "\{tmp\}", [regex]::Escape($env:TEMP)
        $AppArgs = $AppArgs -replace "\{installdir\}", [regex]::Escape($appFolder)
        $startArgs.ArgumentList = $AppArgs
    }
    if ($AppAdmin) {
        $startArgs.Verb = "RunAs"
    }
    Write-Output "Executing the file: $targetFile"
    Start-Process @startArgs

} catch {
    Write-Error "An error occurred: $_"
} finally {

    # Optional cleanup step
    if ($NoCleanup) {
        Write-Output "Cleaning up..."
        Remove-Item -Path $appFolder -Recurse -Force | Out-Null

        # Check if $Tmp directory is empty and delete if necessary
        if ((Test-Path -Path $Tmp) -and !(Get-ChildItem -Path $Tmp -Recurse | Measure-Object).Count) {
            Write-Output "Temporary directory is empty. Deleting $Tmp..."
            Remove-Item -Path $Tmp -Force | Out-Null
        }
    }
}

# Wait at the end if requested
if ($Wait) {
    Write-Output "Press Enter to exit..."
    Read-Host
    return
}