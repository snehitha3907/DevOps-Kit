---
last_verified: 2026-07-22
tool_version: n/a
---

# Kubernetes ingress with path-based routing for multiple services

## Purpose

Exposing multiple web services behind a single external IP is a common need. Creating separate LoadBalancer services per application wastes IP addresses and complicates DNS management. An Ingress resource with path-based routing solves this by dispatching traffic to different backend services based on the URL path under one hostname.

## Prerequisites

- A Kubernetes cluster (kind works for local testing)
- An Ingress controller installed — kind does not ship one by default; the NGINX Ingress Controller is a common choice
- Two Deployments and Services running (this example uses `app-one` and `app-two`)

## Steps

### 1. Install the NGINX Ingress Controller

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```

Wait for the controller pod to reach Ready:

```bash
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
```

### 2. Create two sample services

Each service follows the same pattern — a Deployment paired with a ClusterIP Service. The `hashicorp/http-echo` image is convenient because it returns a configurable text response on a known port.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-one
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app-one
  template:
    metadata:
      labels:
        app: app-one
    spec:
      containers:
      - name: app-one
        image: hashicorp/http-echo
        args:
        - "-text=Hello from app-one"
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: app-one
spec:
  selector:
    app: app-one
  ports:
  - port: 80
    targetPort: 5678
```

Create a second identical set replacing `app-one` with `app-two`.

### 3. Write the Ingress manifest

The Ingress resource defines routing rules under one host, dispatching by path prefix:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: myapp.local
    http:
      paths:
      - path: /one
        pathType: Prefix
        backend:
          service:
            name: app-one
            port:
              number: 80
      - path: /two
        pathType: Prefix
        backend:
          service:
            name: app-two
            port:
              number: 80
```

The `rewrite-target: /` annotation strips the path prefix before forwarding. Without it, the backend receives `/one` or `/two` as the request path, which `http-echo` does not serve — resulting in a 404.

```bash
kubectl apply -f ingress.yaml
```

### 4. Verify routing

Map the hostname to the kind cluster's ingress IP:

```bash
# Determine the ingress IP (127.0.0.1 for kind)
kubectl get ingress my-ingress
echo "127.0.0.1 myapp.local" | sudo tee -a /etc/hosts
```

Then test each path:

```bash
curl http://myapp.local/one
# Expected: "Hello from app-one"

curl http://myapp.local/two
# Expected: "Hello from app-two"
```

### 5. Inspect the ingress

```bash
kubectl describe ingress my-ingress
```

The `Events:` section should show an assigned address and active routing rules.

## Common errors

- **Missing rewrite-target annotation** — the first attempt at `/one` returned 404 because `http-echo` serves only `/`. Adding `nginx.ingress.kubernetes.io/rewrite-target: /` fixed it. This is one approach; an alternative is to configure the backend application to serve on the sub-path.
- **pathType: Exact vs Prefix** — `Exact` matches `/one` but not `/one/`; `Prefix` matches both. Choosing the wrong pathType causes seemingly intermittent failures depending on whether the client adds a trailing slash.
- **Ingress controller not running** — the Ingress resource is a set of rules, not a controller. In kind, no controller is installed by default, so the Ingress stays in a pending state (no address assigned). Deploying the NGINX Ingress Controller resolved it.
