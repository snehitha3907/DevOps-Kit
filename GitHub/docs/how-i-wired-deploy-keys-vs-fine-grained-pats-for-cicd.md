# How I wired GitHub deploy keys vs fine-grained PATs for CI/CD access

## Purpose

CI/CD pipelines need to interact with GitHub repositories — clone code, push tags, create releases, or trigger workflows. GitHub offers two main auth mechanisms for this: **deploy keys** (SSH-based, single-repo scope) and **fine-grained PATs** (token-based, cross-repo scope). This doc walks through how I wired both and when each made sense.

## Deploy keys

Deploy keys are SSH public keys you register on a specific repository. They grant read-only or read-write access to just that one repo.

### When they fit

- A pipeline only needs to clone a single private repo.
- You want the narrowest possible permission — even if the token leaks, only one repo is exposed.
- The CI runner already has SSH agent infrastructure.

### Setup steps

1. Generate a dedicated deploy key on the CI runner (no passphrase, since it needs to run unattended):

   ```bash
   ssh-keygen -t ed25519 -C "ci-deploy-key" -f /path/to/ci-deploy-key -N ""
   ```

2. Copy the public key to the repo's deploy keys page: **Settings → Deploy keys → Add deploy key**.
   - Check "Allow write access" only if the pipeline pushes (e.g., tag bumps, auto-commits).

3. Configure the runner's SSH to use this key for GitHub:

   ```
   # ~/.ssh/config
   Host github.com
       IdentityFile /path/to/ci-deploy-key
       StrictHostKeyChecking accept-new
   ```

4. Test with a clone:

   ```bash
   git clone git@github.com:owner/repo.git
   ```

### What tripped me up

- Deploy keys cannot access forks — if the pipeline runs on a fork (e.g., from a contributor PR), the fork can't use the parent repo's deploy key.
- A single SSH key per repo means you need N keys for N repos. That gets messy fast.
- Write-enabled deploy keys are per-repo, so pushing to multiple repos (like a release that updates a dependent repo) requires multiple keys.

## Fine-grained PATs

Fine-grained PATs are tokens scoped to specific repositories and permissions. They authenticate via HTTPS.

### When they fit

- The pipeline touches multiple repositories (e.g., a release workflow that updates a changelog in repo A and publishes to repo B).
- You need API access beyond git operations (create issues, manage workflow runs, etc.).
- The CI runner doesn't have SSH configured or secrets management handles tokens more naturally.

### Setup steps

1. Create a fine-grained PAT:
   - **GitHub.com → Settings → Developer settings → Personal access tokens → Fine-grained tokens → Generate new token**.
   - Set the token name (e.g., `ci-cd-access`).
   - Set expiration — I used 90 days and set a calendar reminder to rotate it. GitHub sends a reminder email 7 days before expiry.
   - Under **Repository access**, select "Only select repositories" and pick the repos the pipeline needs.
   - Under **Permissions**, select the minimum needed:
     - `Contents: Read` for cloning (add `Write` if pushing).
     - `Metadata: Read` (auto-granted for selected repos).
     - `Pull requests: Read/Write` if the pipeline creates PRs.
     - `Workflows: Read/Write` if the pipeline updates workflow files.

2. Store the token as a CI secret. In GitHub Actions:

   ```yaml
   - name: Checkout
     uses: actions/checkout@v4
     with:
       token: ${{ secrets.CI_PAT }}
   ```

   For other CI systems, add the token as a secret environment variable and use it in place of a password:

   ```bash
   git clone https://x-access-token:${CI_PAT}@github.com/owner/repo.git
   ```

3. Verify with a quick API call:

   ```bash
   curl -H "Authorization: token $CI_PAT" \
        -H "Accept: application/vnd.github.v3+json" \
        https://api.github.com/repos/owner/repo
   ```

   A 200 response means the token has access.

### What tripped me up

- Fine-grained PATs are tied to the user who created them. If that person leaves the org, the token stops working. I switched to a machine-user account for CI tokens.
- The permissions UI is granular — I initially missed `Contents: Write` when trying to push a tag, and the push failed with a 403 that took a while to trace back to the missing permission.
- Token expiry is a feature, not a bug — but forgetting to rotate it breaks the pipeline at the worst moment. I set up a GitHub Actions workflow to check token expiry weekly and post a warning issue.

## Comparing the two

| Aspect | Deploy key | Fine-grained PAT |
|---|---|---|
| Auth type | SSH public key | Token (HTTPS) |
| Scope | Single repo | Selected repos + permissions |
| Git operations | Clone, push (if write-enabled) | Clone, push |
| API access | No | Yes |
| Rotation | Replace key on runner + GitHub | Regenerate token, update secret |
| Fork access | No | Yes (if scoped to the fork) |
| Machine-user needed | No | Recommended for team pipelines |
| Setup complexity | SSH config + GitHub UI | GitHub UI + secret store |

## Which one I chose

I ended up using **both** depending on the pipeline:

- **Deploy keys** for simple read-only clones in build pipelines that only touch their own repo. Minimal blast radius.
- **Fine-grained PATs** for anything that crosses repos or needs API access — release automation, dependency update PRs, or multi-repo test matrices.

One pattern I found useful: use a deploy key for the initial clone (it's fast, SSH is already trusted on the runner), then use a PAT for any cross-repo API calls inside the same workflow.

## Verify

To confirm either setup works end-to-end in CI:
1. Run a workflow that clones the target repo using the configured auth method.
2. Check that `git fetch` / `git push` succeeds (for write operations).
3. For PATs, call `curl https://api.github.com/repos/owner/repo -H "Authorization: token $PAT"` and verify 200.

## References

- [GitHub docs: Deploy keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys)
- [GitHub docs: Fine-grained PATs](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
