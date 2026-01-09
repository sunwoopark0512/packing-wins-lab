# Runbook: Day 0 Boot (Content Engine)
**Project**: `packing-wins-lab`
**Focus**: 11-Channel Setup, Disclosure Safety, 10 Pack Generation

## 1. Environment & Setup (One-time)
```powershell
# 1. Models & Smoke Test
opencode models --refresh
opencode run "Hello check"

# 2. Policy Snapshot (First Run)
.\scripts\policy-update.ps1 -Action update
.\scripts\policy-update.ps1 -Action summarize
```

## 2. Publish Gate Verification (Crucial)
Before posting ANY of the 10 packs, you must run the regression test.
```powershell
# 1. Run Regression Suite (Must be ALL PASS)
.\scripts\publish-gate-regression.ps1

# 2. Dry-Run Check for Pack 01
Get-Content outputs\day0\pack_01\caption_core9.json | .\scripts\publish-gate.ps1 -Mode "DryRun"
```

## 3. Upload Checklist (Manual for Day 0)
- [ ] **Disclosure**: Does every post have `#ad` or "This post contains..."?
- [ ] **Links**: Is there ONLY ONE link (`https://YOUR-LINK-HUB.example`)?
- [ ] **Reddit**: Did you confirm `reddit.publish` is FALSE? (Draft only check)
- [ ] **Truth**: Did we promise "Guaranteed"? (If yes, fix it).

## 4. Slash Commands (Quick Reference)
```bash
# List available commands
/  (enter invalid command to see suggestions)

# Use available skill
/playwright

# If stuck, check documentation
cat SLASH_COMMANDS.md
```

## 5. Today's TiCo (Tiny Copilot Actions)
1. **Bio Update**: Update Instagram/TikTok bio with LinkHub URL.
2. **Post Pack 01**: Manually post Pack 01 to TikTok & Shorts (test waters).
3. **Reddit Draft**: Go to `r/onebag` or `r/packing` and read rules. Tweak Draft 01 based on rules.
