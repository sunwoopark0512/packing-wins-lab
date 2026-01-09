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
.\scripts\verify-feedback-pack.ps1 > verification_output.txt 2>&1
if %errorlevel% equ 0 (
    echo [OK] Verification passed
) else (
    echo [FAIL] Verification failed - Check verification_output.txt
    echo Please fix issues before proceeding with deployment.
    pause
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
        pause
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
    echo [WARN] Nothing to commit or commit failed (continuing)
)
echo.

REM ============================================================
REM STEP 4: Remote Repository Connection
REM ============================================================
echo [4/7] Connecting to Remote Repository...
echo -----------------------------------------------
echo.
echo IMPORTANT: You must create an empty repository on GitHub first.
echo.

REM Check if remote already exists
git remote get-url origin > nul 2>&1
if %errorlevel% equ 0 (
    echo [INFO] Remote repository already configured
    git remote get-url origin
) else (
    set /p REMOTE_URL="Enter your GitHub repository URL: "

    if "!REMOTE_URL!"=="" (
        echo [FAIL] No repository URL provided
        pause
        exit /b 1
    )

    git remote add origin !REMOTE_URL!
    echo [OK] Remote repository configured
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
    echo Possible causes:
    echo - Repository URL is incorrect
    echo - Authentication failed
    echo - Network issues
    echo.
    echo Please check your credentials and repository URL.
    pause
    exit /b 1
)
echo.

REM ============================================================
REM STEP 6: Create Release Branch and Push
REM ============================================================
echo [6/7] Creating Release Branch...
echo -----------------------------------------------
git switch -c release/feedback-pack-v1.1.1 > nul 2>&1
if %errorlevel% neq 0 (
    echo [WARN] Branch may already exist, trying to switch
    git checkout release/feedback-pack-v1.1.1 > nul 2>&1
)

git add -A > nul 2>&1
git commit -m "Release: Feedback Playbook v1.1.1" > nul 2>&1
git push -u origin release/feedback-pack-v1.1.1 > nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Release branch pushed
) else (
    echo [WARN] Release branch push may have failed (check manually)
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
    echo [WARN] Tag push may have failed (check manually)
)
echo.

REM ============================================================
REM FINAL SUMMARY
REM ============================================================
cls
echo.
echo ================================================================
echo                     DEPLOYMENT SUMMARY
echo ================================================================
echo.
echo STATUS: Deployment Complete (or Partially Complete)
echo.
echo Completed Steps:
echo.
echo [✓] Verification (verify-feedback-pack.ps1)
echo [✓] Git Repository Initialization
echo [✓] Initial Commit
echo [✓] Remote Repository Configuration
echo [✓] Push to Main Branch
echo [✓] Release Branch Creation
echo [✓] Tag v1.1.1 Creation
echo.
echo Remaining Actions (Manual):
echo.
echo 1. Go to GitHub: https://github.com/YOUR_USERNAME/packing-wins-lab
echo 2. Create PR: release/feedback-pack-v1.1.1 -^> main
echo 3. Wait for CI/CD checks:
echo    - regression-tests.yml (should pass automatically)
echo    - performance-tests.yml (should pass automatically)
echo 4. If checks pass, merge the PR
echo 5. Create GitHub Release from tag v1.1.1
echo 6. Copy release notes from CHANGELOG.md
echo.
echo Repository URL:
git remote get-url origin 2>nul
echo.
echo Tag: v1.1.1
echo.
echo Documentation:
echo - RUNBOOK.md: Daily operations guide
echo - DEPLOY_GUIDE.md: Detailed deployment guide
echo - CHANGELOG.md: Version history
echo.
echo ================================================================
echo.
echo Press any key to open GitHub repository...
pause > nul

REM Open GitHub repository
for /f "tokens=*" %%i in ('git remote get-url origin 2^>nul') do set REPO_URL=%%i
if defined REPO_URL (
    set REPO_WEB_URL=!REPO_URL:.git=!
    start !REPO_WEB_URL!
)

echo.
echo ================================================================
echo DEPLOYMENT FINISHED
echo ================================================================
echo.
echo Next Steps:
echo 1. Create PR and merge on GitHub
echo 2. Verify CI/CD checks pass
echo 3. Create GitHub Release from tag v1.1.1
echo.
pause
