---
last_verified: 2026-10-14
tool_version: n/a
sources: []
---

# Pull Request Review Checklist — Security & Compliance

## Description
Brief description of what this PR changes and why.

## Security Impact
- [ ] **Impact assessed** — classify as low, medium, or high.
- [ ] **No secrets introduced** — no credentials, tokens, or keys were added or modified.
- [ ] **New dependencies** — if any dependency was added, it has been reviewed for known vulnerabilities.
- [ ] **Input validation** — user-supplied input is validated and sanitized.

## Compliance Review
- [ ] **Compliance framework** — this change is consistent with the policy in `COMPLIANCE.md`.
- [ ] **Review gates** — the appropriate code owners have been requested for review.
- [ ] **Test coverage** — new logic is covered by tests or an equivalent review gate.

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Security scan (Dependabot alerts / secret scanning) clear

## Related Issues
Fixes #
Closes #

## Additional Notes
Any context reviewers should know, including rollback considerations.
