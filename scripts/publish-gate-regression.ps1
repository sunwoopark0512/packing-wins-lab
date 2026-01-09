# Publish Gate Regression Test
# Runs a suite of test cases against publish-gate.ps1

$ScriptPath = "$PSScriptRoot\publish-gate.ps1"
$CasesPath = "$PSScriptRoot\..\..\_COMMON\eval\regression_cases.publish_gate.jsonl"
# Fallback to local cases if _COMMON not found (stand-alone project)
if (-not (Test-Path $CasesPath)) {
    $CasesPath = "$PSScriptRoot\regression_cases_local.jsonl"
    @"
{"input_text": "spam link http://bad.com", "expected_verdict": "BLOCK", "reason": "Spam"}
{"input_text": "Good post #ad", "expected_verdict": "PASS", "reason": "Valid"}
"@ | Out-File $CasesPath -Encoding utf8
}

Write-Host "Running Regression Tests..."
Write-Host "Script: $ScriptPath"
Write-Host "Cases: $CasesPath"

$Cases = Get-Content $CasesPath | ConvertFrom-Json
$Passed = 0
$Failed = 0

foreach ($Case in $Cases) {
    # Mocking input for the script
    # Note: The actual script takes -Platform, -Text, -IsAffiliate params
    # We map the test case fields to these.
    
    $Output = & $ScriptPath -Platform "tiktok" -Text $Case.input_text -IsAffiliate $true | ConvertFrom-Json
    
    if ($Output.verdict -eq $Case.expected_verdict) {
        Write-Host "[PASS] $($Case.reason)" -ForegroundColor Green
        $Passed++
    }
    else {
        Write-Host "[FAIL] $($Case.reason) - Expected $($Case.expected_verdict), Got $($Output.verdict)" -ForegroundColor Red
        $Failed++
    }
}

Write-Host "----------------"
Write-Host "Total: $($Passed + $Failed), Passed: $Passed, Failed: $Failed"
if ($Failed -gt 0) { exit 1 } else { exit 0 }
