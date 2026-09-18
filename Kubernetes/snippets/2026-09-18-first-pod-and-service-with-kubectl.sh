#!/bin/bash
# last_verified: 2026-09-18 · Kubernetes
# I wanted to run my first container with kubectl, so I created a Pod and
# exposed it with a Service from scratch.

# Create a Pod running nginx.
kubectl run nginx-pod --image=nginx --port=80

# Verify the Pod landed and is ready.
kubectl get pod nginx-pod

# Expose the Pod with a ClusterIP Service so traffic can reach it.
kubectl expose pod nginx-pod --name=nginx-svc --port=80 --target-port=80 --protocol=TCP

# Confirm the Service was created and points at the Pod.
kubectl get svc nginx-svc
kubectl describe svc nginx-svc | grep Endpoints