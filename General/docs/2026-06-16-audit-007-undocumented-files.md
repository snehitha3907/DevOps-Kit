# audit-007 — Adding undocumented files to README tree and Coverage table

I checked the audit-007 file list against the current README tree and Coverage table on `origin/main`. Unlike the gen-001/002/003 reworks, these files actually existed on disk but weren't listed in the tree.

## Files I added to the README tree

- `Ansible/docs/2026-06-15-wiring-ansible-lint.md` — added `Ansible/docs/` directory to the tree.
- `Ansible/notebooks/ansible-variable-precedence.ipynb` — added `Ansible/notebooks/` directory to the tree.
- `Docker/dockerfiles/build-and-run-first.Dockerfile` — added to existing `Docker/dockerfiles/` listing.
- `General/docs/2026-06-15-rework-gen003-already-documented.md` — added to existing `General/docs/` listing.
- `GitHub/notes/2026-06-10-repos-issues-and-prs.md` — added to GitHub notes.
- `GitHub/notes/2026-06-13-github-quickstart-cli-and-web.md` — added to GitHub notes.
- `GitHub/notes/2026-06-15-hello-world-guide-and-github-flow.md` — added to GitHub notes.
- `GitHub/notes/2026-06-15-explore-github-web-ui.md` — also added this (existed on disk but was missing from tree).
- `GitHub/scripts/2026-06-10-auth-and-explore-profile.sh` — added to GitHub scripts.
- `Kubernetes/manifests/2026-06-15-configmap-secret-mounted-pod.yaml` — added to K8s manifests.
- `Kubernetes/notes/2026-06-15-following-kubernetes-basics-tutorial.md` — added to K8s notes.

## Coverage table updates

| Row | Before | After |
|-----|--------|-------|
| General docs | 2 | 3 |
| GitHub notes | 5 | 9 |
| GitHub scripts | 4 | 5 |
| Kubernetes notes | 3 | 4 |
| Kubernetes manifests | 1 | 2 |

Also added the 3 missing entries to `00_index/quick-links.md` and updated `CHANGELOG.md`.
