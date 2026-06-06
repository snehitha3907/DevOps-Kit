# Exploring kubectl — pods, deployments, and services

I installed kind and kubectl, spun up a cluster, and started poking around.

First I checked the cluster info:

    kubectl cluster-info

It showed the control plane and CoreDNS.

I listed nodes:

    kubectl get nodes

One node — the kind container.

I created a deployment:

    kubectl create deployment nginx --image=nginx

Then got pods:

    kubectl get pods

One pod, status Running after a few seconds.

I checked details:

    kubectl describe pod <pod-name>

It had events at the bottom — the image pull and container start.

I scaled the deployment:

    kubectl scale deployment nginx --replicas=3
    kubectl get pods

Three pods now.

I exposed it as a service:

    kubectl expose deployment nginx --port=80 --type=NodePort
    kubectl get services

I cleaned up:

    kubectl delete service nginx
    kubectl delete deployment nginx

Good enough for a first look.
