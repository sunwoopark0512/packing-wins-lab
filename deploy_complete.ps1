
# Feedback Playbook v1.1.1 - Complete Deployment Script (PowerShell Version)

Clear-Host
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "   Feedback Playbook v1.1.1 - Complete Deployment Script"
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will perform ALL deployment steps automatically."
Write-Host ""

# ============================================================
# STEP 1: Verification
# ============================================================
Write-Host "[1/7] Running Verification..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------"
try {
    .\scripts\verify-feedback-pack.ps1 | Out-File -FilePath verification_output.txt -Encoding UTF8
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Verification passed" -ForegroundColor Green
    }
    else {
        throw "Verification failed - Check verification_output.txt"
    }
}
catch {
    Write-Host "[FAIL] $_" -ForegroundColor Red
    Write-Host "Please fix issues before proceeding with deployment."
    exit 1
}
Write-Host ""

# ============================================================
# STEP 2: Git Repository Initialization
# ============================================================
Write-Host "[2/7] Git Repository Initialization..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------"
if (-not (Test-Path ".git")) {
    git init | Out-Null
    if ($?) {
        Write-Host "[OK] Git repository initialized" -ForegroundColor Green
    }
    else {
        Write-Host "[FAIL] Failed to initialize git repository" -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "[SKIP] Git repository already exists" -ForegroundColor Gray
}
Write-Host ""

# ============================================================
# STEP 3: Stage and Commit Initial Files
# ============================================================
Write-Host "[3/7] Staging and Committing Files..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------"
git add -A | Out-Null
git commit -m "Initial commit: packing-wins-lab v1.1.1" | Out-Null
if ($?) {
    Write-Host "[OK] Initial commit created" -ForegroundColor Green
}
else {
    Write-Host "[WARN] Nothing to commit or commit failed (continuing)" -ForegroundColor DarkYellow
}
Write-Host ""

# ============================================================
# STEP 4: Remote Repository Connection
# ============================================================
Write-Host "[4/7] Connecting to Remote Repository..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------"
Write-Host ""

$remoteUrl = git remote get-url origin 2>$null
if ($remoteUrl) {
    Write-Host "[INFO] Remote repository already configured: $remoteUrl" -ForegroundColor Gray
}
else {
    # Try using gh cli first if available to create/link
    if (Get-Command "gh" -ErrorAction SilentlyContinue) {
        Write-Host "GitHub CLI detected. Attempting to ensure repo exists/connect..."
        # We don't want to force create if checks fail, just ask user if not sure.
        # But let's ask user for URL as a fallback or simply ask them.
    }

    $repoUrl = Read-Host "Enter your GitHub repository URL (e.g. https://github.com/user/repo.git)"
    if ([string]::IsNullOrWhiteSpace($repoUrl)) {
        Write-Host "[FAIL] No repository URL provided" -ForegroundColor Red
        exit 1
    }
    
    git remote add origin $repoUrl
    Write-Host "[OK] Remote repository configured" -ForegroundColor Green
}
Write-Host ""

# ============================================================
# STEP 5: Push to Main Branch
# ============================================================
Write-Host "[5/7] Pushing to Main Branch..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------"
git branch -M main | Out-Null
git push -u origin main | Out-Null
if ($?) {
    Write-Host "[OK] Successfully pushed to main branch" -ForegroundColor Green
}
else {
    Write-Host "[FAIL] Failed to push to main branch" -ForegroundColor Red
    Write-Host "Possible causes: Repo URL incorrect, Auth failed, or repo not empty."
    exit 1
}
Write-Host ""

# ============================================================
# STEP 6: Create Release Branch and Push
# ============================================================
Write-Host "[6/7] Creating Release Branch..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------"
$branchName = "release/feedback-pack-v1.1.1"
git switch -c $branchName 2>$null
if (-not $?) {
    Write-Host "[WARN] Branch may already exist, switching..." -ForegroundColor DarkYellow
    git checkout $branchName | Out-Null
}

git add -A 2>$null
git commit -m "Release: Feedback Playbook v1.1.1" 2>$null
git push -u origin $branchName 2>$null
if ($?) {
    Write-Host "[OK] Release branch pushed" -ForegroundColor Green
}
else {
    Write-Host "[WARN] Release branch push may have failed (check manually)" -ForegroundColor DarkYellow
}
Write-Host ""

# ============================================================
# STEP 7: Create and Push Tag
# ============================================================
Write-Host "[7/7] Creating and Pushing Tag..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------"
git switch main | Out-Null
git pull | Out-Null
git tag -a v1.1.1 -m "Feedback Playbook v1.1.1 - Comprehensive content automation playbook" 2>$null
git push origin v1.1.1 2>$null
if ($?) {
    Write-Host "[OK] Tag v1.1.1 pushed" -ForegroundColor Green
}
else {
    Write-Host "[WARN] Tag push may have failed (check manually)" -ForegroundColor DarkYellow
}
Write-Host ""

# ============================================================
# FINAL SUMMARY
# ============================================================
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "                    DEPLOYMENT SUMMARY"
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "STATUS: Deployment Complete" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:"
Write-Host "1. Create PR: release/feedback-pack-v1.1.1 -> main"
Write-Host "2. Verify CI/CD checks pass"
Write-Host "3. Create GitHub Release from tag v1.1.1"
Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
