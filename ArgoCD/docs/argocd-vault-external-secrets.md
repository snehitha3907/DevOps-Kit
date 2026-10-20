---
last_verified: 2026-10-20
tool_version: n/a
sources:
  - https://github.com/argoproj/argo-cd/blob/master/docs/user-guide/helm.md
  - https://argo-cd.readthedocs.io/en/stable/user-guide/projects/
  - https://argo-cd.readthedocs.io/en/stable/user-guide/best_practices
  - https://github.com/argoproj/argo-cd/releases/tag/v3.5.0
---

# Argo CD with HashiCorp Vault and External Secrets: keeping secrets out of Git, plus RBAC, notification and webhook patterns that hold up in production

## Purpose

This document describes how to integrate Argo CD with HashiCorp Vault and the External Secrets Operator (ESO) to manage Kubernetes secrets without committing them to Git. It also covers Argo CD Project-level RBAC, notification templates, and webhook configurations that are production-hardened.

The pattern separates concerns: Argo CD manages the *desired state* of applications from Git, Vault stores the *secret material*, and ESO synchronizes secrets from Vault into Kubernetes where workloads consume them. Argo CD never sees secret values — only references.

## When to use this

Use this pattern when:
- You need GitOps for application manifests but must keep credentials, API keys, and certificates out of Git.
- You operate multiple teams or tenants on shared clusters and need Project-scoped RBAC.
- You require audit trails for secret access and automated rotation.
- You need Argo CD to notify external systems (Slack, PagerDuty, custom webhooks) on sync status changes.

Do not use this if:
- Your secret volume is small and static — SealedSecrets or SOPS may be simpler.
- You lack Vault operational expertise (unsealing, replication, backup).
- Your cluster cannot reach Vault (air-gapped environments need a different approach).

## Prerequisites

- Argo CD v2.8+ installed and accessible via CLI/UI.
- HashiCorp Vault v1.15+ cluster reachable from the Kubernetes cluster (network policies permitting).
- External Secrets Operator v0.9+ installed in the cluster.
- `argocd` CLI authenticated; `kubectl` access to target namespaces.
- A Vault AppRole or Kubernetes auth method configured for ESO.

## Steps

### 1. Configure Vault for External Secrets Operator

Create a Vault policy and AppRole for ESO to read secrets from a dedicated path:

```bash
# Policy allowing read/list on the apps/ path
vault policy write eso-reader - <<EOF
path "secret/data/apps/*" {
  capabilities = ["read", "list"]
}
path "secret/metadata/apps/*" {
  capabilities = ["read", "list"]
}
EOF

# AppRole for ESO
vault write auth/approle/role/eso \
  token_policies="eso-reader" \
  token_ttl=1h \
  token_max_ttl=4h \
  bind_secret_id=true
```

Record the `role_id` and generate a `secret_id`:

```bash
vault read auth/approle/role/eso/role-id
vault write -f auth/approle/role/eso/secret-id
```

### 2. Deploy External Secrets Operator with Vault credentials

Create a `SecretStore` that points to Vault using the AppRole credentials:

```yaml
# cluster-secret-store.yaml
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: vault-backend
spec:
  provider:
    vault:
      server: "https://vault.example.com:8200"
      path: "secret"
      version: "v2"
      auth:
        appRole:
          path: "approle"
          roleId: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
          secretRef:
            secretId:
              name: eso-vault-credentials
              key: secret-id
              namespace: external-secrets
```

Create the referenced secret with the `secret_id`:

```bash
kubectl create secret generic eso-vault-credentials \
  --from-literal=secret-id=<secret-id-from-step-1> \
  -n external-secrets
kubectl apply -f cluster-secret-store.yaml
```

### 3. Define ExternalSecret resources that workloads consume

ExternalSecret resources live in application namespaces and reference the ClusterSecretStore:

```yaml
# external-secret-example.yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: app-db-credentials
  namespace: production
spec:
  refreshInterval: 1h
  secretStoreRef:
    kind: ClusterSecretStore
    name: vault-backend
  target:
    name: db-credentials
    creationPolicy: Owner
    template:
      engineVersion: v2
      data:
        username: "{{ .db_username }}"
        password: "{{ .db_password }}"
  data:
    - secretKey: db_username
      remoteRef:
        key: apps/production/database
        property: username
    - secretKey: db_password
      remoteRef:
        key: apps/production/database
        property: password
```

