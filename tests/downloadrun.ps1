$ErrorActionPreference = 'Stop'
$runner = Join-Path $PSScriptRoot '../public/commons/downloadrun.ps1'
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ('wintools-test-' + [guid]::NewGuid())
New-Item -ItemType Directory -Path $testRoot | Out-Null
$testState = @{ Launches = @(); DownloadFailure = $false; MissingExecutable = $false }

function Assert($condition, $message) {
    if (-not $condition) { throw $message }
}

function Invoke-WebRequest {
    param($Uri, $OutFile, [switch]$UseBasicParsing, $ErrorAction)
    if ($testState.DownloadFailure) { throw 'Simulated download failure' }
    if ($OutFile -like '*.zip') {
        $fixture = Join-Path $testRoot 'fixture'
        New-Item -ItemType Directory -Path (Join-Path $fixture 'nested') -Force | Out-Null
        $filename = if ($testState.MissingExecutable) { 'readme.txt' } else { 'app.exe' }
        Set-Content -LiteralPath (Join-Path $fixture "nested/$filename") -Value 'dummy; never executed'
        Compress-Archive -Path "$fixture/*" -DestinationPath $OutFile
        Remove-Item -LiteralPath $fixture -Recurse -Force
    } else {
        Set-Content -LiteralPath $OutFile -Value 'dummy; never executed'
    }
}

function Invoke-RestMethod {
    param($Uri, $Headers, $ErrorAction)
    return @{ assets = @(@{ name = 'Optimizer-16.7.exe'; browser_download_url = 'https://example.test/Optimizer-16.7.exe' }) }
}

function Start-Process {
    param($FilePath, $WorkingDirectory, $ArgumentList, $Verb, $ErrorAction, [switch]$Wait)
    Assert (Test-Path -LiteralPath $FilePath -PathType Leaf) 'Executable path must exist at launch'
    Assert $Wait 'Runner must wait before cleanup'
    $testState.Launches += @{ Path = $FilePath; Folder = $WorkingDirectory; Args = $ArgumentList; Verb = $Verb }
}

try {
    $sentinel = Join-Path $testRoot 'keep.txt'
    Set-Content -LiteralPath $sentinel -Value 'unrelated file'
    & $runner -Url 'https://example.test/ProcessMonitor.zip' -Tmp $testRoot -ArchiveApp app.exe | Out-Null
    Assert ($testState.Launches[-1].Path -like '*nested*app.exe') 'Use the full nested executable path'
    Assert (-not (Test-Path -LiteralPath $testState.Launches[-1].Folder)) 'Default cleanup must remove run folder'

    & $runner -Url 'https://example.test/latest/download' -Name 'HWiNFO64/HWiNFO64.zip' -Tmp $testRoot -ArchiveApp app.exe -NoCleanup | Out-Null
    $retained = $testState.Launches[-1].Folder
    Assert (Test-Path -LiteralPath $retained) 'NoCleanup must retain files'

    & $runner -Url 'https://github.com/hellzerg/optimizer' -Tmp $testRoot -AppAdmin -AppArgs '/DIR="{installdir}"' | Out-Null
    Assert ($testState.Launches[-1].Path -like '*Optimizer-16.7.exe') 'Default GitHub match must select an asset'
    Assert ($testState.Launches[-1].Verb -eq 'RunAs') 'Preserve elevation'
    Assert ($testState.Launches[-1].Args -eq ('/DIR="' + $testState.Launches[-1].Folder + '"')) 'Expand arguments without regex escaping'

    & $runner -Url 'https://github.com/vendor/tool/releases/download/v1/tool.exe?download=1' -Tmp $testRoot | Out-Null
    Assert ($testState.Launches[-1].Path -like '*tool.exe') 'Direct release URL must remain direct and omit query from filename'

    $before = $testState.Launches.Count
    $testState.DownloadFailure = $true
    try { & $runner -Url 'https://example.test/app.exe' -Tmp $testRoot | Out-Null; throw 'Expected download failure' }
    catch { Assert ($_.Exception.Message -eq 'Simulated download failure') 'Preserve download error' }
    $testState.DownloadFailure = $false
    $testState.MissingExecutable = $true
    try { & $runner -Url 'https://example.test/app.zip' -Tmp $testRoot -ArchiveApp app.exe | Out-Null; throw 'Expected missing executable' }
    catch { Assert ($_.Exception.Message -like 'No file matching*') 'Report missing executable' }
    Assert ($testState.Launches.Count -eq $before) 'Failed downloads or extraction must not launch'
    Assert (Test-Path -LiteralPath $sentinel) 'Preserve unrelated files'
    Assert (Test-Path -LiteralPath $retained) 'Later runs must preserve retained downloads'
    Assert (@(Get-ChildItem -LiteralPath $testRoot -Directory).Count -eq 1) 'Failed runs must clean their own folders'
    Write-Output "Runner regression checks passed on PowerShell $($PSVersionTable.PSVersion)"
} finally {
    if ($testRoot -and (Split-Path $testRoot -Leaf) -like 'wintools-test-*') {
        Remove-Item -LiteralPath $testRoot -Recurse -Force
    }
}
