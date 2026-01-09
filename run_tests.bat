@echo off
setlocal enabledelayedexpansion

cd /d "C:\Users\sunwo\OneDrive\wrok\projects\packing-wins-lab"

echo ================================================================
echo    Unit Test Runner
echo ================================================================
echo.

if not exist "tests" (
    echo [ERROR] tests directory not found
    echo Creating tests directory...
    mkdir tests
)

echo Running unit tests...
echo.

REM Check if Pester is available
powershell -Command "Get-Module -ListAvailable -Name Pester" >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARN] Pester module not found
    echo Running native PowerShell tests...
    powershell -ExecutionPolicy Bypass -File "tests\verify-feedback-pack.tests.ps1"
) else (
    echo Running Pester tests...
    powershell -ExecutionPolicy Bypass -Command "Invoke-Pester -Path 'tests\verify-feedback-pack.tests.ps1' -OutputFormat NUnitXml -OutputString"
)

if %errorlevel% equ 0 (
    echo.
    echo [OK] All tests passed
    exit /b 0
) else (
    echo.
    echo [FAIL] Some tests failed
    exit /b 1
)
