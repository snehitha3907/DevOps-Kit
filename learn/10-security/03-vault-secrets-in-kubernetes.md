---
last_verified: 2026-11-21
tool_version: 2.2.2
sources:
  - https://developer.hashicorp.com/vault/docs/concepts/dev-server
  - https://developer.hashicorp.com/vault/docs/commands/kv
  - https://developer.hashicorp.com/vault/docs/secrets/kv/kv-v2/setup
  - https://developer.hashicorp.com/vault/docs/concepts/policies
  - https://developer.hashicorp.com/vault/docs/concepts/tokens
  - https://developer.hashicorp.com/vault/docs/get-started/developer-qs
  - https://github.com/hashicorp/vault/releases/tag/v2.2.2
---

# Remove static secrets from the cluster

In the previous lesson you delivered the sample app's database password as a Kubernetes Secret. That keeps the password out of your container image, but it still leaves a static copy of the password sitting in the cluster — and if you commit that manifest to Git, the password is in Git too. This lesson moves the password into Vault, where it lives in one versioned place, and delivers it to the app at runtime through a scoped token whose policy permits reading exactly that secret. Git holds only configuration — the Vault address and the secret path — never the password itself.

## What you'll learn

- Write the database password into Vault's KV v2 engine and guard it with a read-only policy.
- Issue a scoped Vault token bound to that policy, so the app can read only its own secret.
- Run the app in the cluster reading the password from Vault at runtime, with Git holding no secret value.

## Before you start

- [Store and read secrets with Vault](02-vault-kv-basics.md) — dev mode, KV v2 read/write, policies, and scoped tokens; this lesson reuses those patterns instead of re-teaching them.
- [Deploy from Git with ArgoCD and roll back](../08-gitops/02-argocd-deploy-and-rollback.md) — how an app runs in the cluster from a manifest kept in Git; this lesson replaces the static Secret in that manifest with a Vault-fetched password.
- Vault installed; confirm with `vault version` (this lesson was written against 2.2.2).
- kubectl configured against a local cluster (kind or minikube) where you can run Deployments and Services.
- The reference policy [`Vault/configs/app-read-only-policy.hcl`](../../Vault/configs/app-read-only-policy.hcl) shows the wildcard read pattern from the previous lesson.

## Walkthrough

### 1. Start Vault and write the database password

In terminal 1, start a dev server. Dev mode is initialized and unsealed, runs in memory, and mounts a v2 KV engine at `secret/`:

```bash
vault server -dev -dev-root-token-id=root
```

You should see `Root Token: root` and `Vault server started!`. Leave this terminal running.

In terminal 2, point the CLI at the server:

```bash
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN=root
vault status
```

You should see `Sealed: false`. Now write the database password into KV v2 at `myapp/database-password`:

```bash
vault kv put -mount=secret myapp/database-password password=changeme-in-production
```

You should see `Success! Data written to: secret/data/myapp/database-password`. The value now lives only in Vault.

### 2. Guard the secret with a read-only policy

A policy for KV v2 uses the data path `secret/data/<path>`. Write a policy that lets the app read only its own database password (tighter than the wildcard pattern in the previous lesson):

```hcl
path "secret/data/myapp/database-password" {
  capabilities = ["read"]
}
```

Save this as `app-db-policy.hcl`, then load it:

```bash
vault policy write app-db-read app-db-policy.hcl
vault policy read app-db-read
```

You should see the policy echoed back. Compare this to the existing [`Vault/configs/app-read-only-policy.hcl`](../../Vault/configs/app-read-only-policy.hcl), which grants read on the broader `secret/data/myapp/*` wildcard — a pattern that fits when an app owns several secret paths.

### 3. Issue a scoped token for the app

Issue a token bound to the read-only policy:

```bash
vault token create -policy=app-db-read
```

You should see a `token` field (something like `hvs....`). Save it — this is the only credential the app needs, and it can read only `myapp/database-password`. A leaked app token exposes nothing else.

### 4. Run Vault in the cluster

Run Vault as a dev-mode Deployment in the cluster and expose it with a Service so the app can reach it:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vault
  labels:
    app: vault
spec:
  replicas: 1
  selector:
    matchLabels:
      app: vault
  template:
    metadata:
      labels:
        app: vault
    spec:
      containers:
      - name: vault
        image: hashicorp/vault:2.2.2
        args: ["server", "-dev", "-dev-root-token-id=root"]
        ports:
        - containerPort: 8200
        env:
        - name: VAULT_ADDR
          value: http://127.0.0.1:8200
---
apiVersion: v1
kind: Service
metadata:
  name: vault
spec:
  selector:
    app: vault
  ports:
  - port: 8200
    targetPort: 8200
```

Save this as `vault-deployment.yaml` and apply it:

```bash
kubectl apply -f vault-deployment.yaml
kubectl wait --for=condition=available deployment/vault --timeout=120s
```

You should see `deployment.apps/vault condition met`. The app will reach Vault at `http://vault:8200` from inside the cluster.

> Dev mode is in-memory and unsealed, with data lost on restart. Use it for learning only; never run dev mode or root tokens in production.

### 5. Write the app that reads the password from Vault

The app reads `VAULT_ADDR`, `VAULT_SECRET_PATH`, and `VAULT_TOKEN` from the environment, calls the Vault KV v2 HTTP API at startup, and uses the returned password. Save this as `app.py`:

