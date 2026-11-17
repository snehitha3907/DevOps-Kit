---
last_verified: 2026-11-17
tool_version: 1.37.2
sources:
  - https://dl.k8s.io/release/stable.txt
---
# Probes, resource limits and autoscaling

In the previous lesson you configured the sample app with a ConfigMap and a Secret and exposed it through an Ingress. The app still ran with default resource settings and no health checks, so Kubernetes could not tell whether a container was alive, how much CPU and memory it was guaranteed, or when to add replicas under load. This lesson teaches you to add liveness and readiness probes on /health, set CPU and memory requests and limits, and scale the app automatically with a HorizontalPodAutoscaler — against Kubernetes 1.37.2.

## What you'll learn

- Add liveness and readiness probes that check the /health endpoint.
- Set CPU and memory requests and limits, and explain what happens when a container reaches them.
- Scale the app with a HorizontalPodAutoscaler based on CPU utilization.

## Before you start

- [Configuration, secrets and ingress](03-k8s-config-and-ingress.md) — a local cluster (kind or minikube) with the sample app Deployment, Service, ConfigMap, Secret, and Ingress running, and `kubectl rollout status` reporting success.
- kind and kubectl installed; confirm with `kind version` and `kubectl version --client`. (minikube is an alternative to kind for the cluster step.)

## Walkthrough

1. Add liveness and readiness probes.

   Update `lesson-app.yaml` from the previous lesson so the container declares both probes:

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: lesson-app
     labels:
       app: lesson-app
   spec:
     replicas: 2
     selector:
       matchLabels:
         app: lesson-app
     template:
       metadata:
         labels:
           app: lesson-app
       spec:
         containers:
         - name: app
           image: nginx
           ports:
           - containerPort: 80
             name: http
           livenessProbe:
             httpGet:
               path: /health
               port: http
             initialDelaySeconds: 15
             periodSeconds: 20
           readinessProbe:
             httpGet:
               path: /health
               port: http
             initialDelaySeconds: 5
             periodSeconds: 10
   ```

   Apply it:

   ```bash
   kubectl apply -f lesson-app.yaml
   kubectl get pods -l app=lesson-app
   ```

   You should see: two pods listed. The liveness probe tells Kubernetes to restart the container when /health keeps failing; the readiness probe tells Kubernetes to keep the pod out of the Service's endpoints while /health is failing. Your application must actually serve an HTTP endpoint at /health that returns 200 — plain nginx returns 404 for an unknown path, so point the probe at a real health endpoint in your own workloads.

   Reference: `../../Kubernetes/manifests/deployment-service-with-probes-limits.yaml` shows the same probe pattern on a different Deployment — read it to compare timing values.

2. Set requests and limits.

   Add a `resources` block to the same container:

   ```yaml
           resources:
             requests:
               cpu: 100m
               memory: 128Mi
             limits:
               cpu: 500m
               memory: 256Mi
   ```

   Apply and inspect:

   ```bash
   kubectl apply -f lesson-app.yaml
   kubectl describe pod <pod-name> | grep -A5 "Limits:"
   ```

   You should see: the container's requests and limits listed under `Limits:` and `Requests:`. A request is what the scheduler guarantees and uses for bin-packing; a limit is the hard ceiling. At the CPU limit, the container is throttled — it slows down but keeps running. At the memory limit, the container is OOMKilled and restarted — there is no throttling for memory.

   Reference: `../../Kubernetes/manifests/go-service-deployment-with-probes-hpa.yaml` pairs probes with requests, limits, and an autoscaler in one manifest.

3. Scale with a HorizontalPodAutoscaler.

   Create an HPA that targets the Deployment and scales on CPU utilization:

   ```yaml
   apiVersion: autoscaling/v2
   kind: HorizontalPodAutoscaler
   metadata:
     name: lesson-app-hpa
   spec:
     scaleTargetRef:
       apiVersion: apps/v1
       kind: Deployment
       name: lesson-app
     minReplicas: 2
     maxReplicas: 10
     metrics:
     - type: Resource
       resource:
         name: cpu
         target:
           type: Utilization
           averageUtilization: 70
   ```

   ```bash
   kubectl apply -f lesson-hpa.yaml
   kubectl get hpa lesson-app-hpa
   ```

   You should see: the HPA listed with MIN of 2, MAX of 10, and the current CPU utilization under CPU. The HPA needs the metrics-server add-on running in the cluster to read CPU usage; without it the CPU column shows `<unknown>` and no scaling happens.

   Reference: `../../Kubernetes/manifests/go-service-deployment-with-probes-hpa.yaml` shows a complete Deployment + HPA in one file.

## Exercise

Do the whole flow on your own against a fresh deployment:

1. Start (or reuse) a local cluster with `kind create cluster` or `minikube start`.
2. Create `my-app.yaml` with a Deployment named `web-app` (2 replicas, small web image on port 80) that includes liveness and readiness probes on /health, plus CPU and memory requests and limits.
3. Create `my-hpa.yaml` with a HorizontalPodAutoscaler named `web-app-hpa` targeting `web-app`, min 2 replicas, max 10, targeting 70% average CPU utilization.
4. Add a ClusterIP Service named `web-app-service` in front of the Deployment.
5. Apply everything and confirm the Deployment, Service, and HPA all exist.

No solution is provided — run each step and verify it yourself.

## Check your work

```bash
kubectl get deployment web-app
kubectl get service web-app-service
kubectl get hpa web-app-hpa
kubectl describe pod -l app=web-app | grep -A8 "Limits:"
```

You should see: one Deployment with 2 desired replicas, one Service with a ClusterIP, one HPA with MIN 2 / MAX 10 / target 70% CPU, and the pod's container listing both CPU and memory requests and limits under `Limits:` and `Requests:`.

## Common mistakes

- A probe path the application does not serve (for example /health on plain nginx, which returns 404) makes the readiness probe fail and keeps the pod out of the Service endpoints.
- Setting only requests and no limits means a container can consume unbounded memory on a node; setting only limits and no requests starves the scheduler of the information it needs to place the pod.
- The HPA shows `<unknown>` CPU until metrics-server is installed and reporting; install metrics-server (it ships with minikube, and kind needs it added separately) before expecting autoscaling.

## Next

[Helm — quick primer](../../Helm/notes/0000-primer-helm.md)
