# Audit 012 — Docker dockerfile count (2026-09-07)

I checked the Docker coverage table against what is actually on disk.

## Finding

`Docker/dockerfiles/` contains seven files, not six:

- `build-and-run-first.Dockerfile`
- `first-docker-image.Dockerfile`
- `multi-stage-go-http-server.Dockerfile`
- `multi-stage-go-http-server/go.mod`
- `multi-stage-go-http-server/main.go`
- `production-ready-go-http-server.Dockerfile`
- `tried-building-first-image.Dockerfile`

The README Coverage table and `MANIFEST.json` both listed Dockerfiles as 6, which was wrong.

## Fix

- `README.md` Coverage table: Docker Dockerfiles 6 → 7.
- `MANIFEST.json`: Docker dockerfiles 5 → 7 (the manifest counts every file in the directory, including the scaffold's `go.mod` and `main.go`).
- `00_index/topics.md`: Docker dockerfiles listing now names all three recent files instead of two.

## Verification

`find Docker/dockerfiles -type f` returns 7 entries. No other tool directory was affected.