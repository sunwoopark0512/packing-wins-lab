@echo off
setlocal enabledelayedexpansion

cd /d "C:\Users\sunwo\OneDrive\wrok\projects\packing-wins-lab"

cls
echo.
echo ================================================================
echo    Feedback Playbook v1.1.1 - Complete Deployment Script
echo ================================================================
echo.
echo This script will perform ALL deployment steps automatically.
echo.

REM ============================================================
REM STEP 1: Verification
REM ============================================================
echo [1/7] Running Verification...
echo -----------------------------------------------
powershell -ExecutionPolicy Bypass -File ".\scripts\verify-feedback-pack.ps1" > verification_output.txt 2>&1
if %errorlevel% equ 0 (
    echo [OK] Verification passed
) else (
    echo [FAIL] Verification failed - Check verification_output.txt
    echo Please fix issues before proceeding with deployment.
    exit /b 1
)
echo.

REM ============================================================
REM STEP 2: Git Repository Initialization
REM ============================================================
echo [2/7] Git Repository Initialization...
echo -----------------------------------------------
if not exist ".git" (
    git init > nul 2>&1
    if %errorlevel% equ 0 (
        echo [OK] Git repository initialized
    ) else (
        echo [FAIL] Failed to initialize git repository
        echo.
        echo Try running "git init" manually to see the error.
        exit /b 1
    )
) else (
    echo [SKIP] Git repository already exists
)
echo.

REM ============================================================
REM STEP 3: Stage and Commit Initial Files
REM ============================================================
echo [3/7] Staging and Committing Files...
echo -----------------------------------------------
git add -A > nul 2>&1
git commit -m "Initial commit: packing-wins-lab v1.1.1" > nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Initial commit created
) else (
    echo [WARN] Nothing to commit or commit failed (might be empty or already committed)
)
echo.

REM ============================================================
REM STEP 4: Remote Repository Connection
REM ============================================================
echo [4/7] Connecting to Remote Repository...
echo -----------------------------------------------
REM Check if remote already exists
git remote get-url origin > nul 2>&1
if %errorlevel% equ 0 (
    echo [INFO] Remote repository already configured
) else (
    echo [INFO] Setting remote to: https://github.com/sunwoopark0512/packing-wins-lab.git
    git remote add origin https://github.com/sunwoopark0512/packing-wins-lab.git
    if %errorlevel% equ 0 (
        echo [OK] Remote repository configured
    ) else (
        echo [FAIL] Failed to add remote. It might already exist.
    )
)
echo.

REM ============================================================
REM STEP 5: Push to Main Branch
REM ============================================================
echo [5/7] Pushing to Main Branch...
echo -----------------------------------------------
git branch -M main > nul 2>&1
git push -u origin main > nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Successfully pushed to main branch
) else (
    echo [FAIL] Failed to push to main branch
    echo.
    echo Attempting one retry...
    git push -u origin main
    if %errorlevel% neq 0 (
        echo [FAIL] Retry failed. Please check your internet or permissions.
        exit /b 1
    )
)
echo.

REM ============================================================
REM STEP 6: Create Release Branch and Push
REM ============================================================
echo [6/7] Creating Release Branch...
echo -----------------------------------------------
git switch -c release/feedback-pack-v1.1.1 > nul 2>&1
if %errorlevel% neq 0 (
    git checkout release/feedback-pack-v1.1.1 > nul 2>&1
)

git add -A > nul 2>&1
git commit -m "Release: Feedback Playbook v1.1.1" > nul 2>&1
git push -u origin release/feedback-pack-v1.1.1 > nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Release branch pushed
) else (
    echo [WARN] Release branch push may have failed
)
echo.

REM ============================================================
REM STEP 7: Create and Push Tag
REM ============================================================
echo [7/7] Creating and Pushing Tag...
echo -----------------------------------------------
git switch main > nul 2>&1
git pull > nul 2>&1
git tag -a v1.1.1 -m "Feedback Playbook v1.1.1 - Comprehensive content automation playbook" > nul 2>&1
git push origin v1.1.1 > nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Tag v1.1.1 pushed
) else (
    echo [WARN] Tag push may have failed
)
echo.

REM ============================================================
REM FINAL SUMMARY
REM ============================================================
echo.
echo ================================================================
echo                     DEPLOYMENT SUMMARY
echo ================================================================
echo.
echo STATUS: Deployment Script Finished
echo.
echo Next Steps:
echo 1. Check if the repo is populated: https://github.com/sunwoopark0512/packing-wins-lab
echo 2. Create PR: release/feedback-pack-v1.1.1 -^> main
echo 3. Create GitHub Release from tag v1.1.1
echo.
pause
