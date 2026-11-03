---
last_verified: 2026-11-03
tool_version: "curl 8.9.1, openssl n/a"
sources: []
---
# Probe HTTP and TLS endpoints

This lesson continues from the IP, ports, and DNS lesson. You'll learn to inspect an HTTP conversation and a TLS certificate, then extend the health-check script to probe the sample app's /health endpoint.

## What you'll learn

- Inspect an HTTP request and response with curl -v
- Read a certificate's subject, issuer and expiry with openssl
- Extend the health-check script to probe the sample app's /health endpoint

## Before you start

- [Diagnose "I can't reach it" — IPs, ports and DNS](02-ip-ports-dns.md) — what a port is, how to test it, and how DNS resolves.
- [Write a safe Bash health-check script](../01-orientation/06-bash-health-check.md) — the script you'll extend.
- Tools available in the lab: curl, openssl. Confirm with `curl --version`, `openssl version`.

## Walkthrough

1. Inspect an HTTP request and response with curl -v.

   ```bash
   curl -v http://127.0.0.1:8080/health
   ```

   You should see the `>` request lines (method, headers) and the `<` response lines (status, headers) plus the body. The `*` lines are connection/TLS metadata.

2. Inspect a TLS certificate with openssl.

   ```bash
   echo | openssl s_client -connect example.com:443 -servername example.com 2>/dev/null | openssl x509 -noout -subject -issuer -dates
   ```

   You should see subject, issuer, and notBefore/notAfter dates (expiry).

3. Extend the health-check script to probe /health.

   ```bash
   curl -sS -o /dev/null -w "%{http_code} %{time_total}s\n" --max-time 5 http://127.0.0.1:8080/health
   ```

   You should see a status code and timing. For the reference script, see [TCP/TLS health probes](../../docs/concepts/networking-fundamentals/scripts/2026-08-08-tcp-tls-health-probes.sh).

## Exercise

1. Run `curl -v` against a local HTTP endpoint and identify the request method and response status.
2. Use openssl to read the subject, issuer, and expiry of a certificate from a TLS endpoint you control.
3. Add a /health probe to the health-check script and confirm it reports HTTP 200.

## Check your work

- `curl -v` output contains `>` and `<` prefixed lines.
- openssl prints subject, issuer, and notAfter.
- The health-check reports HTTP 200 for /health.

## Common mistakes

- Forgetting `-v` and seeing only the body.
- Not setting `-servername` for SNI on shared hosts.
- Treating a non-200 as a network failure instead of an app failure.

## Next

[Version control concepts](../../docs/concepts/version-control-concepts/0000-primer-version-control-concepts.md)