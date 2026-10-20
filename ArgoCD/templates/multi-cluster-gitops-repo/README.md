# Multi-Cluster Argo CD GitOps Repository Template

This template provides a production-ready GitOps repository structure for managing multiple Kubernetes clusters with Argo CD using Kustomize overlays and ApplicationSet matrix generators.

## Structure

```
.
├── applications/           # Individual Application manifests
│   └── sample-app.yaml    # Example Application
├── applicationset/        # ApplicationSet generators
│   └── matrix-generator.yaml
├── base/                  # Kustomize base (common resources)
│   ├── kustomization.yaml
│   ├── namespace.yaml
│   └── project.yaml
├── overlays/              # Environment-specific overlays
│   ├── dev/
│   │   ├── kustomization.yaml
│   │   └── values.yaml
│   ├── prod/
│   │   ├── kustomization.yaml
│   │   └── values.yaml
│   └── staging/
│       ├── kustomization.yaml
│       └── values.yaml
└── bootstrap-kind.sh      # Kind cluster bootstrap script
```

## Prerequisites

- `kind` >= 0.22.0
- `kubectl` >= 1.28
- `kustomize` >= 5.0 (or `kubectl kustomize`)
- `argocd` CLI >= 2.10
- Docker or Podman

## Quick Start

### 1. Bootstrap a Kind Cluster with Argo CD

```bash
chmod +x bootstrap-kind.sh
./bootstrap-kind.sh
```

This script:
- Creates a kind cluster named `argocd-multi-cluster`
- Installs Argo CD via the official Helm chart (pinned to chart version 10.10.3)
- Configures the Argo CD server with a LoadBalancer service for local access
- Creates the `argocd` namespace and Project resources
- Outputs the initial admin password

### 2. Apply the Base and Overlay

```bash
# For development environment
kubectl apply -k overlays/dev/

# For staging
kubectl apply -k overlays/staging/

# For production
kubectl apply -k overlays/prod/
```

### 3. Deploy Applications via ApplicationSet

```bash
kubectl apply -f applicationset/matrix-generator.yaml
```

The ApplicationSet matrix generator will create Applications for each cluster/environment combination defined in the generator.

## Customization

### Adding a New Cluster

1. Add the cluster secret to the `argocd` namespace (or use the Argo CD UI/CLI)
2. Update `applicationset/matrix-generator.yaml` to include the new cluster in the `clusters` matrix
3. Add environment-specific values in `overlays/<env>/values.yaml` if needed

### Adding a New Application

1. Create a new Application manifest in `applications/`
2. Reference the appropriate Kustomize overlay path
3. The ApplicationSet generator will automatically pick it up if it matches the label selectors

### Modifying the Project

Edit `base/project.yaml` to adjust:
- Source repositories allowed
- Destination clusters/namespaces permitted
- Resource kinds allowed/denied
- Role-based access control (RBAC) policies

## Key Concepts

### Kustomize Base + Overlays

The `base/` directory contains common resources shared across all environments:
- `namespace.yaml`: The target namespace for applications
- `project.yaml`: Argo CD Project for multi-tenancy isolation
- `kustomization.yaml`: Composes the base resources

Each environment overlay in `overlays/<env>/`:
- References the base via `resources: ["../../base"]`
- Provides environment-specific patches and configurations via `values.yaml`

### ApplicationSet Matrix Generator

The `applicationset/matrix-generator.yaml` uses the matrix generator to create Applications from the Cartesian product of:
- Clusters (defined in the generator)
- Environments (dev, staging, prod)
- Applications (defined by label selectors)

This eliminates repetitive Application manifests and ensures consistency across clusters.

### Sync Waves and Phases

Applications use sync waves for ordered deployment:
- Wave 0: Namespaces, CRDs, Projects
- Wave 1: Operators, controllers
- Wave 2: Application workloads
- Wave 3: Ingress, networking

PreSync/Sync/PostSync hooks are used for complex rollouts (blue/green, canary).

## Security

- All manifests are pinned to specific versions (Helm chart versions, container image tags, Git commit SHAs)
- The Project restricts source repositories and destination clusters
- RBAC roles in `project.yaml` follow least-privilege principles
- Secrets are managed externally (Vault, SealedSecrets, or External Secrets Operator) — not committed to Git

## References

- Argo CD Best Practices: https://argo-cd.readthedocs.io/en/stable/user-guide/best_practices
- Argo CD Projects: https://argo-cd.readthedocs.io/en/stable/user-guide/projects/
- ApplicationSet: https://argo-cd.readthedocs.io/en/stable/user-guide/application-set/
- Kustomize: https://kustomize.io/
- Kind: https://kind.sigs.k8s.io/