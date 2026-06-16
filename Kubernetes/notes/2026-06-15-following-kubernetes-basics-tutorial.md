# Following the Kubernetes Basics tutorial — what tripped me up

I went through the official Kubernetes Basics tutorial on kubernetes.io using Minikube locally. Here's what I did and where I got stuck.

## Steps

1. **Start minikube** — Ran `minikube start`. It pulled a container image for the single-node cluster and came up in under a minute.
2. **kubectl basics** — `kubectl get nodes` worked immediately. I forgot `--help` is a post-subcommand flag, so I kept typing `kubectl help get` instead of `kubectl get --help`.
3. **Create a deployment** — `kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1`. The first time the pod went into `ImagePullBackOff` because I typed the image name wrong.
4. **Describe the pod** — `kubectl describe pod` showed the actual image name the deployment resolved to, which helped me spot the typo.
5. **Expose the deployment** — `kubectl expose deployment/kubernetes-bootcamp --type=NodePort --port=8080`. I first tried `kubectl create service nodeport` with all the flags typed out — that works but requires way more typing than `expose`.
6. **Get the service URL** — `minikube service kubernetes-bootcamp --url`. Without `--url` the URL opens in the browser; with it, curl works from the terminal. I didn't know about the `--url` flag at first.
7. **Scale up** — `kubectl scale deployment/kubernetes-bootcamp --replicas=4`. Watched the ReplicaSet climb from 1 to 4 with `get pods -w`.
8. **Rolling update** — `kubectl set image deployment/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2`. I placed the container name and image in the wrong order the first time.
9. **Rollback** — `kubectl rollout undo deployment/kubernetes-bootcamp`.

## What tripped me up

- **Kubectl help placement** — `kubectl <command> --help`, not `--help <command>`. Kept getting it backwards.
- **Long image names** — `gcr.io/google-samples/...` and `jocatalin/kubernetes-bootcamp` are hard to type precisely. A typo becomes `ImageBackOff` and `describe pod` is the fastest way to spot what actually got pulled.
- **`expose` vs `create service`** — The tutorial's `expose` shortcut saves a bunch of flags. I overcomplicated it by reaching for `create service nodeport` first.
- **`set image` argument order** — `deployment <container-name>=<image>`. I tried `<image>=<container-name>` once and got a "one of 'c', 'image' or 'filename' is required" error.
- **Expose type confusion** — I used `NodePort` where the tutorial uses `ClusterIP` for internal testing and `NodePort` for external access. Reading the section twice would have avoided that.

## What I'd try next

I want to replace all of these imperative commands with `kubectl apply -f` YAML manifests. The tutorial mentions YAML is the recommended approach for anything repeatable, so I want to write a Deployment and Service in one manifest and apply the whole stack at once.
