<#
.SYNOPSIS
WinTool - Interactive menu to discover and launch Windows utility scripts

.DESCRIPTION
This script fetches the tools.json catalog and presents an interactive number-based menu
for easy tool discovery and execution.

Type a tool number to launch, L to list commands, Q to quit.

.EXAMPLE
irm https://wintools.poziel.dev/get | iex
Launches the interactive WinTool menu with number-based selection

.EXAMPLE
irm https://wintools.poziel.dev/get | iex -List
Lists all available tools with their commands

.NOTES
Tool information is centrally managed in tools.json
Number-based selection provides a simple, reliable interface
#>

param(
    [switch]$List,      # List all tools without interaction
    [switch]$Simple     # Simple text output instead of interactive menu
)

# Configuration
$ToolsJsonUrl = "https://wintools.poziel.dev/tools.json"

# Function to fetch tools from JSON
function Get-AllTools {
    Write-Host "Loading tool catalog..." -ForegroundColor Cyan
    
    try {
        # Fetch tools.json
        $response = Invoke-RestMethod -Uri $ToolsJsonUrl -ErrorAction Stop
        
        Write-Host "Found $($response.tools.Count) tools!`n" -ForegroundColor Green
        
        # Convert to consistent format with category info
        $tools = $response.tools | ForEach-Object {
            $categoryInfo = $response.categories.($_.category)

            # Fallback if category not found
            if (!$categoryInfo) {
                $categoryInfo = [PSCustomObject]@{
                    name = $_.category
                    icon = "❓"
                    description = "Unknown category"
                }
            }

            [PSCustomObject]@{
                Name = $_.name
                DisplayName = if ($_.vendor) { "$($_.displayName) by $($_.vendor)" } else { $_.displayName }
                ShortDisplayName = $_.displayName
                Vendor = $_.vendor
                Description = $_.description
                Features = $_.features
                CategoryKey = $_.category
                CategoryName = $categoryInfo.name
                CategoryIcon = $categoryInfo.icon
                CategoryDescription = $categoryInfo.description
                Url = $_.url
            }
        }
        
        return $tools | Sort-Object CategoryName, DisplayName
        
    } catch {
        Write-Error "Failed to fetch tool catalog: $_"
        Write-Host "`nNote: This script requires an internet connection to load the tool catalog." -ForegroundColor Yellow
        return @()
    }
}

