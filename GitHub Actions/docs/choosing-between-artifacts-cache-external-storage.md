---
last_verified: 2026-10-27
tool_version: n/a
---

# Choosing between artifacts, cache, and external storage for build outputs in GitHub Actions

## Purpose

Decide where build outputs should live in a GitHub Actions workflow: workflow artifacts, the cache, or an external store (S3, GCS, a registry, etc.).

## When to use

- You are designing CI for a repo and need to pass files between jobs or preserve outputs across runs.
- Build artifacts are getting large and workflow minutes / storage costs matter.
- You need to decide whether a file should be ephemeral, cached, or published.

## Prerequisites

- A working GitHub Actions workflow.
- Familiarity with `actions/upload-artifact` and `actions/cache`.

## Comparison

| Option | Lifetime | Scope | Best for | Avoid when |
|---|---|---|---|---|
| Workflow artifact | Run-scoped (retention window) | Within a single run, across jobs | Passing build outputs between jobs; test reports; release binaries for download | Reusing across runs; large binaries you re-download every run |
| Cache | Cross-run, keyed | Repo + branch scope | Dependencies, build caches, toolchains | Outputs that change every run and bust the key; anything you must keep as a deliverable |
| External storage | You control | Whatever you configure | Large artifacts, long retention, sharing outside GitHub | Simple job-to-job handoff where artifacts suffice |

## Decision guide

1. Need the file only to move from job A to job B in the same run? Use an artifact.
2. Need to speed up a later run by reusing unchanged inputs? Use the cache.
3. Need to keep something for weeks, share it, or it is larger than artifact limits? Use external storage.
4. Need both reuse and a downloadable deliverable? Cache the intermediate, publish the final via external storage or a release.

## Steps

1. Identify the consumer of the output: another job in the same run, a future run, or an external system.
2. Pick the smallest option that satisfies the consumer.
3. Set retention deliberately: short for artifacts, keyed for cache, lifecycle policy for external storage.
4. Name keys and artifact names so they are unique per OS / lockfile / branch.

## Verify

- Re-run the workflow on a cache hit and confirm the cached step is skipped.
- Download the artifact from the run summary and confirm it opens.
- For external storage, list the object and confirm the URL resolves.

## Common errors

- Using artifacts as a cache: re-uploads every run, wastes minutes.
- Cache key too broad: stale hits serve wrong dependencies.
- Storing secrets in artifacts: treat artifacts as readable by anyone with repo access.

## References

- GitHub Actions documentation on artifacts and caching.
