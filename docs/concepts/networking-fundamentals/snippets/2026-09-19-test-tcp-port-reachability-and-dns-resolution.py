# last_verified: 2026-09-19 · Networking Fundamentals n/a
import socket
import sys


def check_tcp_port(host, port, timeout=3):
    """Test whether a TCP port is reachable on a host."""
    try:
        with socket.create_connection((host, port), timeout=timeout):
            print(f"  {host}:{port} — OPEN")
            return True
    except (socket.timeout, ConnectionRefusedError, OSError) as exc:
        print(f"  {host}:{port} — BLOCKED ({exc.__class__.__name__})")
        return False


def resolve_dns(hostname):
    """Resolve a hostname to its IPv4 and IPv6 addresses."""
    results = {"IPv4": [], "IPv6": []}
    for family, label in [(socket.AF_INET, "IPv4"), (socket.AF_INET6, "IPv6")]:
        try:
            addrs = socket.getaddrinfo(hostname, None, family)
            results[label] = list(set(addr[4][0] for addr in addrs))
        except socket.gaierror:
            results[label] = []
    print(f"  {hostname}:")
    for version, addrs in results.items():
        for addr in addrs:
            print(f"    {version}: {addr}")
    return results


if __name__ == "__main__":
    target = sys.argv[1] if len(sys.argv) > 1 else "localhost"
    port = int(sys.argv[2]) if len(sys.argv) > 2 else 80
    print(f"DNS resolution for {target}:")
    resolve_dns(target)
    print(f"TCP port check for {target}:{port}:")
    check_tcp_port(target, port)
