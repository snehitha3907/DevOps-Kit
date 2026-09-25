# last_verified: 2026-09-25 · networking-fundamentals L2
"""
Practice script: testing TCP port reachability and DNS resolution with Python sockets.

I wrote this to understand how to check if a host:port is reachable and how DNS
resolution works under the hood. This is useful for health checks, service
discovery, and debugging connectivity issues in DevOps workflows.
"""

import socket
import argparse
import sys
from typing import List, Tuple


def resolve_dns(hostname: str) -> List[str]:
    """
    Resolve a hostname to its IP addresses (both IPv4 and IPv6).
    Returns a list of IP address strings.
    """
    try:
        infos = socket.getaddrinfo(hostname, None)
        ips = []
        for info in infos:
            ip = info[4][0]
            if ip not in ips:
                ips.append(ip)
        return ips
    except socket.gaierror as e:
        print(f"DNS resolution failed for {hostname}: {e}")
        return []


def check_tcp_port(host: str, port: int, timeout: float = 3.0) -> Tuple[bool, str]:
    """
    Test if a TCP port is reachable on the given host.
    Returns (success: bool, message: str).
    """
    try:
        with socket.create_connection((host, port), timeout=timeout) as sock:
            return True, f"Port {port} on {host} is OPEN"
    except socket.timeout:
        return False, f"Port {port} on {host} timed out after {timeout}s"
    except ConnectionRefused:
        return False, f"Port {port} on {host} was REFUSED (connection refused)"
    except OSError as e:
        return False, f"Port {port} on {host} error: {e}"


def check_multiple_ports(host: str, ports: List[int], timeout: float = 3.0) -> List[Tuple[int, bool, str]]:
    """Check multiple ports on the same host."""
    results = []
    for port in ports:
        success, msg = check_tcp_port(host, port, timeout)
        results.append((port, success, msg))
    return results


def main():
    parser = argparse.ArgumentParser(
        description="Test TCP port reachability and DNS resolution",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python %(prog)s google.com --ports 80 443
  python %(prog)s 8.8.8.8 --ports 53 --timeout 5
  python %(prog)s github.com --dns-only
        """
    )
    parser.add_argument("host", help="Hostname or IP address to test")
    parser.add_argument(
        "--ports", "-p", nargs="+", type=int, default=[80, 443],
        help="Port(s) to test (default: 80 443)"
    )
    parser.add_argument(
        "--timeout", "-t", type=float, default=3.0,
        help="Connection timeout in seconds (default: 3.0)"
    )
    parser.add_argument(
        "--dns-only", action="store_true",
        help="Only perform DNS resolution, skip port checks"
    )
    args = parser.parse_args()

    print(f"\n=== Networking Fundamentals Practice: TCP/DNS Test ===")
    print(f"Target: {args.host}")

    # DNS Resolution
    print(f"\n--- DNS Resolution ---")
    ips = resolve_dns(args.host)
    if ips:
        for ip in ips:
            print(f"  Resolved to: {ip}")
    else:
        print(f"  No IP addresses found")

    if args.dns_only:
        return

    # Port Checks
    print(f"\n--- TCP Port Reachability ---")
    results = check_multiple_ports(args.host, args.ports, args.timeout)

    open_count = 0
    for port, success, msg in results:
        status = "✓" if success else "✗"
        print(f"  {status} Port {port}: {msg}")
        if success:
            open_count += 1

    print(f"\nSummary: {open_count}/{len(args.ports)} ports open")

    if open_count == 0:
        sys.exit(1)


if __name__ == "__main__":
    main()