# Function to display tools grouped by category with interactive selection
function Show-ToolList {
    param([array]$Tools, [switch]$Interactive)

    function DisplayList {
        Clear-Host
        $groupedTools = $Tools | Group-Object -Property CategoryName | Sort-Object Name

        Write-Host "╔═══════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
        Write-Host "║                    WinTool - Available Utilities                          ║" -ForegroundColor Cyan
        Write-Host "╚═══════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
        if ($Interactive) {
            Write-Host "  Type a tool number to copy command, M to return to menu, Q to quit" -ForegroundColor DarkGray
        } else {
            Write-Host "  Press Enter to exit" -ForegroundColor DarkGray
        }

        $toolNumber = 1
        foreach ($group in $groupedTools) {
            $categoryIcon = $group.Group[0].CategoryIcon
            Write-Host "`n  $categoryIcon $($group.Name)" -ForegroundColor Yellow

            # Show category description
            $categoryDesc = $group.Group[0].CategoryDescription
            if ($categoryDesc) {
                Write-Host "  $categoryDesc" -ForegroundColor DarkGray
            }

            foreach ($tool in $group.Group) {
                if ($Interactive) {
                    Write-Host "    $toolNumber. " -NoNewline -ForegroundColor Green
                } else {
                    Write-Host "    • " -NoNewline -ForegroundColor Green
                }
                Write-Host "$($tool.DisplayName)" -ForegroundColor White
                Write-Host "      $($tool.Description)" -ForegroundColor Gray
                Write-Host "      Command: " -NoNewline -ForegroundColor DarkGray
                Write-Host "irm $($tool.Url) | iex" -ForegroundColor Cyan
                if ($Interactive) {
                    $tool | Add-Member -MemberType NoteProperty -Name "Number" -Value $toolNumber -Force
                }
                $toolNumber++
            }
        }

        Write-Host "`n  To run any tool, copy and paste its command, or use: " -ForegroundColor Yellow
        Write-Host "  irm https://wintools.poziel.dev/get | iex" -ForegroundColor Cyan -NoNewline
        Write-Host " (for interactive menu)`n" -ForegroundColor Yellow
    }

    if ($Interactive) {
        while ($true) {
            DisplayList

            $choice = Read-Host "Enter your choice"

            if ($choice -eq 'M' -or $choice -eq 'm') {
                return
            }

            if ($choice -eq 'Q' -or $choice -eq 'q') {
                Clear-Host
                Write-Host "`nExiting WinTool. Goodbye!`n" -ForegroundColor Yellow
                exit
            }

            if ($choice -match '^\d+$') {
                $selectedTool = $Tools | Where-Object { $_.Number -eq [int]$choice }
            } else {
                $selectedTool = $null
            }

            if ($selectedTool) {
                $command = "irm $($selectedTool.Url) | iex"
                Set-Clipboard -Value $command
                Write-Host "`nCopied to clipboard: $command" -ForegroundColor Green
                Start-Sleep -Seconds 2
            } else {
                Write-Host "`nThat's not a valid choice. Please try again." -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    } else {
        DisplayList
        Read-Host "Press Enter to exit"
    }
}

# Function to show interactive menu with number selection
function Show-InteractiveMenu {
    param([array]$Tools)

    while ($true) {
        Clear-Host
        Write-Host "`n╔═══════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
        Write-Host "║                    WinTool - Interactive Menu                             ║" -ForegroundColor Cyan
        Write-Host "╚═══════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  Type a tool number to launch, L to list commands, Q to quit" -ForegroundColor DarkGray

        $groupedTools = $Tools | Group-Object -Property CategoryName | Sort-Object Name
        $toolNumber = 1

        foreach ($group in $groupedTools) {
            $categoryIcon = $group.Group[0].CategoryIcon
            Write-Host "`n  ▶ $($categoryIcon) $($group.Name)" -ForegroundColor Yellow
            if ($group.Group[0].CategoryDescription) {
                Write-Host "    $($group.Group[0].CategoryDescription)" -ForegroundColor DarkGray
            }
            Write-Host ""

            foreach ($tool in $group.Group) {
                Write-Host "    $toolNumber. $($tool.DisplayName)" -ForegroundColor White
                Write-Host "       $($tool.Description)" -ForegroundColor DarkGray
                $tool | Add-Member -MemberType NoteProperty -Name "Number" -Value $toolNumber -Force
                $toolNumber++
            }
        }

        Write-Host ""

        $choice = Read-Host "Enter your choice"

        if ($choice -eq 'Q' -or $choice -eq 'q') {
            Clear-Host
            Write-Host "`nExiting WinTool. Goodbye!`n" -ForegroundColor Yellow
            return
        }

        if ($choice -eq 'L' -or $choice -eq 'l') {
            Show-ToolList -Tools $Tools -Interactive
            continue
        }

        if ($choice -match '^\d+$') {
            $selectedTool = $Tools | Where-Object { $_.Number -eq [int]$choice }
        } else {
            $selectedTool = $null
        }

        if ($selectedTool) {
            Clear-Host
            Write-Host "`n  Launching: $($selectedTool.DisplayName)" -ForegroundColor Green
            Write-Host "  Command: irm $($selectedTool.Url) | iex`n" -ForegroundColor Cyan
            Write-Host "  Executing...`n" -ForegroundColor Yellow

            try {
                & ([scriptblock]::Create((Invoke-WebRequest -Uri $selectedTool.Url -UseBasicParsing).Content))
            } catch {
                Write-Host "`n  Error: $_`n" -ForegroundColor Red
                Read-Host "  Press Enter to continue"
            }
            return
        } else {
            Write-Host "`nThat's not a valid choice. Please try again." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
}

# Main execution
$tools = Get-AllTools

if ($tools.Count -eq 0) {
    Write-Host "No tools found. Please check your internet connection and try again." -ForegroundColor Red
    exit 1
}

# Display based on parameters
if ($List -or $Simple) {
    Show-ToolList -Tools $tools
} else {
    Show-InteractiveMenu -Tools $tools
}