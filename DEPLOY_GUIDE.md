# Feedback Playbook v1.1.1 Deployment Guide

This guide will walk you through deploying Feedback Playbook v1.1.1 to GitHub.

## Prerequisites

- Git installed and configured
- GitHub account
- PowerShell or Command Prompt
- Administrator privileges (if needed)

## Deployment Steps

### Step 1: Initialize Repository

Double-click `deploy_step1.bat` to initialize the git repository.

**Or run manually:**
```powershell
cd "C:\Users\sunwo\OneDrive\wrok\projects\packing-wins-lab"
git init
git add -A
git commit -m "Initial commit: packing-wins-lab"
```

### Step 2: Connect to Remote Repository

Double-click `deploy_all.bat` and enter your GitHub repository URL when prompted.

**Or run manually:**
```powershell
# First, create an empty repository on GitHub
# Then connect:
git remote add origin https://github.com/YOUR_USERNAME/packing-wins-lab.git
git branch -M main
git push -u origin main
```

### Step 3: Verify Installation

```powershell
.\scripts\verify-feedback-pack.ps1
```

If verification fails, fix the issues before proceeding.

### Step 4: Create Release Branch

Double-click `deploy_release_branch.bat`.

**Or run manually:**
```powershell
git switch -c release/feedback-pack-v1.1.1
git add -A
git commit -m "Release: Feedback Playbook v1.1.1"
git push -u origin release/feedback-pack-v1.1.1
```

### Step 5: Create Pull Request

1. Go to GitHub
2. Create PR: `release/feedback-pack-v1.1.1` → `main`
3. Wait for CI/CD checks:
   - ✅ regression-tests.yml
   - ✅ performance-tests.yml
4. If all checks pass, merge the PR

### Step 6: Create Tag

After merging the PR, double-click `deploy_tag.bat`.

**Or run manually:**
```powershell
git switch main
git pull
git tag -a v1.1.1 -m "Feedback Playbook v1.1.1"
git push origin v1.1.1
```

### Step 7: Create GitHub Release

1. Go to GitHub Releases page
2. Click "Create a new release"
3. Select tag `v1.1.1`
4. Copy release notes from [CHANGELOG.md](CHANGELOG.md)
5. Publish release

## Verification Checklist

Before completing deployment, verify:

- [ ] Repository initialized on GitHub
- [ ] All files pushed to main branch
- [ ] Verification script passes: `.\scripts\verify-feedback-pack.ps1`
- [ ] Release branch created: `release/feedback-pack-v1.1.1`
- [ ] PR created and merged
- [ ] CI/CD checks pass (regression-tests.yml, performance-tests.yml)
- [ ] Tag v1.1.1 created and pushed
- [ ] GitHub Release created

## Troubleshooting

### Git Not Found

**Problem:** `git` command not recognized

**Solution:** Install Git from https://git-scm.com/ and restart your terminal.

### Push Fails

**Problem:** `git push` fails with authentication error

**Solution:**
1. Configure Git credentials:
   ```powershell
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```
2. Use GitHub Personal Access Token instead of password
3. Or configure SSH keys

### CI/CD Checks Fail

**Problem:** GitHub Actions checks fail

**Solution:**
1. Check the logs on GitHub Actions page
2. Verify scripts work locally:
   ```powershell
   .\scripts\publish-gate-regression.ps1
   .\scripts\verify-feedback-pack.ps1
   ```
3. Fix issues and push new commit
4. Wait for checks to pass

### Tag Already Exists

**Problem:** Tag v1.1.1 already exists

**Solution:** Delete existing tag:
```powershell
git tag -d v1.1.1
git push origin :refs/tags/v1.1.1
```

Then create and push again.

## Rollback Plan

If something goes wrong, you can rollback:

### Undo Last Merge

```powershell
git switch main
git log --oneline -5
# Find the merge commit hash
git revert <MERGE_COMMIT_HASH>
git push
```

### Delete Tag

```powershell
git tag -d v1.1.1
git push origin :refs/tags/v1.1.1
```

## Summary

After completing all steps, your Feedback Playbook v1.1.1 will be:

- ✅ Hosted on GitHub
- ✅ Versioned with tag v1.1.1
- ✅ Released with changelog
- ✅ Protected by CI/CD checks

## Deployment Scripts

| Script | Purpose |
|---------|---------|
| `deploy_step1.bat` | Initialize git repository |
| `deploy_all.bat` | Connect to remote and push to main |
| `deploy_release_branch.bat` | Create release branch and push |
| `deploy_tag.bat` | Create and push tag |

Run these scripts in order for automated deployment.

---

**Deployment Status:** 🟡 Ready to Deploy
**Last Updated:** 2026-01-09
**Version:** v1.1.1
