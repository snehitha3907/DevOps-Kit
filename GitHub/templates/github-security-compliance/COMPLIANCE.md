---
last_verified: 2026-10-14
tool_version: n/a
sources: []
---

# Compliance Checklist

A declarative checklist of the security and compliance controls enforced by this template. Use it during repository setup, audit reviews, and compliance assessments to verify that every control is present and active.

## Scope

This checklist documents the baseline controls that this template enforces through repository-hosted files. It is not a replacement for a full compliance audit; it records the controls that are version-controlled and therefore inspectable in every clone.

## Control Inventory

| Control | File | Compliance Domain |
|---|---|---|
| Vulnerability disclosure policy | `SECURITY.md` | Vulnerability Management |
| Dependency update reviews | `.github/dependabot.yml` | Vulnerability Management / Dependency Hygiene |
| Security review on sensitive files | `.github/CODEOWNERS` | Change Management / Segregation of Duties |
| Security checklist on every PR | `.github/PULL_REQUEST_TEMPLATE.md` | Change Management / Secure Development |

## Review Procedure

1. Confirm every file in the Repository Structure exists on the default branch.
2. Open a pull request that modifies `SECURITY.md`; confirm the security team is automatically requested as a reviewer through `CODEOWNERS`.
3. Confirm Dependabot has opened at least one security-update pull request in the last 30 days (or record the dependency surface as none).
4. Visit the repository's Security tab to review active Dependabot alerts and secret-scanning alerts.

## Exceptions

Any control may be intentionally disabled with written approval from the security team. Document the exception under an entry keyed by date and control name, and retain it for audit review.
