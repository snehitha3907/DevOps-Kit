---
last_verified: 2026-10-14
tool_version: n/a
sources: []
---

# GitHub Repository Security & Compliance Template

A reference collection of configuration files that embed security and compliance controls directly into a GitHub repository's version history. Copy these files into any repository to establish a baseline of dependency hygiene, review-gate enforcement, vulnerability disclosure, and auditable compliance — all declarative, so the controls travel with the code.

## Purpose

This template provisions four categories of security and compliance control through repository-hosted files:

1. **Vulnerability disclosure** — a `SECURITY.md` policy that exposes GitHub's private vulnerability-reporting channel.
2. **Dependency security** — a Dependabot configuration that opens security-update pull requests and assigns a security-team reviewer.
3. **Review-gate enforcement** — `CODEOWNERS` rules that make the security team automatic reviewers for security-sensitive files, plus a pull-request template that surfaces a security and compliance checklist on every PR.
4. **Compliance auditability** — a `COMPLIANCE.md` checklist that documents the controls in scope, so auditors and contributors can verify coverage.

## When to Use

- Bootstrapping a new repository that handles customer data or regulated workloads.
- Hardening an existing repository that lacks declarative security controls.
- Aligning with an organizational compliance framework (SOC 2, ISO 27001, PCI DSS) by recording mandatory review gates in the repository.
- Establishing a GitOps-aligned security baseline where every control is a file in version control.

## Prerequisites

- A GitHub repository (public or private) with administrator access to enable and configure security features.
- A security or platform team identity to serve as the security `CODEOWNERS` owner (a GitHub team such as `@security-team`).
- Dependabot and secret scanning enabled at the organization level (required for alerts to surface; these files assume organization-level enablement).

## Repository Structure

```
.
├── README.md
├── SECURITY.md
├── COMPLIANCE.md
└── .github/
    ├── CODEOWNERS
    ├── PULL_REQUEST_TEMPLATE.md
    └── dependabot.yml
```

## Usage

1. Copy every file from this template into the root of the target repository.
2. Replace `@security-team` in `.github/CODEOWNERS` with the team or individuals responsible for security review.
3. Customize `SECURITY.md` with the project's disclosure timeline, supported versions, and security contacts.
4. Commit and push the files; GitHub begins enforcing the declared controls immediately.

## Verify

After installing the template, confirm each control is active:

- **Vulnerability disclosure** — open the repository's Security tab; the "Report a vulnerability" button should be enabled and `SECURITY.md` should render as the security policy.
- **Dependabot alerts** — navigate to Security → Dependabot alerts; dependency vulnerabilities should populate on the next repository scan.
- **Code owners** — open a pull request that modifies a file matched by `CODEOWNERS`; the designated security reviewer should be automatically requested.
- **PR checklist** — open a new pull request; the security and compliance checklist from `PULL_REQUEST_TEMPLATE.md` should render in the description.

## Common Errors

| Symptom | Likely Cause | Resolution |
|---|---|---|
| Dependabot creates no alerts | `dependabot.yml` is at the wrong path or the YAML is malformed | Place the file at `.github/dependabot.yml` and validate the YAML syntax |
| CODEOWNERS rules are ignored | A `CODEOWNERS` file exists in a conflicting location | GitHub checks `.github/CODEOWNERS` first; remove duplicates in other locations |
| Security policy does not appear | The file is not named exactly `SECURITY.md`, or it is empty | Rename to `SECURITY.md` and ensure it contains content |
| Pull-request template does not render | The file is outside `.github/` or named incorrectly | Place it at `.github/PULL_REQUEST_TEMPLATE.md` |

## Rollback

To remove these security and compliance controls from a repository, delete every file listed in the Repository Structure. Controls deactivate within minutes of the deletion reaching the default branch. No data is destroyed — historical alert records and pull-request reviews remain in the repository's audit log.

## References

- GitHub Security Policy documentation
- GitHub Dependabot documentation
- GitHub CODEOWNERS documentation
- GitHub Secret Scanning documentation
- OWASP Software Supply Chain Security guidance
