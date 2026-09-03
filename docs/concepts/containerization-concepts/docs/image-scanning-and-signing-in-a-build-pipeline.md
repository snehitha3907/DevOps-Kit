---
last_verified: 2026-09-03
tool_version: n/a
sources:
  - https://nextgenbeing.com/posts/building-a-production-grade-e-commerce-platform-with-laravel-12-stripe-and-kubernetes-part-5-containerization-deployment
  - https://dev.to/ralphlarry/how-i-built-a-production-style-gitops-platform-on-aws-eks-solo-from-scratch-a2g
---

# Image scanning and signing in the container build pipeline

> The seam between "the image builds" and "the image is safe to deploy": how build-time vulnerability scanning and supply-chain signing slot into the same pipeline that already builds, tags, and pushes a container image.

## What I set out to figure out

My pipeline already built a slim, multi-stage image, tagged it with the commit SHA, and pushed it to a private registry. That image then ran in the cluster with a hardened security context (runAsNonRoot, dropped capabilities, read-only root filesystem). What was missing between build and run was a supply-chain guarantee: nothing verified that the image I built was the image that actually got deployed, and nothing caught vulnerable OS packages or language dependencies before they reached the cluster. I needed two gates after the build stage and before the image was trusted — one to confirm the image's contents are clean, and one to prove the image's origin and integrity.

## The two security layers

- **Build-time image scanning** — a scanner checks the freshly built image against a current vulnerability database (OS packages via apk/apt/rpm, plus language libraries like pip/npm/go). A failing result fails the build step, so a vulnerable image never reaches a shared registry.
- **Supply-chain signing** — the builder cryptographically signs the image digest and publishes the signature alongside the artifact. At deploy time the runtime verifies the signature against a trusted key before pulling, so a tampered or untrusted image is rejected before it runs.

Scanning answers "is this image vulnerable?"; signing answers "did we build this image and did it change in transit?". They are complementary — scanning catches content flaws, signing catches integrity forgery. A signed image can still be full of vulnerabilities, so dropping either gate weakens the whole story.

## How the gates fit the build pipeline

The Git-based delivery loop is: push to branch → CI builds the image once, tags it with the SHA, pushes to the registry → a manifest update is committed → the cluster reconciles. Scanning and signing insert cleanly into that flow:

```
build image → scan image → sign image → push (image + signature) → commit manifest → reconcile
```

Scanning runs against the built image **before** push, so a failed scan stops the pipeline before the bad artifact is shared. Signing runs **after** a clean scan, binding the builder's key to the immutable image digest at the known-good SHA. The push carries both the image and its signature to the same registry; the deploy step verifies the signature on pull.

The scanner Trivy is covered in this kit's own primer; a signing tool such as Cosign publishes and verifies signatures tied to the image digest.

## Steps that have worked for me

1. Build the image once with a SHA tag using a multi-stage, minimal final stage — never rebuild per environment.
2. Scan the built image for vulnerabilities above an agreed severity threshold; fail the step on findings.
3. Sign the verified image digest with the build key and push signature and image together.
4. Gate the deploy: only images with a valid signature (and a clean scan record) may be pulled.
5. Keep the runtime defense in place — the hardened security context is defense-in-depth, not a replacement for build-time gates.

## Verify

- The CI job fails when the scan step reports findings, and the vulnerable image never reaches the registry.
- The deploy step rejects an image whose signature does not verify against the trusted builder key.
- A deliberate tamper — retagging or swapping the image without re-signing — is caught at pull time, not at runtime.

## Where I have gotten it wrong

- Scanning only after push — a cached, vulnerable image sat in the registry and was redeployed weeks later. Scan before push.
- Signing the tag, not the digest — tags are mutable, so a signature on `latest` proves nothing; sign the immutable digest.
- Treating signing as a replacement for scanning — a signed image can still carry known vulnerabilities; the two gates cover different risks.

## What I'd try next

I want to wire signature verification into the cluster's admission path (a policy that refuses pods whose images aren't signed by the trusted key), and attach an SBOM to each signed SHA so a security review can audit exactly which packages shipped in a given build.

## References

- Building a production-grade e-commerce platform with Laravel 12, Stripe, and Kubernetes — multi-stage image builds and the security-context baseline.
- Ralph Larry, "How I built a production-style GitOps platform on AWS EKS solo from scratch" — CI builds the image, pushes the SHA, commits the manifest, the cluster reconciles.
