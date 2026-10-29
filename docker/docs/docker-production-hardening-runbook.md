---
last_verified: 2026-10-29
tool_version: n/a
sources: []
---

# Docker production hardening runbook

## Purpose

A repeatable runbook for taking container images and their runtime configuration from "works on a laptop" to a hardened posture suitable for shared or internet-facing environments. It covers image build hardening, runtime constraint, secret handling, scanner-driven remediation, and rollback so that hardening changes can be applied and, if they break the runtime, reversed safely.

## When to use

- A container image scanner has flagged findings in an image you intend to ship.
- You are preparing an image for a shared registry or a multi-tenant cluster.
- A workload is moving from a single developer host into a shared staging or production environment.
- You need a repeatable, reviewable remediation flow instead of one-off edits to Dockerfiles and deployment specs.

## Prerequisites

- Docker, or an equivalent OCI-compatible builder, installed and reachable.
- A container image scanner available in the build environment.
- Source access to the image's Dockerfile and dependency manifests.
- Permission to change pod, deployment, or container runtime specs in the target environment.

## Steps

1. **Establish a baseline.** Build the image and scan it before making changes, recording findings so you can measure improvement:
   ```bash
   docker build -t myapp:baseline .
   trivy image --format json --output baseline.json myapp:baseline
   ```
2. **Validate required binaries before touching anything.** Confirm the builder, scanner, and runtime tools are present, then decide whether to run in dry-run mode:
   ```bash
   for bin in docker trivy; do
     command -v "$bin" >/dev/null 2>&1 || { echo "missing binary: $bin" >&2; exit 1; }
   done
   DRY_RUN=1
   ```
3. **Pin every dependency.** Replace floating tags and `:latest` with exact versions; pin base images by digest in the Dockerfile and lock dependency versions in package manifests.
4. **Reduce the attack surface.** Use a minimal base image, remove build tools and package caches from the final layer, and ship only runtime artifacts through a multi-stage build.
5. **Remove build-time secrets.** Never `ENV` secrets into the image. Pass secrets at build time through BuildKit secret mounts, and at runtime through environment binding or a secrets manager.
6. **Drop privileges and capabilities.** Run as a non-root `USER`, use `--cap-drop=ALL`, add back only the capabilities the process provably needs, and avoid `privileged: true`.
7. **Constrain the runtime.** Set CPU and memory requests and limits, add liveness and readiness probes, apply a non-root security context, and restrict network egress with a network policy.
8. **Re-scan and diff.** Rebuild the hardened image, scan it, and diff the new report against the baseline. Ship only when findings are resolved or recorded in an allow-list with a justification and review date.
9. **Dry-run first.** Apply runtime spec changes with `--dry-run`, or the equivalent validate flag of your orchestrator, before committing them, so syntax and schema problems surface without touching running workloads.

## Verify

- The scanner report for the hardened image shows no unresolved critical or high findings.
- The image runs as a non-root `USER` and carries no added Linux capabilities.
- `docker history` shows no secret-bearing layers in the final image.
- The deployment spec defines resource requests and limits, probes, a non-root security context, and network egress restrictions.
- The dry-run apply exits cleanly with no changes applied to running workloads.
- Accepted findings are recorded in an allow-list file with justification and a review cadence.

## Rollback

- If a hardened image fails at runtime, redeploy the previous known-good image tag and re-scan it to confirm the baseline posture is restored.
- If a dropped capability breaks the process, restore the prior capability set in the runtime spec, rebuild, dry-run, re-scan, then redeploy.
- If a dependency pin causes a build failure, revert the pin to the previous known-good version in the manifest, rebuild, and re-scan before shipping.

## Common errors

- **Findings reappear after rebuild.** A base-image digest moved or a floating tag was reintroduced; re-pin by digest and rebuild.
- **Hardening breaks the runtime.** A dropped capability or a removed package the process depends on; restore the specific capability or package, dry-run, re-scan, and redeploy.
- **Secrets left in image layers.** A secret was `ENV`ed or copied into a layer even if deleted later; rebuild from scratch with secret mounts and verify with `docker history`.
- **Dry-run skipped.** A malformed runtime spec is applied directly to running workloads; always validate with `--dry-run` first.

## References

- Docker BuildKit documentation for secret mounts and multi-stage builds.
- Container scanner documentation for severity filtering, allow-lists, and output formats.
- Container runtime security documentation for security contexts, capabilities, and network policies.
