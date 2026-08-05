---
last_verified: 2026-08-05
tool_version: n/a
sources: []
---

# Go Microservice — Project Scaffold

> A reusable scaffold for bootstrapping a Go HTTP microservice with multi-stage Docker builds, Makefile automation, and container-optimized ignores.

## Purpose

This scaffold provides a ready-to-use project structure for a Go microservice that containerizes with Docker. It includes a multi-stage Dockerfile that produces a minimal runtime image, a Makefile with common development targets, and a `.dockerignore` that keeps build context lean. Use it as a starting point for any new Go HTTP service.

## When to use

Use this scaffold when initializing a new Go microservice project that will be containerized and deployed. It is suitable for internal tools, APIs, and lightweight web services.

## Prerequisites

- Go 1.22 or later installed and available on `PATH`
- Docker installed and running
- A registry for pushing images (optional, for deployment)

## Steps

1. Copy the scaffold into a new project directory:

   ```bash
   cp -r go-microservice/ my-service/
   cd my-service
   ```

2. Initialize the Go module and resolve dependencies:

   ```bash
   go mod init github.com/yourorg/my-service
   go mod tidy
   ```

3. Build the binary locally to verify the Go code compiles:

   ```bash
   make build
   ```

4. Run the service locally:

   ```bash
   make run
   ```

5. Build the Docker image:

   ```bash
   make docker-build
   ```

6. Run the container:

   ```bash
   make docker-run
   ```

## Verify

- Run `make test` to confirm the test suite passes (if tests are added).
- Run `curl http://localhost:8080/health` after `make docker-run` to confirm the health endpoint responds with `ok`.
- Run `curl http://localhost:8080/` to confirm the root endpoint returns the expected response.
- Check that the Docker image uses a non-root user by inspecting the `USER` directive in the Dockerfile.

## Common errors

- **Build fails with `go: no Go files in /build`**: Ensure `main.go` exists in the project root and `COPY . .` in the Dockerfile copies it into the build context.
- **Container exits immediately**: The `ENTRYPOINT` may be failing. Check logs with `docker logs <container>` and verify the binary is present at `/server` in the image.
- **Health check fails**: The `/health` endpoint may not be reachable. Confirm the container exposes port 8080 and the `HEALTHCHECK` URL matches the server configuration.
- **Permission denied on `make run`**: The `USER 1001:1001` directive in the Dockerfile runs the process as a non-root user. Ensure the binary has execute permissions for that user.

## References

- Docker multi-stage builds documentation
- Go module documentation
- GNU Make manual