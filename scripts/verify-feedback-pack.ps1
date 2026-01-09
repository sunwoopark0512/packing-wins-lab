# Verify Feedback Pack v1.1.1
# This script validates all components of the Feedback Playbook v1.1.1 package

param(
    [switch]$Verbose = $false
)

$ErrorActionPreference = "Stop"
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptRoot

$VerboseFlag = if ($Verbose) { "-Verbose" } else { "" }

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "Feedback Playbook v1.1.1 Verification Script" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

# Track results
$TotalChecks = 0
$PassedChecks = 0
$FailedChecks = 0
$Warnings = @()

# Helper function
function Test-Check {
    param(
        [string]$CheckName,
        [scriptblock]$TestScript,
        [bool]$Required = $true
    )

    $script:TotalChecks++

    try {
        $Result = & $TestScript

        if ($Result) {
            Write-Host "[✓ PASS] $CheckName" -ForegroundColor Green
            $script:PassedChecks++
            return $true
        }
        else {
            if ($Required) {
                Write-Host "[✗ FAIL] $CheckName" -ForegroundColor Red
                $script:FailedChecks++
                return $false
            }
            else {
                Write-Host "[⚠ WARN] $CheckName" -ForegroundColor Yellow
                $script:Warnings += $CheckName
                return $true
            }
        }
    }
    catch {
        Write-Host "[✗ ERROR] $CheckName - $($_.Exception.Message)" -ForegroundColor Red
        if ($Required) {
            $script:FailedChecks++
            return $false
        }
        else {
            $script:Warnings += $CheckName
            return $true
        }
    }
}

Write-Host "1. Checking Core Documentation..." -ForegroundColor Cyan
Write-Host "-----------------------------------" -ForegroundColor Cyan

Test-Check "RUNBOOK.md exists" {
    Test-Path (Join-Path $ProjectRoot "RUNBOOK.md")
}

Test-Check "RUNBOOK_DAY0.md exists" {
    Test-Path (Join-Path $ProjectRoot "RUNBOOK_DAY0.md")
}

Test-Check "TASK.md exists" {
    Test-Path (Join-Path $ProjectRoot "TASK.md")
}

Test-Check "README.md exists" {
    Test-Path (Join-Path $ProjectRoot "README.md")
}

Write-Host ""
Write-Host "2. Checking Scripts..." -ForegroundColor Cyan
Write-Host "-----------------------------------" -ForegroundColor Cyan

Test-Check "publish-gate.ps1 exists" {
    Test-Path (Join-Path $ScriptRoot "publish-gate.ps1")
}

Test-Check "publish-gate-regression.ps1 exists" {
    Test-Path (Join-Path $ScriptRoot "publish-gate-regression.ps1")
}

Test-Check "smoke-test.ps1 exists" {
    Test-Path (Join-Path $ScriptRoot "smoke-test.ps1")
}

Test-Check "run.ps1 exists" {
    Test-Path (Join-Path $ScriptRoot "run.ps1")
}

Test-Check "policy-update.ps1 exists" {
    Test-Path (Join-Path $ScriptRoot "policy-update.ps1")
}

Test-Check "generate_day0_packs.ps1 exists" {
    Test-Path (Join-Path $ScriptRoot "generate_day0_packs.ps1")
}

Write-Host ""
Write-Host "3. Checking Evaluation Assets..." -ForegroundColor Cyan
Write-Host "-----------------------------------" -ForegroundColor Cyan

Test-Check "eval/golden_set.jsonl exists" {
    Test-Path (Join-Path $ProjectRoot "eval\golden_set.jsonl")
}

Test-Check "eval/regression_cases_local.jsonl exists or will be auto-created" {
    $localPath = Join-Path $ScriptRoot "regression_cases_local.jsonl"
    Test-Path $localPath
} -Required $false

Write-Host ""
Write-Host "4. Checking Output Structure..." -ForegroundColor Cyan
Write-Host "-----------------------------------" -ForegroundColor Cyan

Test-Check "outputs/ directory exists" {
    Test-Path (Join-Path $ProjectRoot "outputs")
}

Test-Check "outputs/day0/ directory exists or will be created" {
    Test-Path (Join-Path $ProjectRoot "outputs\day0")
} -Required $false

Write-Host ""
Write-Host "5. Running Script Tests..." -ForegroundColor Cyan
Write-Host "-----------------------------------" -ForegroundColor Cyan

Test-Check "publish-gate-regression.ps1 runs successfully" {
    try {
        & (Join-Path $ScriptRoot "publish-gate-regression.ps1") | Out-Null
        $LASTEXITCODE -eq 0
    }
    catch {
        Write-Host "    Error: $($_.Exception.Message)" -ForegroundColor Yellow
        return $false
    }
} -Required $true

Write-Host ""
Write-Host "6. Checking Documentation Content..." -ForegroundColor Cyan
Write-Host "-----------------------------------" -ForegroundColor Cyan

Test-Check "RUNBOOK.md contains Daily Loop section" {
    $content = Get-Content (Join-Path $ProjectRoot "RUNBOOK.md") -Raw
    $content -match "Daily Loop" -and $content -match "TiCo"
}

Test-Check "RUNBOOK_DAY0.md contains boot instructions" {
    $content = Get-Content (Join-Path $ProjectRoot "RUNBOOK_DAY0.md") -Raw
    $content -match "Day 0" -or $content -match "boot" -or $content -match "setup"
}

Write-Host ""
Write-Host "7. Checking Git Repository Status..." -ForegroundColor Cyan
Write-Host "-----------------------------------" -ForegroundColor Cyan

Test-Check ".gitignore exists" {
    Test-Path (Join-Path $ProjectRoot ".gitignore")
}

Test-Check "Git repository initialized" {
    Test-Path (Join-Path $ProjectRoot ".git")
} -Required $false

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "Verification Summary" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Total Checks: $TotalChecks" -ForegroundColor White
Write-Host "Passed: $PassedChecks" -ForegroundColor Green
Write-Host "Failed: $FailedChecks" -ForegroundColor $(if ($FailedChecks -gt 0) { "Red" } else { "Green" })
if ($Warnings.Count -gt 0) {
    Write-Host "Warnings: $($Warnings.Count)" -ForegroundColor Yellow
}
Write-Host ""

if ($FailedChecks -gt 0) {
    Write-Host "❌ VERIFICATION FAILED" -ForegroundColor Red
    Write-Host "Please fix the failing checks above and run again." -ForegroundColor Red
    exit 1
}
else {
    Write-Host "✅ VERIFICATION PASSED" -ForegroundColor Green
    Write-Host "Feedback Playbook v1.1.1 is ready for deployment!" -ForegroundColor Green
    exit 0
}
