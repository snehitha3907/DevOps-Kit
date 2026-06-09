#!/bin/bash
# Following the k8s-002 manifest, manage pod lifecycle: create, inspect, delete

# Apply the stateless app manifest (creates Deployment + Service)
kubectl apply -f stateless-app.yaml

# Wait for pods to be ready - avoids race condition when inspecting
kubectl wait --for=condition=Ready pod -l app=hello --timeout=60s

# Inspect pods with wide output to see node assignment
kubectl get pods -o wide

# Check deployment status and replica count
kubectl get deployment hello-app

# Check service and NodePort assignment
kubectl get service hello-service

# Clean up - delete all resources from the manifest
kubectl delete -f stateless-app.yaml