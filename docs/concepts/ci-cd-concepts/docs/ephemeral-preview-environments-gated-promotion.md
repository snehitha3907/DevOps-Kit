---
last_verified: 2026-09-16
tool_version: n/a
---

# How I wired preview-environment gates into a multi-environment deployment workflow

## Purpose

This pattern combines CI/CD pipeline design with containerization and infrastructure-as-code so that every pull request gets its own short-lived preview environment, and only a preview that passes its gates is allowed to move toward staging and then to a manually approved release. The preview is the first gate; staging validation is the second; a human approval is the last one.

## When to use

This fits when a team already deploys the same artifact through dev, staging, and a final environment, and wants earlier signal than "it worked on my branch." It is worth the extra automation when broken changes regularly reach staging and waste everyone's time.

It is overkill for single-environment setups, for static content with nothing to run per request, or for teams where staging is already cheap and fast enough to serve as the first check.

## Prerequisites

- One container registry where each commit gets an immutable tag (commit SHA works).
- A cluster or runtime that can host several small copies of the app side by side, one per open pull request.
- Separate configuration overlays (or namespaces) for preview, staging, and the final environment so a preview can never borrow staging credentials.
- A CI system that can report a pass/fail status back onto the pull request.

## The workflow I built

### 1. Build the artifact once per commit

Each push builds a single image tagged with the commit SHA and pushes it to the registry. Every later stage reuses that exact tag. Rebuilding per environment would invalidate whatever the preview just proved, so promotion always moves the tag, never a fresh build.

### 2. Spin up a preview environment for the pull request

When the pull request opens, automation deploys the SHA-tagged image into a fresh preview slot with its own hostname and its own seeded demo data. The preview runs the same health checks the later environments will run: readiness probe passes, seed migration applies cleanly, and the login-to-checkout smoke path returns success.

The pull request gets a single status line pointing at the preview URL. Reviewers click through the actual change instead of guessing from a diff.

### 3. Tear the preview down automatically

Previews are the part teams forget, and forgotten previews turn into a second staging that nobody trusts. Every preview carries the pull-request number as a label, and two rules keep the fleet clean: closing or merging the request deletes its preview, and a nightly job deletes any preview older than a few days whose request is already closed. This pattern combines CI/CD automation with basic resource hygiene — the teardown is a scheduled pipeline step, not a manual chore.

### 4. Promote to staging only after the preview passes

Merging to the main branch promotes the same SHA tag to staging. Staging repeats the preview checks plus a short load burst and a policy re-check (no public storage, encryption on, required tags present). If any of these fail, the promotion stops and the team fixes forward on a new pull request — staging never gets patched by hand.

### 5. Hold the final environment behind an approval

The last environment deploys only after an explicit approval that shows the reviewer the plan diff and the staging results. On approval the saved plan applies, a small share of traffic shifts first, and the rollout completes only if error rate and latency stay flat during the canary window. What I got wrong the first time was approving releases from a bare "ready" message; showing the diff and the staging evidence in the approval request stopped most rubber-stamping.

## Verify

After wiring this up, check:

- Opening a pull request produces a reachable preview with the commit SHA running, reported back as a status on the request.
- Breaking the smoke path in a branch blocks its preview status, and the request cannot promote until it is fixed.
- Merging promotes the identical SHA tag to staging — no rebuild, no retag.
- Closing a request without merging removes its preview, and the nightly cleanup finds nothing left behind.
- The final environment stays untouched until someone explicitly approves with the diff and staging evidence attached.

## Common errors

- **Rebuilding per environment** — a fresh build for staging means the preview validated a different binary. Promote the tag instead.
- **Previews sharing staging data** — pointing a preview at the staging database turns every experiment into a potential outage. Seed each preview with its own data.
- **No teardown rule** — previews without automatic deletion pile up until nobody knows which ones are live. Label by request number and delete on close plus a nightly sweep.
- **Approval without evidence** — asking for approval with no diff and no staging results gets you a reflex click. Attach both to every request.
