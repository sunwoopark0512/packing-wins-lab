@echo off
cd /d "C:\Users\sunwo\OneDrive\wrok\projects\packing-wins-lab"

echo ======================================================
echo Step 1: Git Repository Initialization
echo ======================================================
echo.

if not exist ".git" (
    git init
    echo [OK] Git repository initialized
) else (
    echo [SKIP] Git repository already initialized
)

echo.
echo Step 1 complete: Git repository ready
echo.
echo ======================================================
echo Step 2: Connect to Remote Repository
echo ======================================================
echo.
echo Please create an empty repository on GitHub first, then run:
echo.
echo git remote add origin https://github.com/YOUR_USERNAME/packing-wins-lab.git
echo git branch -M main
echo git push -u origin main
echo.
pause
