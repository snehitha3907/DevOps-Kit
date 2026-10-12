---
last_verified: 2026-10-12
tool_version: "controller-runtime 0.18.4, kubebuilder 4.0.0, Go 1.23"
sources:
  - https://kubebuilder.io
  - https://pkg.go.dev/sigs.k8s.io/controller-runtime
---

# Kubebuilder Operator Scaffold

> Kubernetes operator scaffold generated with Kubebuilder v4, implementing a WebApp custom resource with Deployment, Service, and Ingress management.

## Purpose

This template provides a production-ready starting point for building Kubernetes operators using Kubebuilder and controller-runtime. It implements a `WebApp` custom resource that manages a web application deployment with configurable replicas, container image, service exposure, and optional ingress.

## When to Use

- Building a new Kubernetes operator from scratch
- Learning operator patterns with controller-runtime
- Need a reference implementation for CRD, controller, and RBAC manifests
- Starting point for custom resource reconciliation logic

## Prerequisites

- Go 1.23+
- Kubebuilder 4.0.0+ (or `controller-gen` for manifest generation)
- Docker or Podman for building images
- Kubernetes cluster (v1.28+) for deployment
- `kubectl` configured for target cluster

## Project Structure

```
kubebuilder-operator-scaffold/
├── PROJECT                    # Kubebuilder project configuration
├── Makefile                   # Build, test, and deployment targets
├── go.mod                     # Go module definition
├── go.sum                     # Go module checksums
├── Dockerfile                 # Multi-stage build for operator image
├── api/
│   └── v1alpha1/
│       ├── webapp_types.go    # WebApp CRD types
│       ├── groupversion_info.go
│       └── zz_generated.deepcopy.go
├── controllers/
│   └── webapp_controller.go   # WebApp reconciler
├── cmd/
│   └── main.go                # Manager entry point
├── config/
│   ├── crd/
│   │   └── bases/
│   │       └── apps.example.org_webapps.yaml
│   ├── rbac/
│   │   ├── role.yaml
│   │   └── kustomization.yaml
│   ├── manager/
│   │   ├── manager.yaml
│   │   └── kustomization.yaml
│   ├── prometheus/
│   │   ├── monitor.yaml
│   │   └── kustomization.yaml
│   └── default/
│       └── kustomization.yaml
└── hack/
    └── boilerplate.go.txt     # License header for generated code
```

## Quick Start

### 1. Initialize the Project

```bash
# Replace with your domain and repository
kubebuilder init --domain example.org --repo github.com/your-org/webapp-operator
```

### 2. Create the API and Controller

```bash
kubebuilder create api --group apps --version v1alpha1 --kind WebApp --resource --controller
```

### 3. Customize the Template

Edit the generated files:
- `api/v1alpha1/webapp_types.go` — Define your CRD spec and status
- `controllers/webapp_controller.go` — Implement reconciliation logic
- `config/crd/bases/` — CRD manifest (generated)
- `config/rbac/` — RBAC permissions
- `config/manager/` — Manager deployment

### 4. Generate Manifests

```bash
make manifests
make generate
```

### 5. Build and Push Image

```bash
make docker-build IMG=your-registry/webapp-operator:latest
make docker-push IMG=your-registry/webapp-operator:latest
```

### 6. Install CRDs and Deploy

```bash
make install
make deploy IMG=your-registry/webapp-operator:latest
```

### 7. Create a WebApp Resource

```yaml
apiVersion: apps.example.org/v1alpha1
kind: WebApp
metadata:
  name: my-webapp
  namespace: default
spec:
  replicas: 3
  image: nginx:latest
  port: 80
  serviceType: LoadBalancer
  ingressEnabled: true
  ingressHost: webapp.example.com
  resources:
    requests:
      cpu: "100m"
      memory: "64Mi"
    limits:
      cpu: "500m"
      memory: "128Mi"
  envVars:
    - name: ENVIRONMENT
      value: production
```

Apply with:
```bash
kubectl apply -f webapp-sample.yaml
```

## Verify

Check the operator is running:
```bash
kubectl get pods -n system -l control-plane=controller-manager
```

Check the WebApp status:
```bash
kubectl get webapp my-webapp -o yaml
```

Expected status fields:
- `status.replicas` — Current replica count
- `status.readyReplicas` — Ready replica count
- `status.availableReplicas` — Available replica count
- `status.conditions` — Condition array (DeploymentReady, ServiceReady, IngressReady)
- `status.serviceName` — Created Service name
- `status.ingressName` — Created Ingress name (if enabled)

## Rollback

To uninstall the operator and CRDs:
```bash
make uninstall
make undeploy
```

## Common Errors

| Error | Cause | Resolution |
|-------|-------|------------|
| `controller-gen not found` | Missing controller-gen binary | Run `make controller-gen` to install |
| `CRD not found` | CRDs not installed | Run `make install` before deploying |
| `ImagePullBackOff` | Image not accessible | Ensure image is pushed to registry and credentials configured |
| `Forbidden` on resources | Missing RBAC | Verify ClusterRole/ClusterRoleBinding are applied |
| `Webhook configuration not found` | Webhooks not enabled | This template disables webhooks; enable in PROJECT if needed |

## References

- Kubebuilder Book
- controller-runtime Documentation
- Kubernetes API Conventions
- Operator Pattern