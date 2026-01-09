# Contributing to Feedback Playbook

Thank you for your interest in contributing to Feedback Playbook! This document will help you get started.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Release Process](#release-process)

---

## Code of Conduct

### Our Pledge

In the interest of fostering an open and welcoming environment, we as contributors and maintainers pledge to make participation in our project and our community a harassment-free experience for everyone.

### Our Standards

Examples of behavior that contributes to creating a positive environment:
- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

---

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues as you might find that the bug is already reported.

When creating bug reports:
- Use a clear and descriptive title
- Provide as much detail as possible
- Include steps to reproduce
- Include environment information (OS, PowerShell version)
- Attach relevant logs or screenshots

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating enhancement suggestions:
- Use a clear and descriptive title
- Provide a detailed use case
- Explain why this enhancement would be useful
- Consider alternative implementations

### Contributing Code

We welcome code contributions! See the [Development Workflow](#development-workflow) section for details.

### Improving Documentation

Documentation improvements are always welcome! You can:
- Fix typos
- Clarify confusing sections
- Add examples
- Update outdated information

---

## Getting Started

### Prerequisites

- Windows 10 or 11 (or Windows PowerShell 5.1+)
- Git installed
- GitHub account
- PowerShell 5.1 or higher

### Clone the Repository

```powershell
git clone https://github.com/YOUR_USERNAME/packing-wins-lab.git
cd packing-wins-lab
```

### Run Verification

```powershell
.\scripts\verify-feedback-pack.ps1 -Verbose
```

### Run Tests

```powershell
# Run all tests
.\run_tests.bat

# Run specific test file
powershell -ExecutionPolicy Bypass -File "tests\verify-feedback-pack.tests.ps1"
```

---

## Development Workflow

### 1. Create Branch

```powershell
git checkout main
git pull
git checkout -b feature/your-feature-name
```

### 2. Make Changes

- Follow [Coding Standards](#coding-standards)
- Write tests for new functionality
- Update documentation
- Run verification script

### 3. Test Your Changes

```powershell
# Run verification
.\scripts\verify-feedback-pack.ps1

# Run tests
.\run_tests.bat

# Run regression tests
.\scripts\publish-gate-regression.ps1
```

### 4. Commit Changes

```powershell
git add .
git commit -m "feat: add your feature description"
```

Follow conventional commit format:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes
- `refactor:` Code refactoring
- `test:` Test additions/changes
- `build:` Build system changes
- `ci:` CI configuration changes
- `chore:` Maintenance tasks

### 5. Push Branch

```powershell
git push origin feature/your-feature-name
```

### 6. Create Pull Request

- Go to GitHub
- Click "New Pull Request"
- Use the pull request template
- Fill in all required fields

---

## Coding Standards

### PowerShell

#### Naming Conventions

- **Functions:** PascalCase with Verb-Noun pattern (e.g., `Get-ProjectType`, `Test-Check`)
- **Variables:** camelCase (e.g., `$projectName`, `$lastUpdated`)
- **Constants:** UPPER_SNAKE_CASE (if any)
- **Parameters:** PascalCase (e.g., `-ScanRoot`, `-DataOutputDir`)

#### Formatting

- Use 4-space indentation
- Use single quotes for strings (unless string contains single quotes)
- Use pipeline operations `|` when appropriate
- Avoid Write-Host in functions (use return values)

#### Error Handling

```powershell
try {
    # Code here
}
catch {
    Write-Error "Error: $_"
    exit 1
}
```

#### Comments

- Include function summaries
- Add comment for complex logic
- Document parameters and return values

```powershell
<#
.SYNOPSIS
    Brief description of function

.PARAMETER ParameterName
    Description of parameter

.OUTPUTS
    Description of return value

.EXAMPLE
    Example usage
#>
function Get-ProjectType {
    param([string]$ProjectPath)
    # Implementation
}
```

---

## Testing

### Unit Tests

- Write unit tests for all new functions
- Tests should be in `tests/` directory
- Use `*.tests.ps1` naming convention
- Aim for 80%+ code coverage

### Integration Tests

- Test interactions between components
- Verify end-to-end workflows
- Test with real data where possible

### Regression Tests

- Add new regression cases to `scripts/regression_cases_local.jsonl`
- Test for edge cases
- Verify fix doesn't break existing functionality

### Test Coverage Goals

- Helper functions: 100%
- File operations: 100%
- Script execution: 80%
- Error handling: 70%

---

## Pull Request Process

### Before Submitting

- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Code is commented where necessary
- [ ] Documentation updated
- [ ] New unit tests added
- [ ] All tests pass locally
- [ ] No new warnings

### Submitting PR

1. Create PR from your feature branch to main
2. Fill out the PR template completely
3. Link to related issues
4. Request review from maintainers
5. Wait for CI/CD checks to pass

### During Review

- Respond to review comments promptly
- Make requested changes or provide justification
- Keep PR focused on single change
- Re-run tests after changes

### After Merge

- Delete your feature branch
- Update local main branch
- Celebrate! 🎉

---

## Release Process

### Versioning

We follow Semantic Versioning (MAJOR.MINOR.PATCH):
- **MAJOR**: Incompatible API changes
- **MINOR**: Backwards-compatible functionality additions
- **PATCH**: Backwards-compatible bug fixes

### Release Checklist

- [ ] All tests passing
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Version number updated
- [ ] Tag created
- [ ] GitHub release created

### Creating a Release

1. Merge release branch to main
2. Update version in relevant files
3. Update CHANGELOG.md
4. Create tag: `git tag -a v1.x.x -m "Release v1.x.x"`
5. Push tag: `git push origin v1.x.x`
6. Create GitHub release with notes from CHANGELOG.md

---

## Getting Help

- Check [RUNBOOK.md](RUNBOOK.md) for operations guide
- Check [RUNBOOK_DAY0.md](RUNBOOK_DAY0.md) for setup guide
- Review existing issues for similar problems
- Create an issue if you can't find the answer

---

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Happy Contributing!** 🚀

Last Updated: 2026-01-09
Version: v1.1.1
