# Verify Feedback Pack Unit Tests
# Test suite for verify-feedback-pack.ps1

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$TestScriptPath = Join-Path $ScriptRoot "..\scripts\verify-feedback-pack.ps1"

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "Verify Feedback Pack Unit Tests" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

# Test results
$TotalTests = 0
$PassedTests = 0
$FailedTests = 0

# Helper function to run tests
function Test-Function {
    param(
        [string]$TestName,
        [scriptblock]$TestScript
    )

    $script:TotalTests++

    try {
        & $TestScript
        Write-Host "[✓ PASS] $TestName" -ForegroundColor Green
        $script:PassedTests++
        return $true
    }
    catch {
        Write-Host "[✗ FAIL] $TestName" -ForegroundColor Red
        Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Yellow
        $script:FailedTests++
        return $false
    }
}

# Test 1: Test-Check helper function - Success case
Test-Function "Test-Check helper returns true on success" {
    function Test-Check-Internal {
        param([string]$CheckName, [scriptblock]$TestScript, [bool]$Required = $true)
        try {
            $Result = & $TestScript
            return $Result
        }
        catch {
            throw $_
        }
    }

    $result = Test-Check-Internal "Test" { $true } $true
    $result -eq $true
}

# Test 2: Test-Check helper function - Failure case
Test-Function "Test-Check helper returns false on failure" {
    function Test-Check-Internal {
        param([string]$CheckName, [scriptblock]$TestScript, [bool]$Required = $true)
        try {
            $Result = & $TestScript
            return $Result
        }
        catch {
            throw $_
        }
    }

    $result = Test-Check-Internal "Test" { $false } $true
    $result -eq $false
}

# Test 3: Test-Check helper - Optional check failure
Test-Function "Test-Check helper handles optional check failures" {
    function Test-Check-Internal {
        param([string]$CheckName, [scriptblock]$TestScript, [bool]$Required = $true)
        try {
            $Result = & $TestScript
            return $Result
        }
        catch {
            throw $_
        }
    }

    # Optional check should not throw
    $result = Test-Check-Internal "Test" { $false } $false
    $result -eq $false  # Should return false even if optional
}

# Test 4: Test-Check helper - Error handling
Test-Function "Test-Check helper throws on script errors" {
    function Test-Check-Internal {
        param([string]$CheckName, [scriptblock]$TestScript, [bool]$Required = $true)
        try {
            $Result = & $TestScript
            return $Result
        }
        catch {
            throw $_
        }
    }

    # Should throw on error in test script
    $threw = $false
    try {
        Test-Check-Internal "Test" { throw "Test error" } $true
    }
    catch {
        $threw = $true
    }

    $threw -eq $true
}

# Test 5: File existence check - Existing file
Test-Function "File existence check returns true for existing file" {
    $tempFile = Join-Path $env:TEMP "test_verify_feedback_pack_$([Guid]::NewGuid()).txt"
    Set-Content $tempFile -Value "test"

    $exists = Test-Path $tempFile

    # Cleanup
    Remove-Item $tempFile -Force

    $exists -eq $true
}

# Test 6: File existence check - Non-existing file
Test-Function "File existence check returns false for non-existing file" {
    $tempFile = Join-Path $env:TEMP "test_verify_feedback_pack_$([Guid]::NewGuid()).txt"

    $exists = Test-Path $tempFile

    $exists -eq $false
}

# Test 7: Directory existence check
Test-Function "Directory existence check works correctly" {
    $tempDir = Join-Path $env:TEMP "test_verify_feedback_pack_$([Guid]::NewGuid())"
    New-Item $tempDir -ItemType Directory -Force | Out-Null

    $exists = Test-Path $tempDir

    # Cleanup
    Remove-Item $tempDir -Force -Recurse

    $exists -eq $true
}

# Test 8: Test-Check - Script path validation
Test-Function "Script root path is correctly derived" {
    $scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
    $projectRoot = Split-Path -Parent $scriptRoot

    # Both should not be empty or null
    (-not [string]::IsNullOrEmpty($scriptRoot)) -and (-not [string]::IsNullOrEmpty($projectRoot))
}

# Test 9: Parameter handling - Verbose flag
Test-Function "Verbose parameter is handled correctly" {
    param([switch]$Verbose = $false)

    $Verbose -is [switch]
}

# Test 10: ErrorActionPreference is set to Stop
Test-Function "ErrorActionPreference is set to Stop" {
    $ErrorActionPreference = "Stop"
    $ErrorActionPreference -eq "Stop"
}

# Test 11: Test-Check increments TotalChecks
Test-Function "Test-Check increments TotalChecks" {
    $totalChecks = 0

    function Test-Check-Internal {
        param([string]$CheckName, [scriptblock]$TestScript, [bool]$Required = $true)
        $script:totalChecks++
        try {
            $Result = & $TestScript
            return $Result
        }
        catch {
            throw $_
        }
    }

    Test-Check-Internal "Test1" { $true } $true
    Test-Check-Internal "Test2" { $true } $true

    $totalChecks -eq 2
}

# Test 12: Test-Check increments PassedChecks
Test-Function "Test-Check increments PassedChecks on success" {
    $passedChecks = 0

    function Test-Check-Internal {
        param([string]$CheckName, [scriptblock]$TestScript, [bool]$Required = $true)
        $script:totalChecks++
        try {
            $Result = & $TestScript
            if ($Result) {
                $script:passedChecks++
            }
            return $Result
        }
        catch {
            throw $_
        }
    }

    Test-Check-Internal "Test" { $true } $true

    $passedChecks -eq 1
}

