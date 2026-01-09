# Slash Commands Reference

## Overview

This document provides a comprehensive guide to available slash commands in the OpenCode environment.

## Available Commands

| Command       | Description                                                                                                                                             | Arguments/Options                  | Example                                            |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- | -------------------------------------------------- |
| `/playwright` | Browser automation via Playwright MCP - verification, browsing, information gathering, web scraping, testing, screenshots, and all browser interactions | Varies by Playwright MCP operation | `/playwright` followed by browser automation tasks |

---

## `/help` 대체 커맨드 (Alternatives)

### Why `/help` Doesn't Exist

**Status**: A) `help` 커맨드 자체가 없음

- The system currently implements only one slash command: `/playwright`
- No general help command is configured in the skill system
- Alternative mechanisms must be used to discover commands

### Replacement Commands

#### 1. `/` (Empty or Invalid Command)

**Purpose**: Triggers error message that lists available commands

```bash
/
```

**Output**: Shows available commands and suggestions
**Verified**: ✅ Working - returns command list when invalid command entered

#### 2. `/playwright` (Direct Command Usage)

**Purpose**: Use the Playwright skill directly via slash command

```bash
/playwright
```

**Output**: Loads the Playwright MCP skill for browser automation tasks
**Verified**: ✅ Working - invokes Playwright skill

#### 3. `skill` Tool (Programmatic Alternative)

**Purpose**: Invoke skills programmatically instead of slash commands

```javascript
// Use the skill tool with explicit skill name
await skill({ name: 'playwright' })
```

**Output**: Same as `/playwright` but through tool invocation
**Verified**: ✅ Working - identical functionality to slash command

---

## Top 10 Frequently Used Commands

Currently, only **1 slash command** is available:

| Rank | Command       | Use Case                                               | Frequency |
| ---- | ------------- | ------------------------------------------------------ | --------- |
| 1    | `/playwright` | Browser automation, web scraping, testing, screenshots | High      |

**Note**: As more commands are added to the skill system, this table will be updated.

---

## 문제 해결 (Troubleshooting)

### 커맨드가 안 먹을 때 체크리스트 (7 Steps)

- [ ] **1. Command Syntax Check**
  - 커맨드 앞에 `/`가 붙어 있는지 확인
  - 스펠링이 정확한지 확인 (예: `/playwrigh` ❌ → `/playwright` ✅)

- [ ] **2. Skill Availability Check**
  - `slashcommand` tool로 현재 사용 가능한 커맨드 목록 확인
  - 해당 스킬이 현재 시스템에 설치/로드되어 있는지 확인

- [ ] **3. Context Verification**
  - 현재 작업 환경에서 해당 커맨드가 지원되는지 확인
  - 특정 모드/컨텍스트에서만 동작하는 커맨드인지 확인

- [ ] **4. Error Message Analysis**
  - 에러 메시지에 "not found"가 있으면 커맨드가 존재하지 않음
  - 에러 메시지에 "suggestion"이 있으면 제안된 대체 커맨드를 시도

- [ ] **5. Alternative Method Test**
  - 슬래시 커맨드 대신 `skill` tool 사용 시도
  - 스킬 이름이 정확한지 확인 (예: `skill({ name: "playwright" })`)

- [ ] **6. Documentation Reference**
  - 이 문서(`SLASH_COMMANDS.md`) 확인
  - `RUNBOOK_DAY0.md`의 슬래시 커맨드 확인 절차 섹션 참조

- [ ] **7. System Check**
  - `opencode` CLI가 최신 버전인지 확인
  - 스킬 시스템이 정상적으로 초기화되었는지 확인

---

## Context-Specific Commands

### OpenCode Environment

- Currently available commands:
  - `/playwright` - Built-in skill for browser automation
- Command discovery:
  - Use `slashcommand` tool to list all available commands
  - Check error messages for suggestions when entering invalid commands

### Other UIs (Future Expansion)

If additional UI systems are added (e.g., VS Code extension, web interface):

- Commands may differ between environments
- Always check the specific UI's documentation
- This document will be updated with environment-specific sections

---

## Command Usage Examples

### Example 1: Web Scraping with Playwright

```bash
/playwright
# Then use Playwright MCP operations:
# - Navigate to URL
# - Take screenshots
# - Extract content
# - Run tests
```

### Example 2: Browser Testing

```bash
/playwright
# Then:
# - Launch browsers (Chromium, Firefox, WebKit)
# - Interact with page elements
# - Verify behavior
# - Generate test reports
```

### Example 3: Programmatic Skill Invocation

```javascript
// Instead of slash command, use skill tool
await skill({ name: 'playwright' })
```

---

## Quick Reference

### Command Discovery

```bash
# Method 1: Enter invalid command to see list
/help

# Method 2: Use slashcommand tool (programmatic)
await slashcommand({ command: "/" })

# Method 3: Check this document
# See "Available Commands" section above
```

### Help Resources

1. **This Document**: `SLASH_COMMANDS.md`
2. **Runbook**: `RUNBOOK_DAY0.md` (see "Slash Commands" section)
3. **Error Messages**: Always read suggestions when commands fail

---

## Version History

| Version | Date       | Changes                                           |
| ------- | ---------- | ------------------------------------------------- |
| v1.0    | 2026-01-08 | Initial documentation of available slash commands |
| v1.1    | TBD        | Add more commands as they become available        |

---

## Last Updated

**Date**: 2026-01-08
**Verified By**: Sisyphus (OpenCode Agent)
**Available Commands**: 1
