---
last_verified: 2026-11-17
tool_version: n/a
sources: []
---
# Configuration, secrets and ingress

In the previous lesson you ran the sample app on a local cluster as a Deployment, exposed it with a Service, and rolled out a new image. The app ran with defaults though — no custom settings, and no way to reach it from outside the cluster. This lesson teaches you to configure the running app: pass settings through a ConfigMap, inject the database password as a Secret, and expose the app to external traffic with an Ingress.

## What you'll learn

- Pass settings to a running app with a ConfigMap and inject a database password with a Secret.
- Mount ConfigMap and Secret values into pods as environment variables.
- Route external traffic to the app with an Ingress and an ingress controller.

## Before you start

- [Run the sample app on a local cluster](02-k8s-deploy-app.md) — a local cluster (kind or minikube) with the sample app Deployment and Service running, and `kubectl rollout status` reporting success.
- kind and kubectl installed; confirm with `kind version` and `kubectl version --client`.

## Walkthrough

1. Create a ConfigMap and a Secret.

   Save this as `lesson-config.yaml`. It defines two settings (app color and log level) and one secret (the database password):

   ```yaml
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: lesson-app-config
   data:
     APP_COLOR: blue
     LOG_LEVEL: info
   ---
   apiVersion: v1
   kind: Secret
   metadata:
     name: lesson-app-secret
   type: Opaque
   data:
     DB_PASSWORD: cGFzc3dvcmQxMjM=
   ```

   Apply it:

   ```bash
   kubectl apply -f lesson-config.yaml
   kubectl get configmap lesson-app-config
   kubectl get secret lesson-app-secret
   ```

   You should see: `configmap/lesson-app-config created` and `secret/lesson-app-secret created`, then both resources listed. The reference manifest `../../Kubernetes/manifests/2026-06-15-configmap-secret-mounted-pod.yaml` shows the same ConfigMap + Secret pattern mounted into a pod — read it to see the mounting style.

   > The Secret value `cGFzc3dvcmQxMjM=` is base64 for `password123`. In a real workload you would generate this yourself rather than copying an example value.

2. Inject the ConfigMap and Secret into the Deployment.

   Update `lesson-app.yaml` from the previous lesson so the container reads the settings as environment variables:

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
           envFrom:
           - configMapRef:
               name: lesson-app-config
           env:
           - name: DB_PASSWORD
             valueFrom:
               secretKeyRef:
                 name: lesson-app-secret
                 key: DB_PASSWORD
   ```

   Apply and watch the rollout:

   ```bash
   kubectl apply -f lesson-app.yaml
   kubectl rollout status deployment/lesson-app
   kubectl get pods -l app=lesson-app
   ```

   You should see: `deployment "lesson-app" successfully rolled out` and two Running pods. The `envFrom` block pulls every ConfigMap key into the container as an environment variable (`APP_COLOR`, `LOG_LEVEL`), while the `env` block pulls just `DB_PASSWORD` from the Secret.

3. Expose the app with an Ingress.

   kind does not ship an ingress controller, so install one first — the NGINX Ingress Controller install steps are in `../../Kubernetes/docs/ingress-path-based-routing.md`, then wait for the controller pod to be Ready.

   Save this as `lesson-ingress.yaml`:

   ```yaml
   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata:
     name: lesson-app-ingress
   spec:
     ingressClassName: nginx
     rules:
     - host: lesson.local
       http:
         paths:
         - path: /
           pathType: Prefix
           backend:
             service:
               name: lesson-app-service
               port:
                 number: 80
   ```

   Apply it:

   ```bash
   kubectl apply -f lesson-ingress.yaml
   kubectl get ingress lesson-app-ingress
   ```

   You should see: the Ingress listed with an address assigned (for kind this is typically `127.0.0.1`). Add `127.0.0.1 lesson.local` to `/etc/hosts` and `curl http://lesson.local/` reaches the app through the Ingress.

   Reference: `../../Kubernetes/docs/ingress.yaml` shows a minimal Ingress, and `../../Kubernetes/docs/ingress-path-based-routing.md` walks through path-based routing to multiple services.

## Exercise

Do the whole flow on your own against a fresh deployment:

1. Start (or reuse) a local cluster with `kind create cluster` or `minikube start`.
2. Create `my-config.yaml` with a ConfigMap named `my-app-config` (at least two settings) and a Secret named `my-app-secret` holding a `DB_PASSWORD` key.
3. Create `my-app.yaml` with a Deployment named `web-app` (2 replicas, small web image, port 80) that injects both the ConfigMap and the Secret as environment variables, plus a ClusterIP Service named `web-app-service`.
4. Install an ingress controller and create an Ingress named `web-app-ingress` that routes `http://myapp.local/` to `web-app-service`.
5. Apply everything, confirm both pods are Running, and verify the app answers through the Ingress.

No solution is provided — run each step and verify it yourself.

## Check your work

```bash
kubectl get configmap my-app-config
kubectl get secret my-app-secret
kubectl get deployment web-app
kubectl get pods -l app=web-app
kubectl get service web-app-service
kubectl get ingress web-app-ingress
```

You should see: the ConfigMap and Secret listed, one Deployment with 2 desired replicas, two Running pods, one Service with a ClusterIP, and one Ingress with an address assigned.

## Common mistakes

- A Secret's `data` values must be base64-encoded; plain-text values are rejected by the API server.
- The Service name in the Ingress `backend` must match the Service's `metadata.name` exactly, and the Service `selector` must match the pod template labels.
- kind does not ship an ingress controller; without one, an Ingress resource stays in a pending state with no address assigned.

## Next

[Probes, resource limits and autoscaling](04-k8s-probes-limits-hpa.md)
