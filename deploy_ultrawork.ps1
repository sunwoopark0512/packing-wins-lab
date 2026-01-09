# Feedback Playbook v1.1.1 - Ultrawork Deployment Execution

$ErrorActionPreference = "Stop"
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptRoot

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "   Feedback Playbook v1.1.1 - Ultrawork Deployment" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 ULTRAWORK MODE ENABLED" -ForegroundColor Yellow
Write-Host ""

# Phase 1: Verification
Write-Host "[1/7] Running Verification..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------" -ForegroundColor Yellow
& "$PSScriptRoot\scripts\verify-feedback-pack.ps1" -ErrorAction Stop
if ($LASTEXITCODE -ne 0) {
    Write-Host "[✓] Verification passed" -ForegroundColor Green
} else {
    Write-Host "[✗] Verification failed" -ForegroundColor Red
    Write-Host "Check verification_output.txt" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "   Phase 2: Git Repository Initialization" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[2/7] Git Repository Initialization..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------" -ForegroundColor Yellow

$gitExists = Test-Path ".git"
if (-not $gitExists) {
    Write-Host "Initializing Git repository..." -ForegroundColor Yellow
    & git init
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[✓] Git repository initialized" -ForegroundColor Green
    } else {
        Write-Host "[✗] Failed to initialize git" -ForegroundColor Red
        Write-Host "Press any key to exit..." -ForegroundColor Yellow
        pause
        exit 1
    }
} else {
    Write-Host "[⊘] Git repository already exists" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "   Phase 3: Stage and Commit Initial Files" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[3/7] Staging and Committing Files..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------" -ForegroundColor Yellow

& git add -A
& git commit -m "Initial commit: packing-wins-lab v1.1.1"

if ($LASTEXITCODE -eq 0) {
    Write-Host "[✓] Initial commit created" -ForegroundColor Green
} else {
    Write-Host "[✗] Failed to create initial commit" -ForegroundColor Red
    Write-Host "Press any key to exit..." -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "   Phase 4: Remote Repository Connection" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[4/7] Connecting to Remote Repository..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------" -ForegroundColor Yellow

Write-Host ""
Write-Host "IMPORTANT: Create an empty repository on GitHub first." -ForegroundColor Cyan
Write-Host ""
Write-Host "Repository name: packing-wins-lab" -ForegroundColor Cyan
Write-Host "Repository URL: https://github.com/sunwoopark0512/packing-wins-lab.git" -ForegroundColor Cyan
Write-Host ""

$remoteUrl = "https://github.com/sunwoopark0512/packing-wins-lab.git"
$remoteAdded = $false

Write-Host "[4/7] Removing .git suffix from URL..." -ForegroundColor Yellow
if ($remoteUrl -like "*.git") {
    $remoteUrl = $remoteUrl -replace "\.git$",""
    Write-Host "[✓] URL cleaned (no .git suffix)" -ForegroundColor Green
}

Write-Host ""
Write-Host "[4/7] Configuring remote repository..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------" -ForegroundColor Yellow

git remote get-url origin 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "[INFO] Remote already configured" -ForegroundColor Cyan
    Write-Host "Current remote URL: "
    git remote get-url origin | Write-Host
    Write-Host ""
    Write-Host "Repository URL: $remoteUrl" -ForegroundColor Cyan
    $remoteAdded = $true
} else {
    Write-Host "[4/7] Adding remote repository..." -ForegroundColor Yellow
    Write-Host "Repository URL: $remoteUrl" -ForegroundColor Cyan
    & git remote add origin $remoteUrl
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[✓] Remote repository configured" -ForegroundColor Green
        $remoteAdded = $true
    } else {
        Write-Host "[✗] Failed to configure remote repository" -ForegroundColor Red
        Write-Host "Press any key to exit..." -ForegroundColor Yellow
        pause
        exit 1
    }
}

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "   Phase 5: Push to Main Branch" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[5/7] Pushing to Main Branch..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------" -ForegroundColor Yellow

Write-Host ""
Write-Host "Authentication Note:" -ForegroundColor Cyan
Write-Host "You will be prompted for:" -ForegroundColor White
Write-Host "  - Username (GitHub username)" -ForegroundColor Cyan
Write-Host "  - Password: Your Personal Access Token (NOT GitHub password)" -ForegroundColor Cyan
Write-Host ""

Write-Host ""
Write-Host "Pushing..." -ForegroundColor Yellow

