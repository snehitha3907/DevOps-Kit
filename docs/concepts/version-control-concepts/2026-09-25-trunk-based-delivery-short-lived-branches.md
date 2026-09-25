---
last_verified: 2026-09-25
tool_version: n/a
sources:
  - https://trunkbaseddevelopment.com/
  - https://github.blog/2020-07-27-introducing-github-code-owners/
  - https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/managing-rulesets-for-a-repository
---

# Trunk-based delivery with short-lived branches: protecting main, merge queues, and CODEOWNERS

> First-day notes on trunk-based delivery patterns. What it is, why it matters for DevOps, and the key mechanisms to implement it.

## What is it?

Trunk-based development is a version control strategy where all developers commit to a single shared branch (traditionally `main` or `trunk`) using short-lived feature branches that last hours to a day or two, not weeks. It's like everyone working on the same document simultaneously with careful section locking, rather than each person making a private copy for weeks and then trying to merge conflicting changes.

The core idea: integrate frequently, keep branches tiny, and protect the shared branch with automated gates.

## Why does it matter for DevOps?

Long-lived feature branches create merge hell — the longer a branch lives apart from `main`, the more painful the integration. In DevOps, we want fast feedback: if a change breaks tests or deploys, we need to know *now*, not two weeks later during a massive merge. Trunk-based delivery enables:

- **Continuous integration** — every push to `main` triggers the full pipeline
- **Fast rollback** — small commits mean small blast radius when things break
- **Deploy on demand** — `main` is always deployable; no "release branch" ceremonies

## Key terminology

- **Trunk / main branch** — the single integration branch that represents production-ready code
- **Short-lived branch** — a feature branch lasting < 1 day, merged via PR after CI passes
- **Branch protection rules** — required checks, reviews, and status gates before merge
- **Merge queue** — serializes PR merges to prevent race conditions; re-tests each PR against latest `main` before merging
- **CODEOWNERS** — file mapping code paths to required reviewers; enforces domain expertise on changes
- **Rulesets** — GitHub's newer, more powerful replacement for branch protection (supports bypass lists, status checks, required workflows)
- **Stale branch** — a branch with no commits or PR activity for N days; cleanup target

## A concrete example

**Branch protection via GitHub ruleset (YAML for `gh api` / Terraform):**

```yaml
# .github/rulesets/trunk-protection.json
{
  "name": "Protect main branch",
  "target": "branch",
  "enforcement": "active",
  "conditions": {
    "ref_name": { "include": ["refs/heads/main"], "exclude": [] }
  },
  "rules": [
    { "type": "required_status_checks", "parameters": {
        "strict_required_status_checks_policy": true,
        "required_status_checks": [
          { "context": "ci/lint", "integration_id": 12345 },
          { "context": "ci/test", "integration_id": 12345 },
          { "context": "ci/build", "integration_id": 12345 }
        ]
      }
    },
    { "type": "pull_request", "parameters": {
        "required_approving_review_count": 1,
        "dismiss_stale_reviews_on_push": true,
        "require_code_owner_review": true
      }
    },
    { "type": "merge_queue", "parameters": {
        "merge_method": "merge",
        "build_concurrency": 5
      }
    }
  ],
  "bypass_actors": [{ "actor_id": 98765, "actor_type": "Team", "bypass_mode": "pull_request" }]
}
```

**CODEOWNERS example:**

```
# .github/CODEOWNERS
*                           @org/platform-team
/infra/terraform/**         @org/infra-team
/k8s/**                     @org/platform-team @org/sre-team
/docs/**                    @org/docs-team
/scripts/**                 @org/platform-team
```

*Caption: Protecting `main` with required checks, code owner reviews, and a merge queue. CODEOWNERS routes infra changes to infra team, k8s to platform+SRE.*

## How this connects to what's next

Next I'll practice auditing branch hygiene with a Python script — finding stale branches, measuring PR cycle time, and identifying branches that violate the "short-lived" principle. This connects to CI/CD metrics and repository governance.