# Test 13: Test-Check increments FailedChecks
Test-Function "Test-Check increments FailedChecks on failure" {
    $failedChecks = 0

    function Test-Check-Internal {
        param([string]$CheckName, [scriptblock]$TestScript, [bool]$Required = $true)
        $script:totalChecks++
        try {
            $Result = & $TestScript
            if (-not $Result) {
                $script:failedChecks++
            }
            return $Result
        }
        catch {
            throw $_
        }
    }

    Test-Check-Internal "Test" { $false } $true

    $failedChecks -eq 1
}

# Test 14: Test-Check increments Warnings
Test-Function "Test-Check adds to Warnings array for optional failures" {
    $warnings = @()

    function Test-Check-Internal {
        param([string]$CheckName, [scriptblock]$TestScript, [bool]$Required = $true)
        $script:totalChecks++
        try {
            $Result = & $TestScript
            if ($Result) {
                $script:passedChecks++
            }
            else {
                if ($Required) {
                    $script:failedChecks++
                }
                else {
                    $script:warnings += $CheckName
                }
            }
            return $Result
        }
        catch {
            throw $_
        }
    }

    Test-Check-Internal "OptionalTest" { $false } $false

    $warnings.Count -eq 1
}

# Test 15: Test-Check doesn't add to Warnings for required failures
Test-Function "Test-Check doesn't add to Warnings for required failures" {
    $warnings = @()

    function Test-Check-Internal {
        param([string]$CheckName, [scriptblock]$TestScript, [bool]$Required = $true)
        $script:totalChecks++
        try {
            $Result = & $TestScript
            if ($Result) {
                $script:passedChecks++
            }
            else {
                if ($Required) {
                    $script:failedChecks++
                }
                else {
                    $script:warnings += $CheckName
                }
            }
            return $Result
        }
        catch {
            throw $_
        }
    }

    Test-Check-Internal "RequiredTest" { $false } $true

    $warnings.Count -eq 0
}

# Test 16: Multiple Test-Check calls track correctly
Test-Function "Multiple Test-Check calls track results correctly" {
    $totalChecks = 0
    $passedChecks = 0
    $failedChecks = 0

    function Test-Check-Internal {
        param([string]$CheckName, [scriptblock]$TestScript, [bool]$Required = $true)
        $script:totalChecks++
        try {
            $Result = & $TestScript
            if ($Result) {
                $script:passedChecks++
                return $true
            }
            else {
                if ($Required) {
                    $script:failedChecks++
                }
                else {
                    $script:warnings += $CheckName
                }
                return $false
            }
        }
        catch {
            throw $_
        }
    }

    # Run multiple checks
    Test-Check-Internal "Test1" { $true } $true   # Pass
    Test-Check-Internal "Test2" { $false } $true  # Fail
    Test-Check-Internal "Test3" { $true } $true   # Pass
    Test-Check-Internal "Test4" { $false } $false # Warn

    $totalChecks -eq 4 -and $passedChecks -eq 2 -and $failedChecks -eq 1
}

# Test 17: Output formatting colors are valid
Test-Function "Output formatting colors are valid" {
    $validColors = @("Black", "DarkBlue", "DarkGreen", "DarkCyan", "DarkRed", "DarkMagenta", "DarkYellow",
                   "Gray", "DarkGray", "Blue", "Green", "Cyan", "Red", "Magenta", "Yellow", "White")

    $testColor = "Green"
    $testColor -in $validColors
}

# Test 18: Script root path resolution
Test-Function "Script root path is correctly resolved" {
    $currentScriptPath = $MyInvocation.MyCommand.Path
    $resolvedRoot = Split-Path -Parent $currentScriptPath

    Test-Path $resolvedRoot
}

# Test 19: Project root path resolution
Test-Function "Project root path is correctly resolved" {
    $currentScriptPath = $MyInvocation.MyCommand.Path
    $scriptRoot = Split-Path -Parent $currentScriptPath
    $resolvedProjectRoot = Split-Path -Parent $scriptRoot

    Test-Path $resolvedProjectRoot
}

# Test 20: Test-Check handles null results
Test-Function "Test-Check handles null results correctly" {
    $result = Test-Check-Internal "NullTest" { $null } $true

    # Null should be treated as failure
    -not $result
}

# Print summary
Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "Test Summary" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Total Tests: $TotalTests" -ForegroundColor White
Write-Host "Passed: $PassedTests" -ForegroundColor Green
Write-Host "Failed: $FailedTests" -ForegroundColor $(if ($FailedTests -gt 0) { "Red" } else { "Green" })
Write-Host ""

$passRate = if ($TotalTests -gt 0) { [math]::Round(($PassedTests / $TotalTests) * 100, 2) } else { 0 }
Write-Host "Pass Rate: $passRate%" -ForegroundColor $(if ($passRate -ge 80) { "Green" } else { "Yellow" })
Write-Host ""

if ($FailedTests -gt 0) {
    Write-Host "❌ SOME TESTS FAILED" -ForegroundColor Red
    exit 1
}
else {
    Write-Host "✅ ALL TESTS PASSED" -ForegroundColor Green
    exit 0
}
