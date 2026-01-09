Param(
    [string]$Platform,
    [string]$Text,
    [bool]$IsAffiliate = $false
)

# Write-Host "Running Publish Gate for $Platform..."

# Mock Logic for demonstration
$Verdict = "PASS"
$Reasons = @()

if ($Text -match "spam|buy now") {
    $Verdict = "BLOCK"
    $Reasons += "Spam detected per blocked_keywords."
}

if ($IsAffiliate -and $Text -notmatch "ad|sponsored|partners") {
    $Verdict = "REWRITE"
    $Reasons += "Missing disclosure."
}

if ($Platform -eq "Reddit") {
    # Write-Host "Draft generated for Reddit. Manual approval required."
    $Verdict = "PASS (Draft Only)"
}

$Result = @{
    verdict  = $Verdict
    platform = $Platform
    reasons  = $Reasons
}

$Result | ConvertTo-Json
