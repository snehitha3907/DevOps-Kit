---
last_verified: 2026-10-29
tool_version: n/a
sources: []
---

# Docker production hardening runbook

## Purpose

A runbook for taking a Docker deployment from "runs on a laptop" to "safe in a shared cluster": secure the image, secure the runtime, secure the orchestration, and make the whole thing repeatable so a future change does not silently undo the hardening.

## When to use

- A container scanner (Trivy, Grype, or a registry scan) has reported findings in your image.
- You are preparing an image for a push to a shared registry and need a hardening checklist.
- You want a repeatable remediation flow instead of one-off fixes.
- A deployment is moving from a single developer machine into a shared cluster and the runtime posture needs to be reviewed.

## Prerequisites

- Docker installed and able to build the target image.
- A scanner available in the build environment.
- Access to rebuild the image's source (Dockerfile and dependencies).
- A runtime or orchestrator where you can change the pod/deployment spec.

## Steps

1. **Scan before you harden.** Build the image, then scan it so the baseline findings are recorded:
   ```bash
   trivy image --format json --output report.json myimage:latest
   ```
2. **Pin every dependency.** Replace floating tags and `:latest` with exact versions in the Dockerfile and in package manifests; pin the base image by digest.
3. **Drop capabilities and privileges.** Use `--cap-drop=ALL`, run as a non-root `USER`, and avoid `privileged: true` in the container runtime config.
4. **Remove build-time secrets.** Do not `ENV` secrets into the image; mount them at build time with BuildKit secrets and delete caches after build.
5. **Trim layers.** Combine RUN commands, clean package caches in the same layer, and use a multi-stage build so the final image ships only runtime artifacts.
6. **Harden the runtime.** Set resource requests and limits, enable probes, restrict the pod with a security context, and apply network policy so the workload cannot reach anything it does not need.
7. **Re-scan and diff.** Rebuild the hardened image and re-run the scanner; diff the new report against the baseline to confirm findings are resolved or intentionally accepted.

## Verify

- `trivy image` on the hardened image reports zero critical/high findings (or accepted findings with a recorded justification).
- The image's `USER` directive is non-root and the container runs without added capabilities.
- `docker history` shows no secret-bearing layers retained in the final image.
- The deployment spec has resource requests/limits, probes, and a non-root security context.
- Accepted findings are recorded in an allow-list file and reviewed regularly.

## Common errors

- **Findings reappear after rebuild** — a base-image update undid the pin; re-pin and rebuild.
- **Scan times out on large images** — scan the final image only, not the build stage.
- **Accepted findings are not tracked** — record accepted CVEs in a separate allow-list file and review it regularly.
- **Hardening breaks the runtime** — a dropped capability a process needs; restore the prior capability set in the runtime spec and rebuild, then re-scan to confirm no new findings were introduced.

## Rollback

- If a hardening change breaks the runtime (for example, a dropped capability a process needs), restore the prior capability set in the runtime spec and rebuild; re-scan to confirm no new findings were introduced by the revert.
- If a pinned dependency downgrade is required, pin to the previous known-good version in the manifest, rebuild, and re-run the scan diff before shipping.

## References

- Container image hardening guidance for Linux kernels and runtime defaults.
- Scanner documentation for severity filtering and output formats.
- BuildKit documentation for cache mounts and secret mounts.