Apply this alongside your Argo CD Application manifests. The resulting `Secret` (`db-credentials`) is a normal Kubernetes Secret that Pods mount via `envFrom` or volume mounts.

### 4. Configure Argo CD Projects for RBAC isolation

Projects scope which repositories, clusters, namespaces, and resource kinds a team can use. Define one per team or environment:

```yaml
# project-production.yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: production
  namespace: argocd
spec:
  description: Production workloads — restricted to prod cluster and namespaces
  sourceRepos:
    - "https://github.com/myorg/gitops-prod.git"
  destinations:
    - namespace: "production-*"
      server: "https://kubernetes.default.svc"
    - namespace: "monitoring"
      server: "https://kubernetes.default.svc"
  clusterResourceWhitelist:
    - group: ""
      kind: "Namespace"
    - group: "apiextensions.k8s.io"
      kind: "CustomResourceDefinition"
  namespaceResourceBlacklist:
    - group: ""
      kind: "Secret"
      # Secrets are managed by ESO — Argo CD should not manage them
  roles:
    - name: deployer
      description: Can sync and rollback applications
      policies:
        - p, proj:production:deployer, applications, *, production/*, allow
      groups:
        - myorg:platform-team
    - name: viewer
      description: Read-only access
      policies:
        - p, proj:production:viewer, applications, get, production/*, allow
      groups:
        - myorg:developers
```

Apply the Project, then reference it in Applications:

```yaml
# application-production.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp
  namespace: argocd
spec:
  project: production
  source:
    repoURL: https://github.com/myorg/gitops-prod.git
    targetRevision: main
    path: apps/myapp/overlays/prod
  destination:
    server: https://kubernetes.default.svc
    namespace: production-myapp
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

### 5. Configure Argo CD notifications for sync events

Argo CD notifications use templates and triggers. Install the notification controller (included in the official Argo CD Helm chart) and configure:

```yaml
# argocd-notifications-cm.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-notifications-cm
  namespace: argocd
data:
  # Slack template
  template.slack-sync-status: |
    message: |
      *Argo CD Sync Notification*
      Application: {{.app.metadata.name}}
      Status: {{.app.status.sync.status}}
      Health: {{.app.status.health.status}}
      Revision: {{.app.status.sync.revision}}
      <{{.context.argocdServerUrl}}/applications/{{.app.metadata.name}}|View in Argo CD>
  # PagerDuty template
  template.pagerduty-sync-failed: |
    summary: "Argo CD sync failed for {{.app.metadata.name}}"
    severity: error
    source: argocd
    custom_details:
      application: "{{.app.metadata.name}}"
      namespace: "{{.app.metadata.namespace}}"
      sync_status: "{{.app.status.sync.status}}"
      health_status: "{{.app.status.health.status}}"
      message: "{{.app.status.health.message}}"

  # Trigger: on sync failure, send to Slack and PagerDuty
  trigger.on-sync-failed: |
    - when: app.status.sync.status == "OutOfSync" && app.status.health.status == "Degraded"
      send:
        - slack-sync-status
        - pagerduty-sync-failed
  # Trigger: on successful sync, send to Slack only
  trigger.on-sync-succeeded: |
    - when: app.status.sync.status == "Synced" && app.status.health.status == "Healthy"
      send:
        - slack-sync-status

  # Service definitions (credentials stored in argocd-notifications-secret)
  service.slack: |
    token: $slack-token
    icon: ":argocd:"
  service.pagerduty: |
    integrationKey: $pagerduty-integration-key
```

Create the secret with tokens:

```bash
kubectl create secret generic argocd-notifications-secret \
  --from-literal=slack-token=xoxb-xxxxx \
  --from-literal=pagerduty-integration-key=xxxxxx \
  -n argocd
kubectl apply -f argocd-notifications-cm.yaml
```

### 6. Configure webhook receivers for external automation

Argo CD can call webhooks on application events. Define a webhook service and trigger:

```yaml
# webhook-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-notifications-cm
  namespace: argocd
