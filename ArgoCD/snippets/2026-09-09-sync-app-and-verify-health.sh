#!/usr/bin/env bash
# last_verified: 2026-09-09 · ArgoCD CLI
# I wanted to sync an ArgoCD app and check its health from the CLI

APP_NAME="${1:?Usage: $0 <app-name>}"
ARGOCD_SERVER="${ARGOCD_SERVER:-localhost:8080}"

# Login — I had to use --insecure because the default install uses self-signed TLS
argocd login "$ARGOCD_SERVER" --username admin --password "$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)" --insecure

# Sync — I needed --force when the app was stuck after a bad rollout;
# without it the CLI said "already synced" even though the pods were failing
argocd app sync "$APP_NAME" --force

# Wait for it to actually become healthy — without this, the next command
# sometimes returned "Progressing" even though pods were ready
argocd app wait "$APP_NAME" --health --timeout 120

# Show the final state — I use this to grab the revision for rollbacks
argocd app get "$APP_NAME" -o wide
