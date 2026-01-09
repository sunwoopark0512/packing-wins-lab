# One-Liner Commands Pack v1
**Goal**: Operate `packing-wins-lab` with single-line commands.
**Principle**: Publish Gate is the ONLY truth. Reddit is Draft-only.

## 0. Prerequisite
Run this once to pick your Google Model ID:
```powershell
opencode models --refresh
```
*Replace `<GOOGLE_MODEL_ID>` below with your chosen ID (e.g., `google/gemini-2.5-pro`).*

## 1. Day 0 Boot (If not done)
```powershell
opencode run -m <GOOGLE_MODEL_ID> -f .\PROMPTS\AG_BOOT_DAY0.txt --title "packing-wins-lab Day0" "Attach AG_BOOT_DAY0.txt as prompt. Maintain placeholder links. output: file path + content."
```

## 2. Publish Gate Regression (Mandatory Check)
```powershell
cd packing-wins-lab; .\scripts\publish-gate-regression.ps1
```

## 3. Pack 01 DryRun Gate Check
```powershell
cd packing-wins-lab; Get-Content .\outputs\day0\pack_01\caption_core9.json | .\scripts\publish-gate.ps1 -Mode "DryRun"
```

## 4. Pack 01 "Tighten for Gate" Rewrite
```powershell
cd packing-wins-lab; opencode run -m <GOOGLE_MODEL_ID> -f .\outputs\day0\pack_01\script.md -f .\outputs\day0\pack_01\caption_core9.json --title "Pack01 tighten" "Rewrite script/caption to stricter Gate rules: 1 link (placeholder), disclosure ON, no risk claims. Output: file path + new content."
```

## 5. Policy Snapshot (Weekly Update)
```powershell
cd packing-wins-lab; .\scripts\policy-update.ps1 -Action update; .\scripts\policy-update.ps1 -Action summarize
```

## 6. Reddit Draft-Only Check
```powershell
cd packing-wins-lab; Select-String -Path .\ops\DISTRIBUTION_RULES.md -Pattern "reddit\.publish\s*=\s*false"
```

## 7. Pre-Upload Checklist
- [ ] Disclosure included? (KO + EN)
- [ ] Link count == 1?
- [ ] Reddit is Draft only?
