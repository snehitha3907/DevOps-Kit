---
last_verified: 2026-08-07
tool_version: n/a
sources: []
---

# Network troubleshooting patterns for containers and services

> L2 notes — what tripped me up when connecting containers and services together.

## What I ran into

I spent yesterday trying to figure out why a containerized app could reach the internet but not the database container sitting on the same Docker network. The usual `curl` and `ping` commands gave confusing results, and I realized I was missing a mental model for how traffic actually flows between containers, pods, and external services.

## Steps I took

1. **Checked the Docker network.** I listed networks with `docker network ls`, inspected the one my app container was attached to with `docker network inspect <name>`, and confirmed both containers were on the same bridge. The inspect output shows each container's IP address and aliases, which made it obvious the database had a stable alias (`db`) and the app could reach it via that name instead of a hard-coded IP.

2. **Verified DNS resolution inside the container.** I ran `docker exec <app-container> nslookup db` and got an answer right away. That confirmed Docker's embedded DNS was working, so the problem wasn't name resolution. I then tried `docker exec <app-container> curl -v http://db:5432` and saw the connection refused — the database wasn't listening on `0.0.0.0`, only on `127.0.0.1` inside its own container.

3. **Fixed the database bind address.** I changed the database config from `bind = 127.0.0.1` to `bind = 0.0.0.0`, restarted the container, and the app connected. I also checked the firewall on the host with `sudo iptables -L -n` to make sure Docker's rules weren't being blocked by something else — they were fine, but I learned that Docker adds its own chains (`DOCKER`, `DOCKER-USER`) and that host firewalls can silently drop forwarded traffic.

4. **Tested from outside Docker.** Once the containers talked, I tried reaching the app from the host with `curl http://localhost:<published-port>`. It worked, but then I tried from another machine on the LAN and got nothing. I remembered that Docker's bridge NAT only exposes ports on `0.0.0.0` by default; if the app was bound to `127.0.0.1` inside its container, the published port wouldn't be reachable externally. I confirmed with `docker ps` and the port mapping, then fixed the app's listen address.

5. **Checked Kubernetes DNS and service networking.** Later I tried the same setup on a kind cluster. Pods use a different DNS suffix (`.svc.cluster.local`) and services get their own ClusterIP. I used `kubectl run debug --image=busybox:1.36 --rm -it -- nslookup <service-name>` to verify DNS, then `curl` from inside the debug pod to test the service endpoint. The difference from Docker is that Kubernetes has a CNI plugin (like kindnet or Calico) handling pod-to-pod routing, and NetworkPolicies can silently drop traffic between namespaces.

## Got stuck on

- **"Connection refused" vs "Connection timed out"**. At first I treated them as the same problem. They aren't. Refused means the destination is reachable but nothing is listening. Timed out means the packet never got there — usually a firewall, routing, or NetworkPolicy issue. Learning to read the error message cut my debugging time in half.

- **Host firewall rules after Docker is running**. I added a `ufw` rule to deny incoming traffic and accidentally broke Docker's port forwarding. Docker inserts rules into its own chains, but if the host's default policy is `DROP` and the `DOCKER-USER` chain doesn't explicitly allow forwarded traffic, published ports stop working. The fix is `sudo iptables -I DOCKER-USER -j ACCEPT` or configuring `ufw` to allow Docker's forwarded traffic.

- **Kubernetes NetworkPolicies are default-allow**. Most clusters don't have a NetworkPolicy at first, so all pods can talk to all other pods. Once you apply even one policy, the default behavior flips to default-deny within the selected pods. I added a policy to restrict ingress to one namespace and suddenly other services couldn't reach it. I had to add explicit `from` rules for each caller.

## What I'd try next

I want to script these checks so I can run them in one pass: list networks, inspect DNS, test connectivity with `nc` and `curl`, dump `iptables` rules, and for Kubernetes also dump NetworkPolicies and CNI config. That would turn the manual steps above into a reusable health-check routine I can run before declaring a service "deployed."