```python
import os
import requests
from http.server import BaseHTTPRequestHandler, HTTPServer

VAULT_ADDR = os.environ["VAULT_ADDR"]
SECRET_PATH = os.environ["VAULT_SECRET_PATH"]
TOKEN = os.environ["VAULT_TOKEN"]

resp = requests.get(
    f"{VAULT_ADDR}/v1/secret/data/{SECRET_PATH}",
    headers={"X-Vault-Token": TOKEN},
    timeout=5,
)
resp.raise_for_status()
password = resp.json()["data"]["data"]["password"]

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        # Never echo the password; prove only that the app resolved it.
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"app ready - database password loaded from Vault")

HTTPServer(("0.0.0.0", 8000), Handler).serve_forever()
```

This app never prints or returns the password — it only proves it could load it from Vault.

### 6. Deploy the app with no secret in Git

Create a Kubernetes Secret holding the scoped token (the value comes from Vault, not from Git), then deploy the app referencing it by name:

```bash
kubectl create secret generic app-vault-token \
  --from-literal=token=<the-scoped-token-from-step-3>
```

Replace `<the-scoped-token-from-step-3>` with the token you saved. Now write the app Deployment. Git holds `VAULT_ADDR`, `VAULT_SECRET_PATH`, and a reference to the token Secret by name — no password value:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-app
  labels:
    app: demo-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: demo-app
  template:
    metadata:
      labels:
        app: demo-app
    spec:
      containers:
      - name: demo-app
        image: python:3.11-slim
        command: ["python", "/app/app.py"]
        volumeMounts:
        - name: app-code
          mountPath: /app/app.py
          subPath: app.py
        env:
        - name: VAULT_ADDR
          value: http://vault:8200
        - name: VAULT_SECRET_PATH
          value: myapp/database-password
        - name: VAULT_TOKEN
          valueFrom:
            secretKeyRef:
              name: app-vault-token
              key: token
      volumes:
      - name: app-code
        configMap:
          name: demo-app-code
```

Save this as `demo-app-deployment.yaml`, package `app.py` into a ConfigMap, and apply:

```bash
kubectl create configmap demo-app-code --from-file=app.py
kubectl apply -f demo-app-deployment.yaml
kubectl wait --for=condition=available deployment/demo-app --timeout=120s
```

You should see `deployment.apps/demo-app condition met`. Confirm the app loaded the password from Vault:

```bash
kubectl port-forward deployment/demo-app 8000:8000
curl -s http://localhost:8000/
```

You should see `app ready - database password loaded from Vault`. The app obtained the database password from Vault at runtime; nothing in the committed Deployment manifest reveals the password.

### 7. Confirm nothing secret is stored in Git

Inspect the manifest you will commit:

```bash
grep -n "password\|changeme" demo-app-deployment.yaml || true
```

You should see: no matches — the Deployment manifest contains no password value. The password exists only in Vault, and the app retrieves it through a scoped, read-only token at runtime. If you rotate the password in Vault (`vault kv put -mount=secret myapp/database-password password=new-value`) and restart the pod, the app picks up the new value without any Git change.

## Exercise

Do the flow on your own against a fresh cluster:

1. Start a local Vault dev server, write `myapp/database-password` with a password of your choice, and read it back to confirm KV v2 versioning.
2. Write a read-only policy granting read on `secret/data/myapp/database-password` only, load it, and issue a scoped token bound to it.
3. Confirm the scoped token can read `myapp/database-password` but cannot write to it or read another path (expect `permission denied`).
4. Deploy Vault (dev mode) and a small app in your cluster. The app must fetch the password from Vault at startup via the HTTP API and must never print or return it. The Deployment manifest must contain no password value — only `VAULT_ADDR`, `VAULT_SECRET_PATH`, and a `secretKeyRef` to the token Secret.
5. Confirm the app starts successfully (it resolved the password from Vault), then rotate the password in Vault, restart the pod, and confirm the app uses the new value without any change to Git.

No solution is provided — run each step and verify it yourself.

## Check your work

```bash
VAULT_TOKEN=<scoped-token> vault kv get -mount=secret myapp/database-password
kubectl get deployment demo-app -o jsonpath='{.spec.template.spec.containers[0].env[*]}'
grep -RIn "password\|changeme" demo-app-deployment.yaml vault-deployment.yaml || echo "no secret values in committed manifests"
kubectl port-forward deployment/demo-app 8000:8000 & curl -s http://localhost:8000/
```

You should see: the scoped token reads the password; the Deployment env includes `VAULT_ADDR`, `VAULT_SECRET_PATH`, and a `secretKeyRef` (no plaintext token); the grep finds no password value in the committed manifests; and the app responds that it loaded the database password from Vault.

## Common mistakes

- `permission denied` reading the secret with the scoped token: the policy path must match the KV v2 data path (`secret/data/...`), and the token must be issued after the policy is loaded. Re-issue the token if you change the policy.
- The app cannot reach Vault at `http://vault:8200`: confirm the Vault Service exists and the Deployment is `Available` (`kubectl get svc vault`, `kubectl wait --for=condition=available`).
- Committing the scoped token value into the manifest: always reference the token through `secretKeyRef` to a Kubernetes Secret created separately; the committed manifest names the Secret but never reveals its value.
- Forgetting KV v2's `data/` prefix: read the secret back with `vault kv get -mount=secret myapp/database-password` and check the path is `secret/data/myapp/database-password`, not `secret/myapp/database-password`.

## Next

[Run an incident drill with a runbook](../../00_index/learning-path.md)