# last_verified: 2026-08-05 · Docker n/a

FROM golang:1.22-alpine AS builder

WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /server .

FROM alpine:3.20

RUN apk add --no-cache ca-certificates
COPY --from=builder /server /server
EXPOSE 8080
USER 1001:1001
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:8080/health || exit 1
ENTRYPOINT ["/server"]