#!/usr/bin/env bash
# last_verified: 2026-09-17 · Helm n/a
set -euo pipefail

chart_name="${1:-demo-web}"
release_name="${2:-demo-web}"
namespace="${3:-default}"
work_dir="${TMPDIR:-/tmp}/helm-${chart_name}-$$"
chart_dir="$work_dir/$chart_name"

cleanup() {
  rm -rf "$work_dir"
}
trap cleanup EXIT

mkdir -p "$chart_dir/templates"

cat > "$chart_dir/Chart.yaml" <<'YAML'
apiVersion: v2
name: demo-web
description: A small Helm chart for a demo web service
type: application
version: 0.1.0
appVersion: "1"
YAML

cat > "$chart_dir/values.yaml" <<'YAML'
replicaCount: 1

image:
  repository: nginx
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80
YAML

cat > "$chart_dir/templates/deployment.yaml" <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-web
  labels:
    app: {{ .Release.Name }}-web
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ .Release.Name }}-web
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}-web
    spec:
      containers:
        - name: web
          image: "{{ .Values.image.repository }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: 80
YAML

cat > "$chart_dir/templates/service.yaml" <<'YAML'
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-web
  labels:
    app: {{ .Release.Name }}-web
spec:
  type: {{ .Values.service.type }}
  ports:
    - name: http
      port: {{ .Values.service.port }}
      targetPort: http
  selector:
    app: {{ .Release.Name }}-web
YAML

helm lint "$chart_dir"
helm template "$release_name" "$chart_dir" --namespace "$namespace" > "$work_dir/rendered.yaml"
helm install "$release_name" "$chart_dir" --namespace "$namespace" --create-namespace
helm status "$release_name" --namespace "$namespace"
helm get manifest "$release_name" --namespace "$namespace" > "$work_dir/installed.yaml"

printf 'Rendered and installed release %s in namespace %s\n' "$release_name" "$namespace"
printf 'Rendered manifest: %s\n' "$work_dir/rendered.yaml"
printf 'Installed manifest: %s\n' "$work_dir/installed.yaml"
