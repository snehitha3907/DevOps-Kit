---
last_verified: 2026-08-22
tool_version: n/a
---

# How I set up branch protection rules and required reviews for CI

## Purpose

I had a repo with a PR-checker workflow that ran on every pull request — and absolutely nothing
stopping me from pushing straight to `main` and skipping it. This doc records how I turned that
workflow into an actual gate: a pull request is now the only way into `main`, the CI job has to
report success, and at least one review has to be recorded before the merge button turns green.

Branch protection is a repo setting, not a CI feature. The workflow decides *what* gets checked;
protection decides *whether anyone is allowed to merge without it*.

## Prerequisites

- Admin permission on the repository (protection settings live under repo settings, not org settings).
- A workflow that already triggers on `pull_request` and has completed at least one run. This
  matters more than it sounds — see "What tripped me up".
- `gh` authenticated, if you want to configure protection from the CLI instead of the UI.

## What I decided to enforce

Before touching any settings I wrote down the rules I actually wanted, because the settings page
offers a lot of switches and it is easy to enable half of them and end up with a rule that blocks
nothing:

| Rule | Why I turned it on |
|---|---|
| Require a pull request before merging | Without this, protection only covers status checks on PRs while direct pushes sail through. |
| Require 1 approval | A second pair of eyes on anything landing on `main`. |
| Dismiss stale approvals on new commits | An approval of commit A should not carry over to a rewritten commit B. |
| Require status checks to pass | This is the link to CI — the PR-checker job becomes a merge gate. |
| Require branches to be up to date | Makes CI run against the code that will actually be on `main` after the merge. |
| Require conversation resolution | Stops "merged with 4 unresolved review comments". |

I deliberately left force pushes and branch deletion disabled for `main`, and left admin
enforcement off at first (more on that below).

## Steps — the settings UI

1. **Settings → Branches → Add branch protection rule** (GitHub also offers the newer *Rules →
   Rulesets* surface, which can layer several named rulesets over the same branch; I stayed on
   classic branch protection here because a single repo with one protected branch does not need
   the extra indirection).
2. Set the branch name pattern to `main`.
3. Check **Require a pull request before merging**, then set **Required number of approvals before
   merging** to 1 and check **Dismiss stale pull request approvals when new commits are pushed**.
4. Check **Require status checks to pass before merging**. A search box appears — type the name of
   the CI job and select it. Then check **Require branches to be up to date before merging**.
5. Check **Require conversation resolution before merging**.
6. Save. The rule takes effect immediately on the next PR.

## Steps — the same thing with `gh api`

Doing it through the API is worth knowing because it is reviewable and repeatable across repos.
The branch-protection endpoint is a `PUT` that replaces the whole rule, so every field you care
about has to be present in the payload — a partial body silently drops the settings you omitted.

`protection.json`:

```json
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["pr-checks"]
  },
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true
  },
  "restrictions": null,
  "required_conversation_resolution": true,
  "allow_force_pushes": false,
  "allow_deletions": false
}
```

```bash
gh api -X PUT "repos/$OWNER/$REPO/branches/main/protection" --input protection.json
```

Two fields deserve a note. `restrictions` is nullable but not optional — leaving it out is
rejected, and `null` means "no push allowlist". And `contexts` holds the *reported check names*,
which come from the job names in the workflow, not from the workflow file name.

## Verify

1. Read the rule back and confirm the fields landed:

   ```bash
   gh api "repos/$OWNER/$REPO/branches/main/protection" \
     --jq '{checks: .required_status_checks.contexts,
            strict: .required_status_checks.strict,
            approvals: .required_pull_request_reviews.required_approving_review_count}'
   ```

2. Try the thing the rule is supposed to stop:

   ```bash
   git commit --allow-empty -m "test: direct push should be rejected"
   git push origin main
   ```

   The push is rejected with a protected-branch message. That rejection *is* the test passing.

3. Open a real PR from a branch and watch the gate behave. I used the companion helper in this
   folder's sibling directory — [`../snippets/open-pr-and-wait-for-ci.sh`](../snippets/open-pr-and-wait-for-ci.sh) —
   which pushes the branch, opens the PR, and blocks until the checks report. While the checks are
   pending the merge button is disabled; once they pass it stays disabled until the review is in.

## What tripped me up

- **A check name that has never reported does not exist yet.** The status-check search box only
  offers checks GitHub has seen recently, so on a fresh repo there is nothing to pick. I had to
  open one throwaway PR to make the workflow run, and only then could I add its job to the rule.
- **Typing a context name by hand is a trap.** Via the API you can add any string you like. If it
  never reports, every PR sits at "Expected — waiting for status to be reported" forever. Renaming
  a workflow job has exactly the same effect: the rule keeps waiting on the old name.
- **"Require branches to be up to date" creates churn.** With `strict: true`, merging one PR makes
  every other open PR out of date, so each one needs an update and a fresh CI run. On a busy repo
  that is a queue problem; on this one it was fine.
- **One required approval in a solo repo is a deadlock** — you cannot approve your own PR. I kept
  `enforce_admins: false` so I could still merge as an admin while working alone, and treated that
  as a temporary state rather than the intended setup.
- **Protection is per-pattern, not per-repo.** My first rule was scoped to `master` on a repo whose
  default branch is `main`, so it protected a branch that did not exist. The settings page happily
  saved it.
