---
last_verified: 2026-08-12
tool_version: n/a
---

# Following the Kubernetes tutorial — what tripped me up

I went through the official Kubernetes tutorial to get a feel for deploying and exposing applications. Here's what I did and where I got stuck.

## Steps

1. **Started minikube** — Ran the local cluster setup and confirmed it was healthy with the status command.
2. **Created a deployment** — Used the imperative command to deploy a sample container image. Watched the pod transition from pending to running.
3. **Exposed the deployment** — Created a service so I could reach the pod from outside the cluster. Tested the endpoint and got a response.
4. **Scaled the deployment** — Increased the replica count and watched new pods join.
5. **Updated the image** — Changed the container image tag and observed the rolling update behavior.

## Got stuck on

- **kubectl command structure** — I kept typing flags in the wrong order. The command structure is `kubectl <verb> <resource>`, but I kept reaching for `kubectl <resource> <verb>` out of muscle memory from other CLIs.
- **Pod status interpretation** — When a pod was stuck, I didn't know that `ContainerCreating` means the container runtime is pulling the image or setting up the filesystem, while `ImagePullBackOff` means the image name is wrong or inaccessible. The error messages weren't obvious to a beginner.
- **Service type confusion** — I used a service type that exposed ports externally when I only needed internal cluster access. The tutorial's explanation of service types was dense, and I had to re-read it twice to understand when to use each one.
- **Context and namespace** — I forgot that minikube runs in its own context. After switching to a different cluster context later, I couldn't find my pods and spent ten minutes wondering if they had been deleted. They were just in a different context.
- **YAML indentation** — When I switched from imperative commands to YAML manifests, a single extra space in the indentation caused the entire manifest to fail validation. The error message pointed at a line number but didn't say "your indentation is wrong."

## What I'd try next

I want to rewrite the imperative commands as YAML manifests and apply them. I'd also like to try a ConfigMap to externalize configuration so the container image stays generic.
