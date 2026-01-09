# Changelog

All notable changes to the Feedback Playbook will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.1] - 2026-01-09

### Added

- Feedback Playbook v1.1.1 package with comprehensive templates
- Verify script (`verify-feedback-pack.ps1`) for package validation
- GitHub Actions workflows for regression and performance testing
- Pack generation script (`generate_day0_packs.ps1`)
- Policy update script (`policy-update.ps1`)
- Publish gate regression test suite
- Smoke test suite
- Daily loop documentation (RUNBOOK.md)
- Day 0 boot documentation (RUNBOOK_DAY0.md)
- TASK.md template for daily tracking

### Changed

- Updated documentation structure for better organization
- Improved script modularity and reusability
- Enhanced error handling in all scripts

### Fixed

- Initial release setup and configuration

### Security

- Added sensitive data filtering in data generation scripts
- Implemented content validation gates for publish operations

---

## [1.1.0] - 2026-01-08

### Added

- Initial project structure
- Basic publish gate functionality
- Core documentation files

---

## [1.0.0] - 2026-01-01

### Added

- Project initialization
- Core framework setup
