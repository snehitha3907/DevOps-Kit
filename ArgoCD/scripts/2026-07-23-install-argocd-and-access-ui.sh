#!/usr/bin/env bash
# last_verified: 2026-07-23
# I installed ArgoCD on a kind cluster today
kind get clusters | grep -q argocd-demo || kind create cluster --name argocd-demo
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# Wait for pods then port-forward the UI
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=120s
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
# Get the initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
