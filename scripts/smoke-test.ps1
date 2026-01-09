Write-Host "Running Smoke Test..."
if (Test-Path "$PSScriptRoot\..\package.json") {
    Write-Host "[PASS] package.json found"
    exit 0
}
else {
    Write-Host "[FAIL] package.json missing"
    exit 1
}
