---
last_verified: 2026-08-03
tool_version: n/a
---

# Automating git bisect with scripted regression tests for CI and local development

## Purpose

`git bisect` performs a binary search through the commit history to find the exact revision that introduced a regression. In manual mode, the user answers "good" or "bad" for each step. That works for a single developer sitting at a terminal, but it does not scale when the same regression needs to be caught in CI, or when the test itself can be scripted. Automating bisect means wrapping the regression test in a script that returns a meaningful exit code, then letting `git bisect run` drive the entire search without human intervention. The result is a deterministic, repeatable process that works identically on a laptop and in a pipeline.

## When to use

Use scripted bisect when all of the following are true:

- A regression has been confirmed on `main` (or the relevant integration branch) but the introducing commit is unknown.
- There exists an automated test — unit, integration, or smoke — that fails on bad commits and passes on good ones.
- The regression range is large enough that manual stepping would be tedious (typically more than 20–30 candidate commits).
- The team wants to capture the offending commit in a CI run, not just as a local investigation.

Do not reach for bisect when the regression is fresh and the change set is small enough to review manually. Bisect assumes a monotonically bad state: the test must pass on the known-good bound and fail on the known-bad bound. If the test is flaky, bisect will produce unreliable results.

## Prerequisites

- A regression test that is deterministic. Flaky tests invalidate bisect because the binary search relies on consistent pass/fail signals.
- Two boundary commits: a known-good commit (before the regression) and a known-bad commit (after the regression). `git bisect start` accepts both explicitly.
- The repository must have a linear or near-linear history between the two bounds. A deeply tangled merge history increases the number of steps and can land bisect on a merge commit rather than the individual change that caused the failure.
- The test script must exit with code `0` for pass and a non-zero code for fail. `git bisect run` interprets any non-zero exit as "bad."

## Steps

### 1. Write the regression test script

The script should be self-contained: it checks out the current working tree (bisect does this automatically) and runs whatever commands prove the regression is present or absent.

```bash
#!/usr/bin/env bash
# regression-test.sh — exit 0 = good, exit 1 = bad

set -euo pipefail

# Example: run a pytest suite and fail on any error
pytest tests/ --tb=short -q
```

Keep the script focused on the single behavior that regressed. Do not include setup or teardown that bisect itself would interfere with (bisect moves HEAD frequently).

### 2. Start bisect and define boundaries

```bash
git bisect start
git bisect bad HEAD                   # current commit is known bad
git bisect good v1.4.0                # last known good tag or commit
```

`git bisect` picks the midpoint commit and checks it out. The working tree now reflects that revision.

### 3. Run bisect in automated mode

```bash
git bisect run ./regression-test.sh
```

`git bisect run` invokes the script, reads the exit code, and automatically marks the commit as good or bad. It then advances to the next midpoint. The loop continues until it isolates the first bad commit.

### 4. Record the result

When bisect finishes, it prints the offending commit hash and a summary. Record it — for example, by creating a note in the PR or issue that triggered the investigation.

```bash
git bisect log > bisect-log.txt   # optional: save the full search path
git bisect reset                   # return HEAD to its original position
```

### 5. Integrate into CI

In CI, the workflow is the same, but the boundaries are derived from the pipeline's known-good point (usually the previous successful deployment or the last green commit on the target branch). The script must be non-interactive and must not depend on state that bisect will invalidate (e.g., a build artifact directory that is not regenerated on each checkout).

```yaml
# Example: GitHub Actions job that runs bisect against a known-good SHA
- name: Find regression commit
  if: failure()
  run: |
    git fetch origin --unshallow || true
    git bisect start
    git bisect bad ${{ github.sha }}
    git bisect good ${{ env.LAST_GOOD_SHA }}
    git bisect run ./scripts/regression-test.sh
    git bisect reset
```

The `fetch` step is necessary when the CI checkout is shallow (depth = 1) — bisect requires the full history between the two boundaries.

## Verify

After the automated run completes:

1. Confirm the identified commit hash is within the expected range (between the good and bad boundaries).
2. Inspect the commit diff: the change at that commit should be related to the regression. If it is not, the test may be testing the wrong thing or the boundaries were set incorrectly.
3. Re-run the regression test script against the identified commit in isolation:

```bash
git checkout <offending-commit>
./regression-test.sh   # should exit 1
git checkout main
```

4. If bisect reports "fisrt bad commit is [hash]" and the test passes at that commit, the test is not monotonic — review the test for flakiness or incorrect boundaries.

## Common errors

**Shallow clone without full history.** CI systems often check out a single commit. Bisect cannot search history that is not present. Always unshallow or fetch enough history before starting bisect in CI.

**Flaky regression test.** If the test passes on some bad commits and fails on some good commits, bisect will isolate the wrong commit or report that no bad commit was found. Run the test repeatedly on known-bad and known-good commits before using it as the bisect driver.

**Including setup steps in the test script.** Bisect moves HEAD on every iteration. Any state created before bisect starts (virtualenv, node_modules, build caches) may be stale or absent after checkout. Regenerate all dependencies inside the test script or in a wrapper that bisect calls.

**Setting the wrong boundary direction.** `git bisect good` must point to a commit where the regression is absent. `git bisect bad` must point to a commit where it is present. Swapping them causes bisect to search the wrong half of the history and produce a misleading result.

**Leaving bisect active.** After bisect finishes, the working tree is checked out at the offending commit. Run `git bisect reset` to return to the original branch state before continuing normal work.

## References

- git-bisect(1) — the official manual page distributed with Git
