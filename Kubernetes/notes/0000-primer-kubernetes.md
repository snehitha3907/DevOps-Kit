# Kubernetes — quick primer

> First-day notes for someone who's never used Kubernetes. Personal voice, plain language.

## What is it?

Kubernetes (K8s) orchestrates containers across a cluster. If Docker is a single shipping container, Kubernetes is the shipping yard — it decides where containers run and keeps them alive.

## What does it do?

You describe what you want — "run 3 copies of my web app on port 80, route traffic to healthy ones" — and K8s makes it happen. It self-heals: if a container crashes, it spawns a new one.

## Why does it exist?

Before K8s, multi-server container management meant SSH-ing into boxes and hoping nothing broke. Cloud vendors had proprietary solutions that locked you in. K8s gave everyone the same API for scheduling containers, regardless of the infrastructure.

## Key terminology

- **Pod** — Smallest unit, usually one container. You deploy pods, not containers.
- **Node** — A worker machine. `kubectl get nodes` lists them.
- **Deployment** — Desired replica count. `kubectl create deployment nginx --image=nginx` creates one.
- **Service** — Stable network endpoint routing to pods. `kubectl expose deployment nginx --port=80` exposes it.
- **kubectl** — The CLI. `kubectl get pods` shows running pods.
- **Cluster** — All nodes plus the control plane. `minikube start` creates one.
- **YAML manifest** — Declarative configs. Write `deployment.yaml`, run `kubectl apply -f deployment.yaml`.

## A tiny example

```bash
minikube start
kubectl create deployment hello-k8s --image=nginx
kubectl expose deployment hello-k8s --type=NodePort --port=80
kubectl get pods
minikube service hello-k8s
```

This starts a local cluster, deploys nginx, and opens the service in a browser.

## What I'll cover next

I'll install kind or minikube and spin up my first cluster, then explore kubectl commands for pods and deployments.
