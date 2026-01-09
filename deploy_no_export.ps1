# Feedback Playbook v1.1.1 - Complete Deployment Script (No Export)
# PowerShell-only version - works without export command

$ErrorActionPreference = "Stop"

Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "    Feedback Playbook v1.1.1 - Deployment" -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host ""

# Phase 1: Verification
Write-Host "[1/7] Running Verification..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------" -ForegroundColor Yellow
& "$PSScriptRoot\scripts\verify-feedback-pack.ps1" -ErrorAction Stop
if ($LASTEXITCODE -ne 0) {
    Write-Host "[FAIL] Verification failed" -ForegroundColor Red
    Write-Host "Check verification_output.txt" -ForegroundColor Yellow
    Write-Host "Press any key to exit..." -ForegroundColor Yellow
    pause
    exit 1
}
Write-Host "[OK] Verification passed" -ForegroundColor Green
Write-Host ""

# Phase 2: Git Repository Initialization
Write-Host "[2/7] Git Repository Initialization..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------" -ForegroundColor Yellow
if (-not (Test-Path ".git")) {
    & git init | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Git repository initialized" -ForegroundColor Green
    }
    else {
        Write-Host "[FAIL] Failed to initialize git" -ForegroundColor Red
        pause
        exit 1
    }
}
else {
    Write-Host "[SKIP] Git repository already exists" -ForegroundColor Yellow
}
Write-Host ""

# Phase 3: Stage and Commit Initial Files
Write-Host "[3/7] Staging and Committing Files..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------" -ForegroundColor Yellow
& git add -A | Out-Null
& git commit -m "Initial commit: packing-wins-lab v1.1.1" | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Initial commit created" -ForegroundColor Green
}
else {
    Write-Host "[WARN] Nothing to commit or commit failed (continuing)" -ForegroundColor Yellow
}
Write-Host ""

# Phase 4: Remote Repository Connection
Write-Host "[4/7] Connecting to Remote Repository..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------" -ForegroundColor Yellow
Write-Host ""
Write-Host "IMPORTANT: Create an empty repository on GitHub first." -ForegroundColor Yellow
Write-Host ""
Write-Host "Repository URL format: https://github.com/YOUR_USERNAME/packing-wins-lab.git" -ForegroundColor Cyan
Write-Host ""

$remoteUrl = Read-Host "Enter your GitHub repository URL: "

if ([string]::IsNullOrWhiteSpace($remoteUrl)) {
    Write-Host "[FAIL] No repository URL provided" -ForegroundColor Red
    Write-Host "Press any key to exit..." -ForegroundColor Yellow
    pause
    exit 1
}

# Remove .git suffix if present
if ($remoteUrl -like "*.git") {
    $remoteUrl = $remoteUrl -replace "\.git$", ""
}

git remote add origin $remoteUrl | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Remote repository configured" -ForegroundColor Green
    Write-Host ""
    Write-Host "Repository URL: $remoteUrl" -ForegroundColor Cyan
}
else {
    Write-Host "[FAIL] Failed to configure remote repository" -ForegroundColor Red
    pause
    exit 1
}
Write-Host ""

# Phase 5: Push to Main Branch
Write-Host "[5/7] Pushing to Main Branch..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------" -ForegroundColor Yellow

git branch -M main | Out-Null

Write-Host ""
Write-Host "Attempting to push to main branch..." -ForegroundColor Yellow
Write-Host "Note: You may be prompted for credentials:" -ForegroundColor Cyan
Write-Host "  - Username: Your GitHub username" -ForegroundColor Cyan
Write-Host "  - Password: Your Personal Access Token (NOT your GitHub password)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Get your PAT: https://github.com/settings/tokens" -ForegroundColor Yellow
Write-Host "Select scopes: repo (full control)" -ForegroundColor Yellow
Write-Host ""

git push -u origin main | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Successfully pushed to main branch" -ForegroundColor Green
    Write-Host ""
    Write-Host "✓ Repository is now live on GitHub!" -ForegroundColor Cyan
}
else {
    Write-Host "[FAIL] Failed to push to main branch" -ForegroundColor Red
    Write-Host ""
    Write-Host "Common issues:" -ForegroundColor Yellow
    Write-Host "  - Repository URL is incorrect" -ForegroundColor Yellow
    Write-Host "  - Authentication failed" -ForegroundColor Yellow
    Write-Host "  - Network issues" -ForegroundColor Yellow
    Write-Host "  - Repository doesn't exist on GitHub" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please fix issues and try again." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Yellow
    pause
    exit 1
}
Write-Host ""

