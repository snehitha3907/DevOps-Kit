---
last_verified: 2026-07-12
tool_version: n/a
---

# Networking Fundamentals — quick primer

> First-day notes on networking fundamentals. What it is, why it matters, and the key ideas to know.

## What is it?

Networking is how computers talk to each other. Whether it's a browser loading a website, a container talking to a database, or a CI/CD runner pulling code from GitHub — all of it depends on networking working correctly.

I think of it as the plumbing that carries data between systems. The data is broken into packets, addressed like mail, and routed through a series of hops until it reaches its destination.

## Why does it matter for DevOps?

DevOps practitioners build and maintain distributed systems. Containers communicate across virtual networks. Services depend on other services running elsewhere. Load balancers distribute traffic. Firewalls control access. Monitoring scrapes metrics over HTTP.

If I don't understand basic networking, I'll struggle with:
- Debugging why a container can't reach the database
- Configuring security groups and firewall rules
- Understanding how Kubernetes services and ingress work
- Troubleshooting DNS resolution failures
- Setting up load balancers and reverse proxies

## Key terminology

- **IP address** — A unique identifier for a device on a network. IPv4 looks like `192.168.1.10`, IPv6 like `2001:db8::1`.
- **Port** — A numbered channel on a machine. Port 80 for HTTP, 443 for HTTPS, 22 for SSH. A connection is IP + port.
- **DNS** — Domain Name System. Translates human names like `google.com` into IP addresses. `nslookup` or `dig` to query it.
- **TCP** — Transmission Control Protocol. Reliable, ordered delivery — used by HTTP, SSH, databases. It's the "make sure everything arrives in order" protocol.
- **UDP** — User Datagram Protocol. Faster but no delivery guarantee — used by DNS queries, video streaming, monitoring agents.
- **Subnet** — A logical subdivision of an IP network. Used to isolate traffic (e.g., a private subnet for databases, a public one for web servers).
- **Firewall** — A rule set that controls what traffic is allowed in and out. `iptables` or `ufw` on Linux, security groups in AWS.
- **NAT** — Network Address Translation. Lets multiple devices share one public IP. Your home router does this; so do cloud NAT gateways.
- **Load balancer** — Distributes incoming traffic across multiple backend servers. Health checks ensure it only sends traffic to healthy instances.
- **HTTP/HTTPS** — The protocol web applications speak. HTTP is plaintext, HTTPS is encrypted with TLS. Status codes like 200 (OK), 404 (Not Found), 500 (Server Error) are the responses.

## A concrete example

Here's a quick connectivity check I'd run to debug why a service can't reach a database:

```bash
# Can I reach the database host at all?
ping -c 3 db.internal.example.com

# Is the database port open?
nc -zv db.internal.example.com 5432

# What does DNS resolve to?
dig +short db.internal.example.com

# Trace the route to see where it fails
traceroute db.internal.example.com
```

Each command checks a different layer: DNS resolution, basic reachability, port-level access, and the path packets take through the network.

## How this connects to what's next

Networking fundamentals unlock Docker networking (bridge, overlay, host modes), Kubernetes networking (services, ingress, network policies), cloud VPC design, and monitoring (Prometheus scrapes targets over HTTP). Every distributed system concept builds on this foundation.
