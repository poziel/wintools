param (
    [string]$Url,
    [string]$Text
)

# Download HTML content from the provided URL
try {
    $htmlContent = Invoke-WebRequest -Uri $url -ErrorAction Stop
} catch {
    Write-Output "Failed to download the page."
    exit
}

# Parse the HTML content
$parsedHtml = $htmlContent.ParsedHtml

# Find all anchor tags with the specified text
$linkFound = $parsedHtml.getElementsByTagName("a") | Where-Object { $_.innerText -eq $text }

# Check if a link was found with the specified text
if ($linkFound) {
    $linkHref = $linkFound.getAttribute("href")

    # Remove any leading "about:" or other unusual prefixes
    $linkHref = $linkHref -replace "^about:", ""

    # Check if the link is relative
    if ($linkHref -and $linkHref -notmatch "^https?://") {
        # Combine the base URL with the relative path to form a complete URL
        $baseUri = New-Object System.Uri($url)
        $linkHref = (New-Object System.Uri($baseUri, $linkHref)).AbsoluteUri
    }
    
    Write-Output $linkHref
} else {
    Write-Output "No link found with the specified text."
}
