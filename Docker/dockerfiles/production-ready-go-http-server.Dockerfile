# last_verified: 2026-08-05 · Docker n/a
# Production-ready multi-stage Dockerfile for a Go HTTP server.
# Stage 1 compiles a static binary with layer-cached dependency downloads.
# Stage 2 produces a minimal Alpine runtime with non-root user and health probe.

FROM golang:1.22-alpine AS builder

WORKDIR /build

# Copy module files first — the dependency layer is cached until go.mod changes,
# so most source edits do not invalidate the expensive go mod download step
COPY go.mod go.sum ./
RUN go mod download

# Copy application source and build a statically linked binary
COPY . .
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /out/server .

FROM alpine:3.20 AS runtime

# ca-certificates enables HTTPS outbound calls (e.g. health probes, API clients)
RUN apk add --no-cache ca-certificates && update-ca-certificates

# Create a dedicated non-root group and user instead of relying on numeric UIDs
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy the compiled binary from the builder stage and assign ownership
COPY --from=builder --chown=appuser:appgroup /out/server /usr/local/bin/server

WORKDIR /
USER appuser:appgroup

EXPOSE 8080

# Health probe — the runtime polls the /health endpoint via wget (provided by
# BusyBox in Alpine). Exit code 1 marks the container unhealthy so orchestrators
# can restart it; the start-period gives the server time to initialize
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:8080/health || exit 1

ENTRYPOINT ["server"]
