# Runbook: Daily Operations

**Project**: `packing-wins-lab`
**Focus**: 콘텐츠 자동화 + 제휴 링크 + 11채널 배포

---

## 📅 Daily Loop (매일 30~60분)

### A. TiCo (3분)

```powershell
# 오늘 출력 1개 즉시 생성
opencode run -m <GOOGLE_MODEL_ID> -f .\PROMPTS\AG_DAILY_TICO.txt --title "Daily TiCo" "Today's task: ___"
```

### B. 실행 (20~40분)

```powershell
# 1. Publish Gate Regression (회귀 테스트)
.\scripts\publish-gate-regression.ps1

# 2. Pack 생성 (예: Pack 01)
.\scripts\generate_day0_packs.ps1

# 3. DryRun Gate Check
Get-Content .\outputs\day0\pack_01\caption_core9.json | .\scripts\publish-gate.ps1 -Mode "DryRun"
```

### C. 검증 (5~10분)

```powershell
# 1. Publish Gate 재검증
.\scripts\publish-gate-regression.ps1

# 2. Policy Snapshot (주 1회)
.\scripts\policy-update.ps1 -Action update
.\scripts\policy-update.ps1 -Action summarize
```

### D. 기록 (2분)

```powershell
# TASK.md에 오늘 한 줄 제안 + 접촉/제안/전환 + 내일 TiCo 작성
notepad .\TASK.md
```

---

## 📋 Daily Checklist (복붙용)

```markdown
## Today's Tasks

- [ ] TiCo 1개 생성
- [ ] Publish Gate Regression 통과
- [ ] Pack 1개 생성
- [ ] DryRun Gate Check 통과
- [ ] 배포 큐에 추가
- [ ] 회귀 테스트 1개 이상 통과
- [ ] 기록 완료 (TASK.md)
```

---

## 🔑 Daily Commands (5개)

```powershell
# 1. TiCo 생성 (3분)
opencode run -m <GOOGLE_MODEL_ID> -f .\PROMPTS\AG_DAILY_TICO.txt --title "Daily TiCo" "Today's task: ___"

# 2. Publish Gate Regression (필수)
.\scripts\publish-gate-regression.ps1

# 3. Pack 생성
.\scripts\generate_day0_packs.ps1

# 4. DryRun Gate Check
Get-Content .\outputs\day0\pack_01\caption_core9.json | .\scripts\publish-gate.ps1 -Mode "DryRun"

# 5. Policy Snapshot (주 1회)
.\scripts\policy-update.ps1 -Action update; .scripts\policy-update.ps1 -Action summarize
```

---

## 🚨 Gate Rules (Publish Gate)

- **Disclosure**: 모든 포스트에 `#ad` 또는 "This post contains..." 포함
- **Links**: 오직 1개 링크만 (링크허브 URL)
- **Reddit**: Draft 모드만 (reddit.publish = false)
- **No Risk Claims**: "Guaranteed", "100% success" 등 절대 금지

---

## 📊 Weekly Loop (매주 45~90분)

### 1. Policy Snapshot

```powershell
.\scripts\policy-update.ps1 -Action update
.\scripts\policy-update.ps1 -Action summarize
```

### 2. Publish Gate 회귀케이스 5개 추가

- 실패 로그에서 추출
- `scripts/publish-gate-regression.ps1`에 추가

### 3. 승자 분석

- 콘텐츠: 상위 20% 포맷 1개만 확장
- 앱: 핵심행동 전환 병목 1개만 개선
- 리서치: Authority/Timeliness 가중치 프리셋 재튜닝

---

## 🎯 Priority Formula

`(문제의 크기 × 지불의지 × 반복성) ÷ 투입시간 ≥ 3`

### Today's Priority

1. Pack 01 Publish Gate 통과
2. Pack 01 배포 준비
3. 회귀 테스트 1개 이상 통과
4. 기록 완료

---

## 📁 File Structure

```
packing-wins-lab/
├── TASK.md              # 오늘 할 일
├── BACKLOG.md           # 백로그 (30개)
├── DECISIONS.md         # 중요 결정
├── CHANGELOG.md         # 변경 로그
├── RUNBOOK.md           # 이 파일 (데일리 런북)
├── RUNBOOK_DAY0.md      # Day 0 부팅 가이드
├── SLASH_COMMANDS.md    # 슬래시 커맨드 치트시트
├── ONE_LINER_COMMANDS.md # 1줄 커맨드 모음
├── scripts/
│   ├── publish-gate-regression.ps1
│   ├── generate_day0_packs.ps1
│   ├── publish-gate.ps1
│   ├── policy-update.ps1
│   └── smoke-test.ps1
└── outputs/
    └── day0/
        └── pack_01/
            ├── script.md
            └── caption_core9.json
```

---

## 🔄 Troubleshooting

### Problem: Publish Gate 통과 실패

**Diagnosis**:

1. Disclosure 있는지 확인
2. Link count == 1인지 확인
3. Risk claims 있는지 확인

**Solution**:

```powershell
# 자동 수정
Get-Content .\outputs\day0\pack_01\caption_core9.json | .\scripts\publish-gate.ps1 -Mode "DryRun"
```

### Problem: Reddit Publish 실패

**Diagnosis**:

- Reddit Draft-only 체크

**Solution**:

```powershell
# Reddit publish = false 확인
Select-String -Path .\ops\DISTRIBUTION_RULES.md -Pattern "reddit\.publish\s*=\s*false"
```

---

## 📚 Reference Documents

| Document              | Purpose                | Location      |
| --------------------- | ---------------------- | ------------- |
| RUNBOOK_DAY0.md       | Day 0 부팅 가이드      | 프로젝트 루트 |
| SLASH_COMMANDS.md     | 슬래시 커맨드 치트시트 | 프로젝트 루트 |
| ONE_LINER_COMMANDS.md | 1줄 커맨드 모음        | 프로젝트 루트 |
| BACKLOG.md            | 백로그 (30개)          | 프로젝트 루트 |
| TASK.md               | 오늘 할 일             | 프로젝트 루트 |

---

## Last Updated

**Date**: 2026-01-08
**Version**: v1.0
**Status**: Daily Loop Ready