data:
  # Add to existing ConfigMap
  service.custom-webhook: |
    url: https://my-ci-system.example.com/argocd-webhook
    headers:
      - name: Authorization
        value: Bearer $webhook-token
    basicAuth: {}

  # Trigger: call webhook on any sync status change
  trigger.webhook-on-sync-change: |
    - when: app.status.sync.status != ""
      send:
        - custom-webhook
      oncePer: 30s  # debounce rapid status flapping
```

Store the webhook token in the notifications secret:

```bash
kubectl patch secret argocd-notifications-secret -n argocd \
  --patch '{"stringData":{"webhook-token":"super-secret-token"}}'
```

### 7. Wire Applications to consume ESO-managed secrets

In your Kustomize overlays or Helm values, reference the Secret that ESO creates — not the Vault path directly:

```yaml
# kustomization.yaml (overlay)
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../../base
  - external-secret.yaml  # the ExternalSecret from Step 3
patches:
  - patch: |-
      - op: add
        path: /spec/template/spec/containers/0/envFrom/-
        value:
          secretRef:
            name: db-credentials  # matches ExternalSecret.target.name
    target:
      kind: Deployment
```

Argo CD applies the Kustomize build, which includes the ExternalSecret. ESO reconciles it, creating the `db-credentials` Secret. The Deployment picks it up on next rollout (triggered by Argo CD's `selfHeal` or a new image tag).

## Verify

1. **ClusterSecretStore is ready**:
   ```bash
   kubectl get clustersecretstore vault-backend -o jsonpath='{.status.conditions}'
   # Should show "Ready=True"
   ```

2. **ExternalSecret synced**:
   ```bash
   kubectl get externalsecret app-db-credentials -n production -o jsonpath='{.status.conditions}'
   # Should show "Ready=True" and "SecretSynced=True"
   ```

3. **Secret exists and has data**:
   ```bash
   kubectl get secret db-credentials -n production -o jsonpath='{.data.username}' | base64 -d
   ```

4. **Argo CD Application is Synced and Healthy**:
   ```bash
   argocd app get myapp -o wide
   # SYNCED + Healthy
   ```

5. **Notifications fire on sync**:
   - Make a manifest change in Git, push.
   - Observe Slack/PagerDuty/webhook receiver within 30 seconds of sync completion.

6. **RBAC works**:
   - As a user in `myorg:developers`, attempt `argocd app sync myapp` — should be denied.
   - As a user in `myorg:platform-team`, same command — should succeed.

## Common errors

| Symptom | Cause | Resolution |
|---------|-------|------------|
| `ClusterSecretStore` status `Ready=False`, `Error: "permission denied"` | Vault AppRole `secret_id` expired or wrong `role_id` | Regenerate `secret_id` in Vault, update `eso-vault-credentials` secret, restart ESO pod if cached |
| `ExternalSecret` status `SecretSynced=False`, `Error: "secret not found"` | Vault path `secret/data/apps/production/database` does not exist | Create the secret in Vault: `vault kv put secret/apps/production/database username=... password=...` |
| Argo CD Application stuck in `Progressing` | Deployment waiting for Secret that ESO hasn't created yet | Increase `refreshInterval` on ExternalSecret, or add `argocd.argoproj.io/sync-wave: "1"` to ExternalSecret so it syncs before the Deployment |
| `prune: true` deletes the ExternalSecret | ExternalSecret not in the Git path Argo CD watches | Ensure ExternalSecret manifests are in the Application's `source.path` or a separate Application with the same Project |
| Notification not sent | `argocd-notifications-controller` not running or secret missing keys | Check controller logs: `kubectl logs -n argocd deploy/argocd-notifications-controller`; verify secret has all referenced keys |
| Webhook returns 401 | Token mismatch or expired | Rotate token in both Vault/secret store and the receiving system; ensure `Authorization: Bearer` header matches |

## References

- Argo CD Projects (multi-tenancy): https://argo-cd.readthedocs.io/en/stable/user-guide/projects/
- Argo CD Best Practices (pin versions, separate config repos): https://argo-cd.readthedocs.io/en/stable/user-guide/best_practices
- Argo CD Helm integration (value precedence, multiple sources, hooks): https://github.com/argoproj/argo-cd/blob/master/docs/user-guide/helm.md
- Argo CD v3.5.0 release notes: https://github.com/argoproj/argo-cd/releases/tag/v3.5.0