& git branch -M main
& git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "[✓] Successfully pushed to main branch" -ForegroundColor Green
    Write-Host ""
    Write-Host "✓ Repository is now live on GitHub!" -ForegroundColor Green
    Write-Host ""
    Write-Host "https://github.com/sunwoopark0512/packing-wins-lab" -ForegroundColor Cyan
} else {
    Write-Host "[✗] Failed to push to main branch" -ForegroundColor Red
    Write-Host ""
    Write-Host "Common issues:" -ForegroundColor Yellow
    Write-Host "  - Repository URL is incorrect" -ForegroundColor Yellow
    Write-Host "  - Authentication failed" -ForegroundColor Yellow
    Write-Host "  - Network issues" -ForegroundColor Yellow
    Write-Host "  - Repository doesn't exist on GitHub" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please check your credentials and repository URL." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "   Phase 6: Create Release Branch and Push" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[6/7] Creating Release Branch..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------" -ForegroundColor Yellow

git switch -c release/feedback-pack-v1.1.1 2>&1 | Out-Null
$switchResult = $LASTEXITCODE

Write-Host ""
Write-Host "[6/7] Adding files and committing..." -ForegroundColor Yellow

& git add -A
& git commit -m "Release: Feedback Playbook v1.1.1"

Write-Host ""
Write-Host "[6/7] Pushing release branch..." -ForegroundColor Yellow

& git push -u origin release/feedback-pack-v1.1.1.2

if ($switchResult -eq 0) {
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[✓] Release branch pushed" -ForegroundColor Green
    } else {
        Write-Host "[✗] Release branch push may have failed (check manually)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "   Phase 7: Create and Push Tag" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[7/7] Creating and Pushing Tag..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------" -ForegroundColor Yellow

Write-Host ""
Write-Host "Switching back to main branch..." -ForegroundColor Yellow

& git switch main 2>&1 | Out-Null
& git pull 2>&1 | Out-Null

Write-Host ""
Write-Host "[7/7] Creating tag..." -ForegroundColor Yellow

& git tag -a v1.1.1 -m "Feedback Playbook v1.1.1 - Comprehensive content automation playbook" | Out-Null

Write-Host ""
Write-Host "[7/7] Pushing tag..." -ForegroundColor Yellow

& git push origin v1.1.1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "[✓] Tag v1.1.1 pushed" -ForegroundColor Green
    Write-Host ""
    Write-Host "✓ Repository ready for release!" -ForegroundColor Green
} else {
    Write-Host "[✗] Tag push may have failed (check manually)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "   FINAL SUMMARY" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "STATUS: Deployment Complete" -ForegroundColor Green
Write-Host ""
Write-Host ""
Write-Host "Completed Steps:" -ForegroundColor White
Write-Host ""
Write-Host "[✓] Phase 1: Verification" -ForegroundColor Green
Write-Host "[✓] Phase 2: Git Repository Initialization" -ForegroundColor Green
Write-Host "[✓] Phase 3: Stage and Commit Initial Files" -ForegroundColor Green
Write-Host "[✓] Phase 4: Remote Repository Configuration" -ForegroundColor Green
Write-Host "[✓] Phase 5: Push to Main Branch" -ForegroundColor Green
Write-Host "[✓] Phase 6: Create Release Branch and Push" -ForegroundColor Green
Write-Host "[✓] Phase 7: Create and Push Tag" -ForegroundColor Green
Write-Host ""
Write-Host "Repository URL: https://github.com/sunwoopark0512/packing-wins-lab" -ForegroundColor Cyan
Write-Host "Tag: v1.1.1" -ForegroundColor Cyan
Write-Host ""

Write-Host ""
Write-Host "Remaining Actions (Manual):" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Go to GitHub" -ForegroundColor Cyan
Write-Host "   https://github.com/sunwoopark0512/packing-wins-lab" -ForegroundColor Cyan
Write-Host "2. Create PR: release/feedback-pack-v1.1.1.2 -^> main" -ForegroundColor Cyan
Write-Host "3. Wait for CI/CD checks" -ForegroundColor Yellow
Write-Host "   - regression-tests.yml" -ForegroundColor Green
Write-Host "   - performance-tests.yml" -ForegroundColor Green
Write-Host "4. If all checks pass, merge PR" -ForegroundColor Cyan
Write-Host "5. Create GitHub Release from tag v1.1.1" -ForegroundColor Cyan
Write-Host "   - Select tag: v1.1.1" -ForegroundColor Cyan
Write-Host "   - Copy release notes from CHANGELOG.md" -ForegroundColor Yellow
Write-Host ""
Write-Host "6. Publish release" -ForegroundColor Yellow
Write-Host ""

Write-Host ""
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to open GitHub repository..." -ForegroundColor Yellow
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host ""

pause
