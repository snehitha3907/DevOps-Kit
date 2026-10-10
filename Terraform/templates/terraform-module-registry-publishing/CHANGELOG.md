# Changelog

All notable changes to this module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- 

### Changed
- 

### Deprecated
- 

### Removed
- 

### Fixed
- 

### Security
- 

## [1.0.0] - YYYY-MM-DD

### Added
- Initial module release
- S3 bucket for module artifacts with versioning and encryption
- Basic example configuration
- Integration tests with Terratest
- Publishing workflow for Terraform Registry

---

## Version Format

Versions follow Semantic Versioning (MAJOR.MINOR.PATCH):
- MAJOR: Incompatible API changes
- MINOR: Backwards-compatible functionality
- PATCH: Backwards-compatible bug fixes

## Release Process

1. Update CHANGELOG.md with release notes
2. Commit changes: `git commit -am "chore: release vX.Y.Z"`
3. Create tag: `git tag vX.Y.Z`
4. Push tag: `git push origin vX.Y.Z`
5. GitHub Actions workflow publishes to Terraform Registry