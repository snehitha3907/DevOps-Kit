# Following the Kubernetes interactive tutorial

I went through the official Kubernetes interactive tutorial on kubernetes.io. The browser-based terminal was convenient — no local cluster needed. Here's what I did and what tripped me up.

## The tutorial setup

The tutorial uses minikube running inside the browser. It covers the full pod lifecycle: create a deployment, inspect it, expose it as a service, scale, update, and rollback.

## Steps I followed

1. **Start minikube** — `minikube start`. Fired up a single-node cluster in seconds. No issues.

2. **Create a deployment** — `kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1`. I mistyped the image name the first time (left out the `:v1` tag) and the pod showed `ImagePullBackOff` in `kubectl get pods`. Fixed it with `kubectl delete deployment kubernetes-bootcamp` and recreated with the right tag.

3. **Check the pod** — `kubectl get pods` showed it running. Then `kubectl describe pod <name>` showed events: pulling the image, creating the container, starting it. That's where I saw the `ErrImagePull` from my typo before I deleted it.

4. **Expose the deployment as a service** — `kubectl expose deployment kubernetes-bootcamp --type=NodePort --port=8080`. I first tried `kubectl create service nodeport` but the tutorial uses `expose` — both work but `expose` is simpler for a quick test.

5. **Get the service URL** — I ran `kubectl get services` and saw the port mapping (e.g. `8080:32000/TCP`), but couldn't reach it from the browser. The tutorial used `minikube service kubernetes-bootcamp --url` to get a real clickable URL. I didn't realize minikube handles port forwarding itself.

6. **Scale the deployment** — `kubectl scale deployment/kubernetes-bootcamp --replicas=4`. Then `kubectl get pods -w` let me watch the new pods start in real time. Pods transitioned from Pending → ContainerCreating → Running.

7. **Rolling update** — `kubectl set image deployment/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2`. The syntax is `deployment/<name> <container-name>=<image>`. I got the order wrong the first time — `kubectl set image` expects the deployment first, then `container=image`.

8. **Rollback** — `kubectl rollout undo deployment/kubernetes-bootcamp`. One command. Then `kubectl rollout status deployment/kubernetes-bootcamp` to watch it finish.

## What tripped me up

- **Image name typos** — Long GCR image paths are easy to mistype. `kubectl describe pod` was my debug lifeline.
- **`expose` vs `service`** — `kubectl expose` is a command shortcut that creates a service. The tutorial uses it everywhere. If I'd tried `kubectl create service` from my own knowledge I'd have needed a YAML file or more flags.
- **`set image` argument order** — `deployment <container>=<image>`, not `<image>=<container>`. The error message was clear enough but I still got it backwards twice.
- **minikube vs kubectl confusion** — Some commands (`start`, `stop`, `service --url`) are minikube-specific. When I saw `minikube service` in the tutorial I thought it was a kubectl flag at first. They're separate binaries with separate responsibilities.

## What I'd try next

I want to move from imperative `kubectl create` to declarative YAML manifests with `kubectl apply -f`. The tutorial mentions it as the recommended approach for anything beyond a sandbox. I also want to try writing a multi-resource manifest (Deployment + Service in one file) and see how `kubectl apply` handles the whole stack.
