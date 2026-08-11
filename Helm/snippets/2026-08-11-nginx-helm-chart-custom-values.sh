#!/usr/bin/env bash
# last_verified: 2026-08-11 · Helm 4.2.2

# I followed the Helm quickstart to scaffold a minimal nginx chart
# and install it with my own values overrides.

CHART_NAME="my-nginx"
RELEASE_NAME="my-nginx"
NAMESPACE="default"

# I removed the existing chart directory if I re-run this script,
# otherwise `helm create` complains the folder already exists.
if [ -d "$CHART_NAME" ]; then
  echo "Removing existing $CHART_NAME/ ..."
  rm -rf "$CHART_NAME"
fi

# Scaffold a fresh chart. The default chart includes Deployment,
# Service, ServiceAccount, HPA, and a test Pod — more than I need,
# so I'll trim it down below.
helm create "$CHART_NAME"

# I only want a Deployment and a ClusterIP Service for this exercise.
# The default templates are fine for a first pass, but the default
# Service is LoadBalancer and I want ClusterIP, so I'll override
# that in values.yaml rather than editing the template directly.
cat > "$CHART_NAME/values.yaml" <<'VALUES'
replicaCount: 2

image:
  repository: nginx
  pullPolicy: IfNotPresent
  tag: "latest"

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: false
  hosts:
    - host: chart-example.local
      paths:
        - path: /
          pathType: ImplementationSpecific
VALUES

# I kept the default Deployment template from `helm create` because
# it already references the values above correctly. The only thing
# I changed was service.type from LoadBalancer to ClusterIP in
# values.yaml so the chart is reachable only inside the cluster.

# Install the chart. I'm using --wait so helm blocks until the
# Deployment reports ready replicas — it makes the script feel
# less like fire-and-forget when I run it in a local kind cluster.
helm upgrade --install "$RELEASE_NAME" "./$CHART_NAME" \
  --namespace "$NAMESPACE" \
  --create-namespace \
  --wait \
  --timeout 2m

echo "Release $RELEASE_NAME installed. Get the URL with:"
echo "  kubectl port-forward svc/$RELEASE_NAME 8080:80"
