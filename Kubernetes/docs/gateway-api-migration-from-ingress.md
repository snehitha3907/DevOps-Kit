---
last_verified: 2026-10-13
tool_version: n/a
---

# Kubernetes Gateway API migration from Ingress

## Purpose

Ingress is a single resource that mixes infrastructure concerns (which controller serves traffic, which addresses and ports listen) with application concerns (which host and path goes to which Service). In practice the vendor-specific behaviour leaks out through controller annotations, so the same Ingress manifest behaves differently on different controllers and application teams cannot change routing without touching infrastructure-owned fields.

The Gateway API splits those concerns into separate resources: the platform team owns the `GatewayClass` and `Gateway` (listeners, addresses, TLS termination points), while application teams own route resources such as `HTTPRoute` (hostnames, path matches, filters, backend refs). This guide migrates one existing Ingress — the path-based routing setup in `ingress-path-based-routing.md` — to an equivalent Gateway plus HTTPRoute pair, so both models can be compared side by side before the Ingress is removed.

## When to use

Migrate when more than one team shares a cluster's edge traffic, when annotation-driven behaviour has already caused a "works on one controller, breaks on another" incident, or when you need routing features Ingress expresses poorly (header-based matching, request rewriting without controller-specific annotations, clean separation of who may edit what via RBAC on distinct resources).

Stay on Ingress when a single team owns simple host-plus-path routing on one controller and the current manifests are already understood and tested. A migration adds a controller and new CRDs; that cost is only worth it if the role separation or the richer match/filter model solves a problem you actually have.

## Prerequisites

- A Kubernetes cluster with cluster-admin access (kind works for local testing).
- The path-based Ingress from `ingress-path-based-routing.md` applied and working (`app-one` and `app-two` Services reachable through `myapp.local/one` and `myapp.local/two`).
- A Gateway API implementation installed in the cluster: the Gateway API CRDs plus a controller that supports them. The controller also advertises which `GatewayClass` name it manages — note that name down before writing the Gateway.

## Steps

### 1. Confirm the Gateway API CRDs and controller are present

```bash
kubectl get gatewayclass
kubectl get crd gateways.gateway.networking.k8s.io httproutes.gateway.networking.k8s.io
```

The first command should list at least one `GatewayClass` managed by the installed controller. If either command reports "not found", the CRDs or the controller are not installed yet — install the implementation's manifests first, then continue. Nothing below has any effect without a controller programming the data plane.

### 2. Create a Gateway that mirrors the Ingress entry point

The Gateway replaces two Ingress fields at once: the ingress class (which controller serves this) and the listener surface (which hostnames and ports accept traffic). Write one Gateway bound to the controller's `GatewayClass`:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: web
  namespace: default
spec:
  gatewayClassName: <the-class-from-step-1>
  listeners:
  - name: http
    protocol: HTTP
    port: 80
    hostname: myapp.local
```

```bash
kubectl apply -f gateway.yaml
kubectl get gateway web
```

The Gateway is the platform-owned object: application teams should not need to edit it to add or change routes. If the Gateway never reports a usable address, the controller is not reconciling it — recheck the `gatewayClassName` against the output of step 1.

### 3. Translate the Ingress rules into an HTTPRoute

Each Ingress rule (host plus path list) becomes one `HTTPRoute` attached to the Gateway by `parentRefs`. The two path rules from the example Ingress translate directly:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: myapp-routes
  namespace: default
spec:
  parentRefs:
  - name: web
  hostnames:
  - myapp.local
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /one
    backendRefs:
    - name: app-one
      port: 80
  - matches:
    - path:
        type: PathPrefix
        value: /two
    backendRefs:
    - name: app-two
      port: 80
```

```bash
kubectl apply -f httproute.yaml
```

Mapping notes for the translation:

