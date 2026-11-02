---
last_verified: 2026-11-02
tool_version: "iproute2 6.8.0, dnsutils/dig 9.18.28, curl 8.9.1"
sources:
  - https://www.redhat.com/en/blog/network-namespaces
  - https://www.cloudflare.com/learning/dns/what-is-dns/
  - https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml
---

# Diagnose "I can't reach it" — IPs, ports and DNS

This lesson continues from the networking primer and shell navigation. You'll learn to tell which layer is broken when connectivity fails: addressing/subnets, open ports/listeners, or DNS resolution.

## What you'll learn

- Read CIDR notation and tell whether two addresses share a subnet
- Find which process listens on a port with ss
- Resolve a name with dig and fix a broken DNS entry in the lab

## Before you start

- [Networking fundamentals](../../docs/concepts/networking-fundamentals/0000-primer-networking-fundamentals.md) — definitions of IP, port, subnet, DNS, TCP/UDP.
- [Find your way around the lab shell](../01-orientation/02-shell-navigation.md) — running commands, reading exit codes, editing files.
- Tools available in the lab: ip, ss, dig, curl, ping. Confirm with ip --version, ss --version, dig -v.

## Walkthrough

1. Understand addressing and CIDR.

   ```bash
   ip addr show
   ip route show
   ```

   You should see interfaces with IP/prefix length (e.g. 192.168.1.10/24) and the default route. The /24 means the first 24 bits are the network; addresses sharing that prefix are on the same subnet.

2. Find listening processes and open ports.

   ```bash
   ss -tlnp
   ss -ulnp
   ```

   You should see TCP and UDP listeners with process names. To test a port:
   ```bash
   curl -v telnet://127.0.0.1:8080 2>&1 | tail -5
   ```

3. Debug DNS with dig.

   ```bash
   dig example.com +short
   dig example.com +trace
   cat /etc/resolv.conf
   ```

   You should see short answers, trace output, and nameservers. /etc/hosts takes precedence over DNS.

## Exercise

In /tmp/net-lab:

1. Compare 10.0.1.5/24 and 10.0.2.5/24 — do they share a subnet? Explain.
2. Start a background HTTP server on 8001, find it with ss -tlnp | grep 8001, then kill it.
3. Identify the nameserver from /etc/resolv.conf and resolve example.com with dig +short.
4. Add 127.0.0.1 badhost.lab to /etc/hosts, verify with getent hosts badhost.lab, then remove it.

## Check your work

- 10.0.1.0/24 and 10.0.2.0/24 are different; they do not share a subnet.
- ss shows the listener while running, nothing after kill.
- You can read nameserver from /etc/resolv.conf and see IPs from dig.
- /etc/hosts entry is visible via getent hosts while present.

## Common mistakes

- Confusing IP with port.
- Forgetting /etc/hosts precedence.
- Using ping alone to conclude a TCP service is down.
- Misreading CIDR (/24 is 255.255.255.0).

## Next

[Probe HTTP and TLS endpoints](../../00_index/learning-path.md)
