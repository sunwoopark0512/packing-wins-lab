cd "C:\Users\sunwo\OneDrive\wrok\projects\packing-wins-lab"

# 1단계: Git 레포지토리 초기화
if (-not (Test-Path ".git")) {
    git init
    Write-Host "✓ Git repository initialized" -ForegroundColor Green
} else {
    Write-Host "✓ Git repository already initialized" -ForegroundColor Yellow
}

# 2단계: 모든 파일 추가
git add -A
Write-Host "✓ All files staged" -ForegroundColor Green

# 3단계: 초기 커밋
git commit -m "Initial commit: packing-wins-lab"
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Initial commit created" -ForegroundColor Green
} else {
    Write-Host "⚠ Initial commit skipped or failed" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Step 1 complete: Git repository ready" -ForegroundColor Cyan
Write-Host "Next: Connect to remote repository" -ForegroundColor Cyan