- `spec.ingressClassName` on the Ingress disappears; controller selection now lives on the Gateway via `gatewayClassName`, and routes attach with `parentRefs`.
- `rules[].host` becomes `spec.hostnames` on the route.
- `pathType: Prefix` becomes a match with `type: PathPrefix`. Check prefix semantics against the old behaviour before cutting over (see Common errors).
- Controller-specific annotations have no direct equivalent. The common case is path rewriting: where the Ingress used a rewrite annotation to strip the prefix, the route uses a `URLRewrite` filter on the rule instead of an annotation, so the rewriting behaviour is visible in the route itself rather than hidden in controller documentation.

### 4. Move TLS termination if the Ingress had any

If the Ingress terminated TLS with a `spec.tls` secret, add a second listener to the Gateway (protocol HTTPS, the serving port) whose certificate reference points at the same Secret, and keep the Secret in the Gateway's namespace — cross-namespace certificate references additionally require an explicit grant resource permitting the reference, so the simplest migration keeps the certificate next to the Gateway. Verify HTTPS serves the expected certificate before touching DNS or client configuration.

### 5. Cut traffic over and bake in

Point the hostname at the Gateway's address (the same hosts-file or DNS entry the Ingress verification used), then exercise both paths. Keep the old Ingress applied during this period: the two models can coexist while you compare, and the Ingress is the instant fallback. Only delete the Ingress once the route has served production-shaped traffic long enough to cover the paths, headers, and error cases the old setup handled.

```bash
kubectl delete ingress my-ingress
```

## Verify

```bash
kubectl get gateway web
kubectl describe httproute myapp-routes
curl http://myapp.local/one
# Expected: "Hello from app-one"
curl http://myapp.local/two
# Expected: "Hello from app-two"
```

The route's status conditions report whether the Gateway accepted the route and whether it is programmed into the data plane. Both `curl` calls must return the backend responses before the old Ingress is deleted in step 5. Re-run the checks after deleting the Ingress to confirm nothing was still depending on it.

## Rollback

While the old Ingress manifest still exists, rollback is re-applying it and pointing the hostname back at the Ingress address:

```bash
kubectl apply -f ingress.yaml
kubectl get ingress my-ingress
```

Because the migration keeps the backend Services untouched (only the edge routing objects change), rolling back does not touch application workloads. After the bake-in period ends and the Ingress is deleted, the rollback source of truth is the Ingress manifest stored in version control — confirm it is committed before deletion day.

## Common errors

- **Route never becomes programmed** — the usual cause is a missing or mismatched controller: the Gateway API CRDs are installed but no implementation is running, or `gatewayClassName` names a class no controller manages. The Gateway shows no address and the route's status stays unaccepted. Fix the class name or install the controller; the YAML itself is rarely the problem.
- **Listener hostname too narrow or too broad** — a Gateway listener with `hostname: myapp.local` only serves that name; requests for any other host on the same port get no route. Conversely, omitting `hostname` opens the listener to every name. Match the listener set to the hostnames the old Ingress served, no more.
- **Prefix semantics differ from the old controller** — the old Ingress behaviour for trailing slashes and sub-paths depended on the controller's interpretation of its path rules. After migration, test `/one`, `/one/`, and `/one/extra` explicitly; adjust the match type or add a rewrite filter so the backends receive the paths they expect.
- **TLS Secret in the wrong namespace** — the Gateway reads its certificate from its own namespace, while the old Ingress may have referenced a Secret elsewhere. Move or duplicate the Secret next to the Gateway and update the listener reference, then confirm the served certificate before cutover.
- **Deleting the Ingress too early** — removing the old Ingress before the route is verified leaves no fallback. Keep both applied through the bake-in period; the Ingress costs nothing while idle and is the fastest rollback path available.

## References

- Gateway API concepts, roles, and conformance guidance (upstream project documentation)
- Ingress path-based routing companion note in this directory (`ingress-path-based-routing.md`)
- The installed controller's GatewayClass and listener documentation for this cluster
