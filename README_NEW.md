# Feedback Playbook v1.1.1

A comprehensive playbook for content automation and feedback-driven content creation.

## Overview

Feedback Playbook v1.1.1 is a standardized package for creating, validating, and publishing content across multiple platforms with automated quality gates and regression testing.

## Features

- 📝 **Daily Loop**: Structured daily workflow for content creation
- 🚦 **Publish Gate**: Automated validation for published content
- 🧪 **Regression Testing**: Comprehensive test suite for quality assurance
- 📊 **Performance Monitoring**: Automated performance tests and benchmarks
- 🔄 **Pack Generation**: Automated content pack creation
- 📋 **Policy Management**: Dynamic policy updates and snapshots
- 🎯 **Task Management**: Integrated task tracking with TiCo (Three-Minute Context)
- 🛡️ **Security**: Content validation and sensitive data filtering

## Quick Start

```powershell
# 1. Clone the repository
git clone <repository-url>
cd packing-wins-lab

# 2. Verify the installation
.\scripts\verify-feedback-pack.ps1

# 3. Run daily operations (see RUNBOOK.md)
.\scripts\publish-gate-regression.ps1
```

## Documentation

| Document | Description |
|----------|-------------|
| [RUNBOOK.md](RUNBOOK.md) | Daily operations guide (30-60min loop) |
| [RUNBOOK_DAY0.md](RUNBOOK_DAY0.md) | Day 0 boot and setup instructions |
| [TASK.md](TASK.md) | Today's tasks and TiCo tracking |
| [BACKLOG.md](BACKLOG.md) | Project backlog (30 items) |
| [CHANGELOG.md](CHANGELOG.md) | Version history and changes |

## Available Scripts

### Validation & Testing

```powershell
# Verify Feedback Playbook installation
.\scripts\verify-feedback-pack.ps1

# Run publish gate regression tests
.\scripts\publish-gate-regression.ps1

# Run smoke tests
.\scripts\smoke-test.ps1
```

### Content Generation

```powershell
# Generate Day 0 packs
.\scripts\generate_day0_packs.ps1

# Validate content with publish gate
.\scripts\publish-gate.ps1 -Platform "tiktok" -Text "Your content" -IsAffiliate $true
```

### Policy Management

```powershell
# Update policy snapshots
.\scripts\policy-update.ps1 -Action update
.\scripts\policy-update.ps1 -Action summarize
```

### Runners

```powershell
# Main runner script
.\scripts\run.ps1
```

## Daily Loop (30-60 minutes)

The Feedback Playbook follows a structured daily workflow:

1. **TiCo (3min)**: Create today's task context
2. **Execute (20-40min)**: Run regression tests, generate packs, validate gates
3. **Verify (5-10min)**: Re-run regression tests, update policies
4. **Record (2min)**: Update TASK.md with results

See [RUNBOOK.md](RUNBOOK.md) for detailed instructions.

## Project Structure

```
packing-wins-lab/
├── .github/workflows/       # CI/CD workflows
│   ├── regression-tests.yml
│   └── performance-tests.yml
├── scripts/                 # Automation scripts
│   ├── verify-feedback-pack.ps1
│   ├── publish-gate-regression.ps1
│   ├── publish-gate.ps1
│   ├── generate_day0_packs.ps1
│   ├── policy-update.ps1
│   ├── smoke-test.ps1
│   └── run.ps1
├── eval/                    # Evaluation assets
│   ├── golden_set.jsonl
│   └── regression_cases_local.jsonl
├── outputs/                 # Generated content
│   └── day0/
├── TASK.md                  # Today's tasks
├── RUNBOOK.md               # Daily operations guide
├── RUNBOOK_DAY0.md          # Day 0 setup
├── BACKLOG.md               # Project backlog
├── CHANGELOG.md             # Version history
└── README.md                # This file
```

## Quality Gates

### Publish Gate

The publish gate enforces content quality standards:

- **Disclosure**: All affiliate content must include `#ad` or "sponsored"
- **Links**: Only one link allowed (linkhub URL)
- **Risk Claims**: No "guaranteed", "100%" or similar claims
- **Spam Detection**: Blocked keywords and spam patterns

### Regression Tests

Automated test suite covering:

- Content validation rules
- Disclosure requirements
- Link restrictions
- Risk claim detection
- Spam filtering

## CI/CD

### GitHub Actions

- **Regression Tests**: Runs on every push and PR to main
- **Performance Tests**: Runs on every push, PR, and daily at 2 AM UTC

### Required Status Checks

- `regression-tests.yml`
- `performance-tests.yml`

## Verification

Before deploying, verify your installation:

```powershell
.\scripts\verify-feedback-pack.ps1 -Verbose
```

This script checks:
- Core documentation files
- Script availability
- Evaluation assets
- Output structure
- Script execution
- Git repository status

## Contributing

1. Follow the daily loop in [RUNBOOK.md](RUNBOOK.md)
2. Update [TASK.md](TASK.md) with your progress
3. Run regression tests before committing
4. Follow conventional commit format
5. Update [CHANGELOG.md](CHANGELOG.md) for version changes

## Troubleshooting

### Publish Gate Failure

If publish gate fails:

1. Check disclosure is included
2. Verify only one link
3. Ensure no risk claims
4. Re-run validation with dry run mode

```powershell
Get-Content .\outputs\day0\pack_01\caption_core9.json | .\scripts\publish-gate.ps1 -Mode "DryRun"
```

### Regression Test Failure

If regression tests fail:

1. Review failing test cases
2. Check publish-gate.ps1 logic
3. Update regression_cases_local.jsonl if needed
4. Re-run tests

## Version History

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

- **v1.1.1** (2026-01-09): Feedback Playbook release
- **v1.1.0** (2026-01-08): Initial project structure
- **v1.0.0** (2026-01-01): Project initialization

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Support

For questions or support:
1. Check [RUNBOOK.md](RUNBOOK.md) for daily operations
2. Check [RUNBOOK_DAY0.md](RUNBOOK_DAY0.md) for setup issues
3. Review [CHANGELOG.md](CHANGELOG.md) for recent changes
4. Create an issue for bugs or feature requests

---

**Current Version**: v1.1.1
**Last Updated**: 2026-01-09
**Status**: ✅ Ready for Deployment