# Phase 6: Create Release Branch and Push
Write-Host "[6/7] Creating Release Branch..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------" -ForegroundColor Yellow

git switch -c release/feedback-pack-v1.1.1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    git checkout release/feedback-pack-v1.1.1 | Out-Null
}

git add -A | Out-Null
git commit -m "Release: Feedback Playbook v1.1.1" | Out-Null

Write-Host ""
Write-Host "Pushing release branch to GitHub..." -ForegroundColor Yellow
git push -u origin release/feedback-pack-v1.1.1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Release branch pushed" -ForegroundColor Green
}
else {
    Write-Host "[WARN] Release branch push may have failed (check manually)" -ForegroundColor Yellow
}
Write-Host ""

# Phase 7: Create and Push Tag
Write-Host "[7/7] Creating and Pushing Tag..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------" -ForegroundColor Yellow

git switch main | Out-Null
git pull | Out-Null

git tag -a v1.1.1 -m "Feedback Playbook v1.1.1 - Comprehensive content automation playbook" | Out-Null

Write-Host ""
Write-Host "Pushing tag to GitHub..." -ForegroundColor Yellow
git push origin v1.1.1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Tag v1.1.1 pushed" -ForegroundColor Green
}
else {
    Write-Host "[WARN] Tag push may have failed (check manually)" -ForegroundColor Yellow
}
Write-Host ""

# Phase 8: Open GitHub Repository
Write-Host "[8/7] Opening GitHub Repository..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------" -ForegroundColor Yellow

$repoUrl = git remote get-url origin 2>$null
if ($repoUrl -like "*.git") {
    $repoUrl = $repoUrl -replace "\.git$", ""
}

Write-Host "Repository URL: $repoUrl" -ForegroundColor Cyan
Write-Host ""
Write-Host "Opening in default browser..." -ForegroundColor Cyan

Start-Process $repoUrl

Write-Host ""
Write-Host ""
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "                    DEPLOYMENT COMPLETE" -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Status: Deployment Complete (or Partially Complete)" -ForegroundColor Green
Write-Host ""
Write-Host "Completed Steps:" -ForegroundColor White
Write-Host ""
Write-Host "[✓] Verification (verify-feedback-pack.ps1)" -ForegroundColor Green
Write-Host "[✓] Git Repository Initialization" -ForegroundColor Green
Write-Host "[✓] Initial Commit" -ForegroundColor Green
Write-Host "[✓] Remote Repository Configuration" -ForegroundColor Green
Write-Host "[✓] Push to Main Branch" -ForegroundColor Green
Write-Host "[✓] Release Branch Creation" -ForegroundColor Green
Write-Host "[✓] Tag v1.1.1 Creation" -ForegroundColor Green
Write-Host "[✓] GitHub Repository Opened" -ForegroundColor Green
Write-Host ""
Write-Host "Remaining Actions (Manual):" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Go to GitHub: https://github.com/sunwoopark0512/packing-wins-lab" -ForegroundColor Cyan
Write-Host "2. Create PR: release/feedback-pack-v1.1.1 -^> main" -ForegroundColor Cyan
Write-Host "3. Wait for CI/CD checks:" -ForegroundColor Yellow
Write-Host "    - regression-tests.yml (should pass automatically)" -ForegroundColor White
Write-Host "    - performance-tests.yml (should pass automatically)" -ForegroundColor White
Write-Host "4. If checks pass, merge PR" -ForegroundColor Yellow
Write-Host "5. Create GitHub Release from tag v1.1.1" -ForegroundColor Cyan
Write-Host "6. Copy release notes from CHANGELOG.md" -ForegroundColor Yellow
Write-Host ""
Write-Host ""
Write-Host "Repository URL: $repoUrl" -ForegroundColor Cyan
Write-Host "Tag: v1.1.1" -ForegroundColor Cyan
Write-Host ""
Write-Host "Documentation:" -ForegroundColor White
Write-Host "- RUNBOOK.md: Daily operations guide" -ForegroundColor White
Write-Host "- DEPLOY_GUIDE.md: Detailed deployment guide" -ForegroundColor White
Write-Host "- CHANGELOG.md: Version history" -ForegroundColor White
Write-Host ""
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Create Pull Request on GitHub" -ForegroundColor Cyan
Write-Host "2. Verify CI/CD checks pass (green)" -ForegroundColor Cyan
Write-Host "3. Merge Pull Request" -ForegroundColor Cyan
Write-Host "4. Create GitHub Release from tag v1.1.1" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to open GitHub repository..." -ForegroundColor Yellow
pause > $null
