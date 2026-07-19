---
last_verified: 2026-07-19
tool_version: n/a
---

## Running kubectl version and creating my first Pod from a manifest

I checked what kubectl version I had. Then I wrote my first Pod manifest — a tiny nginx container — and applied it with `kubectl apply -f`.

`kubectl version` showed both client and server versions. I ran it with `--short` first (output: `Client Version: v1.30.0`, `Server Version: v1.30.0`), but the short flag is deprecated, so I switched to plain `kubectl version` which prints the full YAML.

Writing the Pod manifest was straightforward. I created a file with `apiVersion: v1`, `kind: Pod`, metadata name, and a single container spec running `nginx:latest` on port 80. The tricky part was getting the indentation right — I kept putting `containers` at the wrong level (under `spec` is correct).

I ran `kubectl apply -f my-first-pod.yaml` and watched it spin up with `kubectl get pods -w`. The pod went through ContainerCreating to Running. I checked the logs with `kubectl logs my-first-pod` and saw the nginx welcome message.

Cleaned up with `kubectl delete pod my-first-pod`.

What tripped me up:
- Indentation in YAML — `containers` is a list under `spec`, not a sibling. `kubectl apply` gave me a clear error though: "error validating data: unknown field 'containers'".
- I forgot the `--` document separator at first. Turns out `kubectl apply` doesn't need it for single-resource files (it parses the YAML anyway), but I'm adding the habit.
- `kubectl version --short` is deprecated — the full YAML output is actually more useful because it shows the build date and platform.

Next I want to try adding a Service manifest alongside the Pod and see how `kubectl apply -f` handles a multi-resource YAML file.
