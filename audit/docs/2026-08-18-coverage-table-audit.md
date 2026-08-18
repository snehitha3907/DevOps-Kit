---
last_verified: 2026-08-18
tool_version: n/a
---

# audit-010 — Recounted the README Coverage table against disk

I went through the README Coverage table row by row and compared every figure to actual files on disk, just like the rework note told me to. A previous pass had drifted on a few rows, so I fixed the ones that didn't match.

## What I counted

- **Docker** — Dockerfiles is 6 on disk, not 7. I listed `Docker/dockerfiles/`: five `.Dockerfile` files plus the `multi-stage-go-http-server/` directory. Updated 7 → 6.
- **Terraform** — Configs is 6 `.tf` files: two top-level files (`local-file.tf`, `2026-06-12-tried-local-with-vars.tf`) plus the `reusable-s3-module/` module (`main.tf`, `variables.tf`, `outputs.tf`, `examples/basic/main.tf`). The `README.md` inside the module isn't a `.tf` file, so I didn't count it. Updated 7 → 6.
- **Terraform** — Snippets now has 2 files on disk and Docs has 3. Fill those in instead of `—`.
- **Git** — stayed 5 docs (no `regression-test.sh` exists) and no configs dir, kept `—`.
- **Kubernetes** — configs is 1 (`2026-08-12-deployment-service-go-app-with-probes.yaml`), kept.

## Last verified

Pulled the newest `last_verified` stamp out of each tool's docs/configs/scripts: Git `2026-08-03`, Kubernetes `2026-08-12`, Terraform `2026-08-17`.

## Also checked

`00_index/` (4 files) and the kit-level `docs/` directory have no coverage rows — they're nav/ops folders, so nothing to recount there.

## Result

Row counts and dates now line up with what's actually on disk. No fabricated files or stamps.