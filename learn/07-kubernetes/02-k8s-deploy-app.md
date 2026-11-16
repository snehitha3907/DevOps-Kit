---
last_verified: 2026-11-16
tool_version: n/a
sources: []
---
# Run the sample app on a local cluster

You packaged the sample app as an image and ran it with Docker Compose in the previous lesson. Now you will run that same kind of workload on Kubernetes: start a local cluster, describe the app as a Deployment, expose it with a Service, and roll out a new image while watching the rollout status.

## What you'll learn

- Start a local cluster with kind or minikube.
- Deploy the app as a Deployment and expose it with a Service.
- Roll out a new image and watch the rollout status with kubectl.

## Before you start

- [Kubernetes — quick primer](../../Kubernetes/notes/0000-primer-kubernetes.md) — what a Pod, Node, Deployment, Service, kubectl, and a cluster are; `kubectl get pods` shows running pods.
- [Run the app and Postgres with Docker Compose](../04-containers/05-compose-app-db.md) — the sample app is already built as an image; here you run that image on Kubernetes instead of in Compose.
- kind and kubectl installed; confirm with `kind version` and `kubectl version --client`. (minikube is an alternative to kind for the cluster step.)

## Walkthrough

1. Start a local cluster.

   Create a cluster with kind:

   ```bash
   kind create cluster --name lesson-cluster
   kubectl cluster-info
   ```

   You should see: kind creating the cluster, then `kubectl cluster-info` printing the Kubernetes control-plane address and a CoreDNS URL. Confirm the node is ready with `kubectl get nodes` — the `NAME` column lists the control-plane node and `STATUS` shows `Ready`.

   Reference: the companion script `../../Kubernetes/scripts/install-kind-and-first-cluster.sh` installs kind and kubectl and creates a first cluster — read it instead of re-typing the install steps.

2. Write the Deployment and Service manifests.

   Save this as `lesson-app.yaml`. It declares two replicas of a small web app and a ClusterIP Service that routes traffic to them:

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
   ---
   apiVersion: v1
   kind: Service
   metadata:
     name: lesson-app-service
   spec:
     selector:
       app: lesson-app
     ports:
     - port: 80
       targetPort: http
       protocol: TCP
       name: http
     type: ClusterIP
   ```

   A Deployment keeps the desired number of pod replicas running and self-heals if a pod crashes. A Service gives the pods a stable network endpoint inside the cluster. This mirrors the reference manifest `../../Kubernetes/configs/2026-08-12-deployment-service-go-app-with-probes.yaml`, which adds readiness and liveness probes on top of the same Deployment + Service shape.

3. Apply the manifests and confirm the app is running.

   ```bash
   kubectl apply -f lesson-app.yaml
   kubectl get pods -l app=lesson-app
   kubectl get service lesson-app-service
   ```

   You should see: two pods listed with `STATUS` of `Running`, and the service with a `CLUSTER-IP`. The Service routes traffic to pods matching `app: lesson-app`.

4. Check the app responds.

   ```bash
   kubectl port-forward service/lesson-app-service 8080:80
   ```

   In another terminal:

   ```bash
   curl -s http://localhost:8080/ | head -c 200
   ```

   You should see: the beginning of the nginx welcome page HTML. Stop port-forward with `Ctrl+C` when done.

5. Roll out a new image.

   Edit `lesson-app.yaml` and change the image line to a different image:

   ```yaml
   image: httpd
   ```

   Then apply and watch the rollout:

   ```bash
   kubectl apply -f lesson-app.yaml
   kubectl rollout status deployment/lesson-app
   ```

   You should see: `deployment "lesson-app" successfully rolled out`. Kubernetes replaces the old pods with new ones running `httpd`, waiting for each new pod to become ready before moving on.

   Reference: `../../Kubernetes/scripts/rollout-status-and-pod-readiness.sh` checks rollout status and pod readiness and exits non-zero until everything is Ready — useful as a CI gate.

## Exercise

Do the whole flow on your own, using a different deployment name:

1. Start (or reuse) a local cluster with `kind create cluster` or `minikube start`.
2. Create `my-app.yaml` with a Deployment (name it `web-app`, 2 replicas, any small web image on port 80) and a Service exposing it.
3. Apply the file, then confirm both pods are `Running` and the Service has a `CLUSTER-IP`.
4. Change the Deployment image to a different image, apply again, and run `kubectl rollout status deployment/web-app` until it reports success.
5. Confirm the rollout history now shows at least two revisions.

No solution is provided — run each step and verify it yourself.

## Check your work

```bash
kubectl get deployment web-app
kubectl get pods -l app=web-app
kubectl get service web-app-service
kubectl rollout status deployment/web-app
kubectl rollout history deployment/web-app
```

You should see: one deployment with 2 desired replicas, two Running pods, one service with a ClusterIP, a "successfully rolled out" status message, and a history table listing REVISION 1 and REVISION 2.

## Common mistakes

- The Service `selector` labels must match the pod template labels exactly; a typo means the Service routes to nothing and the app is unreachable.
- Changing the image in the file does nothing until you `kubectl apply -f` — the rollout starts only after the new manifest is applied.
- Port-forward to the Service port (80), not the container port, unless they differ; here both are 80.

## Next

[Configuration, secrets and ingress](../../00_index/learning-path.md)
