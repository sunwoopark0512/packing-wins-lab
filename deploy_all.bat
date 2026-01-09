@echo off
setlocal enabledelayedexpansion

cd /d "C:\Users\sunwo\OneDrive\wrok\projects\packing-wins-lab"

echo ======================================================
echo Feedback Playbook v1.1.1 Deployment Script
echo ======================================================
echo.

REM Step 1: Git Repository Initialization
echo Step 1: Git Repository Initialization
echo -----------------------------------
if not exist ".git" (
    git init
    echo [OK] Git repository initialized
) else (
    echo [SKIP] Git repository already exists
)
echo.

REM Step 2: Add all files
echo Step 2: Add all files to staging
echo -----------------------------------
git add -A
if %errorlevel% equ 0 (
    echo [OK] All files staged
) else (
    echo [ERROR] Failed to stage files
    pause
    exit /b 1
)
echo.

REM Step 3: Initial commit
echo Step 3: Create initial commit
echo -----------------------------------
git commit -m "Initial commit: packing-wins-lab"
if %errorlevel% equ 0 (
    echo [OK] Initial commit created
) else (
    echo [WARN] Nothing to commit or commit failed
)
echo.

REM Step 4: Ask for remote repository URL
echo Step 4: Connect to remote repository
echo -----------------------------------
echo.
echo Please create an empty repository on GitHub first.
echo.
set /p REMOTE_URL="Enter your GitHub repository URL: "

if "!REMOTE_URL!"=="" (
    echo [ERROR] No repository URL provided
    pause
    exit /b 1
)

git remote add origin !REMOTE_URL!
git branch -M main

echo.
echo [OK] Remote repository configured
echo.
echo Next: Push to remote repository
echo.
git push -u origin main
if %errorlevel% neq 0 (
    echo [ERROR] Failed to push to remote repository
    echo Please check your credentials and try again
    pause
    exit /b 1
)

echo.
echo [OK] Successfully pushed to remote repository
echo.
echo ======================================================
echo Step 1-4 Complete: Repository ready
echo ======================================================
echo.
echo Next steps:
echo 1. Run verification: .\scripts\verify-feedback-pack.ps1
echo 2. Create release branch: git switch -c release/feedback-pack-v1.1.1
echo 3. Commit and push release branch
echo 4. Create PR on GitHub
echo 5. Wait for CI/CD checks
echo 6. Merge PR
echo 7. Create tag: git tag -a v1.1.1 -m "Feedback Playbook v1.1.1"
echo 8. Push tag: git push origin v1.1.1
echo.

pause
