@echo off
setlocal enabledelayedexpansion

cd /d "C:\Users\sunwo\OneDrive\wrok\projects\packing-wins-lab"

echo ======================================================
echo Step 5: Create Release Branch
echo ======================================================
echo.

REM Create release branch
echo Creating release branch: release/feedback-pack-v1.1.1
git switch -c release/feedback-pack-v1.1.1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to create release branch
    pause
    exit /b 1
)
echo [OK] Release branch created
echo.

REM Add all files
echo Adding all files to staging...
git add -A
if %errorlevel% neq 0 (
    echo [ERROR] Failed to stage files
    pause
    exit /b 1
)
echo [OK] Files staged
echo.

REM Create release commit
echo Creating release commit...
git commit -m "Release: Feedback Playbook v1.1.1"
if %errorlevel% neq 0 (
    echo [WARN] Nothing to commit or commit failed
    echo Continuing anyway...
) else (
    echo [OK] Release commit created
)
echo.

REM Push release branch
echo Pushing release branch to remote...
git push -u origin release/feedback-pack-v1.1.1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to push release branch
    echo Please check your credentials and try again
    pause
    exit /b 1
)
echo [OK] Release branch pushed
echo.

echo ======================================================
echo Step 5 Complete: Release Branch Ready
echo ======================================================
echo.
echo Next steps:
echo 1. Go to GitHub
echo 2. Create PR: release/feedback-pack-v1.1.1 -> main
echo 3. Wait for CI/CD checks (regression-tests.yml, performance-tests.yml)
echo 4. Merge the PR
echo 5. Run deploy_tag.bat to create and push tag
echo.
pause
