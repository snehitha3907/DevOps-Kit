---
last_verified: 2026-10-21
tool_version: n/a
sources: []
---

# helm-library-scaffold — Helm chart library scaffold

## Purpose

A reusable library chart that provides helper templates for naming, labeling, image references, and common patterns. Library charts can be imported by other charts to share reusable helpers and reduce duplication.

## What is in the box

```
helm-library-scaffold/
├── Chart.yaml                  library chart metadata (type: library)
├── values.yaml                 default values (minimal for library charts)
├── values.schema.json          JSON schema for validation
├── README.md                   this file
└── templates/
    └── _helpers.tpl            reusable helper templates
```

## Usage

Add this library as a dependency in your chart's `Chart.yaml`:

```yaml
dependencies:
  - name: helm-library-scaffold
    version: 0.1.0
    repository: "file://../helm-library-scaffold"
```

Then import and use the helpers in your templates:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "helm-library.fullname" . }}
  labels:
    {{- include "helm-library.labels" . | nindent 4 }}
spec:
  selector:
    matchLabels:
      {{- include "helm-library.selectorLabels" . | nindent 6 }}
```

## Available Helpers

- `helm-library.name` - Chart name
- `helm-library.fullname` - Fully qualified app name
- `helm-library.chart` - Chart name and version
- `helm-library.labels` - Common labels
- `helm-library.selectorLabels` - Selector labels (immutable subset)
- `helm-library.annotations` - Common annotations
- `helm-library.serviceAccountName` - Service account name
- `helm-library.image` - Image reference with registry support
- `helm-library.imagePullSecrets` - Merged image pull secrets
- `helm-library.envFrom` - Environment variables from ConfigMaps/Secrets
