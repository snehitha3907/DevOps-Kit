# Git workflows comparison: feature branch vs GitFlow vs trunk-based development

## Purpose

Once a team moves past one or two developers, agreeing on a branching strategy is one of the first process decisions that comes up. The three most commonly referenced approaches — feature branch workflow, GitFlow, and trunk-based development — all solve the same core problem: how to isolate, review, and integrate changes without stepping on each other. But they make very different trade-offs around release cadence, collaboration overhead, and deployment risk.

This doc walks through each workflow with a concrete scenario, then compares them side by side. It is meant as a starting point — the right choice depends on team size, release model, and how mature the CI/CD pipeline is.

## Feature Branch workflow

### How it works

Every new piece of work gets its own branch off `main`. Work, commit, push. When ready, open a pull request. After review and any CI checks, the branch merges back to `main`.

```bash
git checkout -b feat/add-login
# ... work, commit ...
git push -u origin feat/add-login
# Open PR via GitHub/GitLab UI
# After merge: delete the remote branch
git push origin --delete feat/add-login
```

Branches are short-lived — typically a few hours to a couple of days.

### When it fits

Teams that use GitHub or GitLab as their collaboration hub. It pairs naturally with PR templates, required reviews, and branch protection rules. It is the default pattern for open-source projects and most SaaS teams that deploy continuously.

### Trade-offs

- **Pros**: Simple to understand; PRs create a natural review gate; each branch is a self-contained unit of work.
- **Cons**: Branch-per-feature can drift from `main` if the work takes more than a day; merge conflicts become more likely the longer a branch lives.

## GitFlow

### How it works

Two long-lived branches: `main` (production-ready code) and `develop` (integration branch for the next release). Supporting branches branch off these:

- **Feature branches** off `develop`, merge back to `develop`.
- **Release branches** off `develop`, merge to `main` and back to `develop`.
- **Hotfix branches** off `main`, merge to both `main` and `develop`.

```bash
# Feature
git checkout -b feat/new-dashboard develop
# ... work, commit, PR into develop ...

# Release
git checkout -b release/1.2.0 develop
# ... final tweaks, bump version ...
git checkout main && git merge release/1.2.0 --no-ff
git checkout develop && git merge release/1.2.0 --no-ff

# Hotfix
git checkout -b hotfix/1.2.1 main
# ... fix, commit ...
git checkout main && git merge hotfix/1.2.1 --no-ff
git checkout develop && git merge hotfix/1.2.1 --no-ff
```

### When it fits

Projects with a scheduled release cycle (every two weeks, monthly). Mobile apps or shipped software where `main` must always reflect what is in production and `develop` carries work for the next release.

### Trade-offs

- **Pros**: Clear separation between in-progress work, release candidates, and production hotfixes. Well-documented — the original blog post is still the canonical reference.
- **Cons**: Heavy branch graph. The `develop` branch adds overhead and many teams find the ceremony does not pay off unless they actually do release branches. GitHub's `--no-ff` default merge can make the history harder to read than the original GitFlow intended with `--no-ff` on `develop` and fast-forward on `main`.

## Trunk-based development

### How it works

Everyone works on short-lived branches (hours to a day at most) off a single `main` branch. Incomplete work is hidden behind feature flags. Branches merge back to `main` multiple times a day. No long-lived feature branches and no `develop` branch.

```bash
git checkout -b feat/payment-validation
# ... small change, commit ...
git push origin feat/payment-validation
# Quick PR or direct push if the team trusts direct pushes
git checkout main && git pull
git merge feat/payment-validation --ff-only
```

The `--ff-only` is a common safeguard: if the merge cannot fast-forward, the branch has drifted and should be rebased first.

### When it fits

Teams practicing continuous delivery — deploy on every merge to `main`. Organisations with mature automated testing and feature-flag infrastructure. Typical in SaaS and platform engineering teams.

### Trade-offs

- **Pros**: Minimal merge conflicts (branches are tiny); `main` is always deployable; no release branches means releases are whatever is on `main` right now.
- **Cons**: Requires discipline — branches cannot sit for days. Feature flags add infrastructure complexity. Not a natural fit for shipped software or release-gated products.

## Comparison

| Aspect | Feature Branch | GitFlow | Trunk-based |
|--------|---------------|---------|-------------|
| Long-lived branches | `main` only | `main` + `develop` | `main` only |
| Branch lifetime | Hours–days | Days–weeks | Hours |
| Release model | Continuous or batch | Scheduled releases | Continuous |
| PR/review overhead | Moderate | High (more branches to manage) | Low–moderate |
| Merge conflict risk | Moderate | High (long-lived branches) | Low |
| CI/CD maturity needed | Basic | Moderate | High (feature flags, automated tests) |
| Best for | Most GitHub/GitLab teams | Shipped software, mobile | SaaS, CD teams |

## Choosing a workflow

There is no single correct answer. The doc above lays out three patterns that cover most of what teams actually do, and the table highlights the trade-offs at a glance. A few signals that can help decide:

- **Deploy on every merge to `main`?** Trunk-based is the natural fit; feature branch workflow also works with a squash-merge or rebase strategy.
- **Need to support multiple in-flight releases?** GitFlow's release branches give you that structure, but the same thing can be done with tags and release branches on a simpler feature-branch setup.
- **Team is new to Git or the project is small?** Feature branch workflow is the easiest to learn and the hardest to get wrong.
- **CI pipeline is still being built?** Avoid trunk-based until automated tests and rollback are reliable. Feature branch workflow gives you a safety net via PRs and review gates.

The workflows here are starting points — most teams end up adapting one rather than following it verbatim.

## Verify

Run through a quick thought experiment with the team's actual workflow:

1. How long does a typical branch live? (Hours → trunk-based candidate. Days → feature branch. Weeks → consider why.)
2. Can `main` be deployed at any time? If the answer is no, feature flags or a `develop` branch may be needed.
3. How many releases are maintained simultaneously? More than one points toward GitFlow-style release branches.

## Common errors

**Treating the workflow as a strict rule.** The original GitFlow post is explicit that it is a model, not a law. Teams that follow every branch rule without adapting to their own release cadence often end up with ceremony that slows them down.

**Long-running feature branches in a feature-branch setup.** A branch that lives more than a day or two without merging back to `main` accumulates drift. The fix is to merge `main` into the branch frequently, or better, to keep branches small enough that they merge within a day.

**Assuming trunk-based means no branches at all.** Even trunk-based teams use short-lived branches. The difference is lifespan, not existence.

## References

- [Feature Branch Workflow (Atlassian)](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow)
- [A successful Git branching model (nvie/GitFlow)](https://nvie.com/posts/a-successful-git-branching-model/)
- [Trunk-Based Development (trunkbaseddevelopment.com)](https://trunkbaseddevelopment.com/)
