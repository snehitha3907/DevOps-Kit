# last_verified: 2026-09-24 · python n/a

"""
Test TCP port reachability and DNS resolution with Python sockets — L2
concept exercise for Networking Fundamentals.

I wrote this because I kept hand-pinging hosts and wanted one small script
that answers two distinct networking questions in one pass: "does the name
resolve?" and "can I actually open a TCP connection to it?" DNS resolution
and TCP connect are separate layers — a name can resolve (DNS OK) while the
port is firewalled (TCP fail), and vice versa, so I report them as two
independent checks instead of one boolean.

Usage:
    python3 tcp_port_and_dns_sockets.py <host> [port]
"""

import socket
import sys


def resolve(host: str) -> list[str]:
    """Return the A/AAAA records the name resolves to (empty list on failure)."""
    try:
        infos = socket.getaddrinfo(host, None)
    except socket.gaierror:
        return []
    seen: list[str] = []
    for _, _, _, _, sockaddr in infos:
        ip = sockaddr[0]
        if ip not in seen:
            seen.append(ip)
    return seen


def tcp_reachable(host: str, port: int, timeout: float = 3.0) -> bool:
    """Try to open a TCP connection; return True if the handshake completes."""
    try:
        with socket.create_connection((host, port), timeout=timeout):
            return True
    except OSError:
        return False


def main() -> int:
    if len(sys.argv) < 2 or len(sys.argv) > 3:
        print(f"Usage: {sys.argv[0]} <host> [port]", file=sys.stderr)
        return 1

    host = sys.argv[1]
    port = int(sys.argv[2]) if len(sys.argv) == 3 else 80

    ips = resolve(host)
    if not ips:
        print(f"DNS: {host} -> resolution FAILED")
        return 1
    print(f"DNS: {host} -> {', '.join(ips)}")

    # Resolve against the first record; the others are reported for context.
    reachable = tcp_reachable(host, port)
    verdict = "open" if reachable else "closed/filtered"
    print(f"TCP: {host}:{port} -> {verdict}")
    return 0 if reachable else 1


if __name__ == "__main__":
    raise SystemExit(main())