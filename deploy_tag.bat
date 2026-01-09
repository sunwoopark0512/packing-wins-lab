@echo off
setlocal enabledelayedexpansion

cd /d "C:\Users\sunwo\OneDrive\wrok\projects\packing-wins-lab"

echo ======================================================
echo Step 6: Create and Push Tag v1.1.1
echo ======================================================
echo.

REM Switch to main branch
echo Switching to main branch...
git switch main
if %errorlevel% neq 0 (
    echo [ERROR] Failed to switch to main branch
    pause
    exit /b 1
)
echo [OK] Switched to main
echo.

REM Pull latest changes
echo Pulling latest changes...
git pull
if %errorlevel% neq 0 (
    echo [WARN] Pull failed or nothing to pull
    echo Continuing anyway...
)
echo.

REM Create tag
echo Creating tag v1.1.1...
git tag -a v1.1.1 -m "Feedback Playbook v1.1.1"
if %errorlevel% neq 0 (
    echo [ERROR] Failed to create tag
    pause
    exit /b 1
)
echo [OK] Tag created
echo.

REM Push tag
echo Pushing tag to remote...
git push origin v1.1.1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to push tag
    echo Please check your credentials and try again
    pause
    exit /b 1
)
echo [OK] Tag pushed
echo.

echo ======================================================
echo Deployment Complete!
echo ======================================================
echo.
echo Feedback Playbook v1.1.1 has been successfully deployed!
echo.
echo What was done:
echo - Repository initialized
echo - Files committed
echo - Remote repository connected
echo - Release branch created and pushed
echo - PR created (if you merged it)
echo - Tag v1.1.1 created and pushed
echo.
echo Next:
echo - Create GitHub Release from tag v1.1.1
echo - Copy changelog from CHANGELOG.md
echo.
pause
