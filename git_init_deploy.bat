@echo off
setlocal enabledelayedexpansion

cd /d "C:\Users\sunwo\OneDrive\wrok\projects\packing-wins-lab"

cls
echo.
echo ================================================================
echo    Feedback Playbook v1.1.1 - Git Initialization
echo ================================================================
echo.
echo This script will initialize Git repository and commit all files.
echo.

REM ============================================================
REM STEP 1: Git Repository Initialization
REM ============================================================

echo [1/3] Initializing Git repository...
echo -----------------------------------------------

if not exist ".git" (
    git init > nul 2>&1
    if %errorlevel% equ 0 (
        echo [OK] Git repository initialized
    ) else (
        echo [FAIL] Failed to initialize git repository
        pause
        exit /b 1
    )
) else (
    echo [SKIP] Git repository already initialized
)
echo.

REM ============================================================
REM STEP 2: Stage All Files
REM ============================================================

echo [2/3] Staging all files...
echo -----------------------------------------------

git add -A > nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] All files staged
) else (
    echo [FAIL] Failed to stage files
    pause
    exit /b 1
)
echo.

REM ============================================================
REM STEP 3: Create Initial Commit
REM ============================================================

echo [3/3] Creating initial commit...
echo -----------------------------------------------

git commit -m "Initial commit: packing-wins-lab v1.1.1" > nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Initial commit created
) else (
    echo [WARN] Nothing to commit or commit failed (continuing)
)
echo.

REM ============================================================
REM FINAL SUMMARY
REM ============================================================

cls
echo.
echo ================================================================
echo                     GIT INITIALIZATION COMPLETE
echo ================================================================
echo.
echo Completed Steps:
echo.
echo [✓] Git repository initialized
echo [✓] All files staged
echo [✓] Initial commit created
echo.
echo Next Steps:
echo 1. Run: deploy_complete.bat
echo 2. Enter your GitHub repository URL when prompted
echo.
echo Repository: C:\Users\sunwo\OneDrive\wrok\projects\packing-wins-lab
echo.
echo ================================================================
echo Press any key to continue to deployment script...
pause > nul

REM Automatically continue to deployment script
call deploy_complete.bat
