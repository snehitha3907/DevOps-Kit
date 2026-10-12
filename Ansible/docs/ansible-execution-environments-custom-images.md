---
last_verified: 2026-10-12
tool_version: 14.5.0 (ansible-core 2.21.5)
sources:
  - https://forum.ansible.com/t/release-announcement-ansible-community-package-14-5-0/46426
  - https://forum.ansible.com/t/release-announcement-ansible-community-package-14-4-0/46283
  - https://docs.ansible.com/projects/ansible/latest/roadmap/COLLECTIONS_14.html
---

# Ansible execution environments: building and deploying custom EE images

## Purpose

This guide describes how to build a custom Ansible execution environment (EE) image, publish it, and roll it out as the runtime for automation jobs. An execution environment is a container image that bundles ansible-core, a fixed set of collections, Python dependencies, and any system packages playbooks need, so every job runs against the same runtime regardless of which control node or platform launches it.

## When to use

Use a custom EE image when playbooks depend on collections or Python libraries that are not in the default runtime, when different teams need isolated dependency sets, or when automation runs on a platform (Automation Controller, AWX, or plain container-based CI) where installing packages at job time is slow or forbidden.

This guide is not an Ansible tutorial. It assumes working playbooks and an inventory, and focuses on packaging the runtime, not on writing automation content.

## Prerequisites

- A container engine for local builds and a registry account for publishing.
- Python 3 with `pip` on the build host.
- The target Ansible line decided up front: this guide pins the community package `ansible==14.5.0`, which depends on ansible-core `2.21.5`. The prior line was `ansible==14.4.0` on ansible-core `2.21.4`, so a 14.4.0 to 14.5.0 move is a core patch bump plus collection updates.
- A list of the collections the playbooks require, and the exact Python and system packages those collections need at runtime.

## Steps

### 1. Pin the Ansible line in a requirements file

Pin the community package exactly, so rebuilds of the image do not float to a newer release. Collection updates ride the roughly four-week minor-release train, so the pin is what keeps the image reproducible between trains:

```text
ansible==14.5.0
ansible-builder
ansible-navigator
ansible-runner
```

Install the build tooling on the build host:

```bash
python3 -m pip install ansible==14.5.0 --user
```

Collections that can stay on the current core without moving the package are consumed through the release tag's `galaxy-requirements.yaml`:

```bash
ansible-galaxy collection install -r galaxy-requirements.yaml
```

Record which collections the image must carry versus which are installed at deploy time. Everything the playbooks import at runtime belongs in the image; lint-only or scaffolding collections stay out.

### 2. Write the EE definition file

The definition file declares the base image, the Ansible and Python dependencies, system packages, and any extra build steps. Keep it minimal: one base image, the pinned requirements from step 1, and only the system packages the collections genuinely need:

```yaml
version: 3
images:
  base_image:
    name: quay.io/centos/centos:stream9
dependencies:
  galaxy: requirements.yml
  python: requirements.txt
  system: bindep.txt
additional_build_steps:
  prepend_base:
    - RUN echo "base customisation goes here"
  append_final:
    - RUN echo "final customisation goes here"
```

`requirements.yml` lists the collections, `requirements.txt` carries the `ansible==14.5.0` pin plus collection Python dependencies, and `bindep.txt` lists system packages. Keep nesting flat and avoid wrapping a single package install in its own layer of indirection; each entry should trace to one collection's documented requirement.

### 3. Build the image

Build from the directory holding the definition file and tag the result with the Ansible line it carries, so the tag answers "which runtime is this" at a glance:

```bash
ansible-builder build -t ee-custom:14.5.0 -f execution-environment.yml --context ./context
```

Re-run the build after any dependency change and treat a green build as necessary but not sufficient: it proves the image assembles, not that playbooks pass on it.

### 4. Test playbooks against the new image before publishing

Run a representative playbook in check mode with the freshly built image selected as the execution image, then run the normal path:

```bash
ansible-navigator run site.yml --eei ee-custom:14.5.0 --mode stdout --check --diff
ansible-navigator run site.yml --eei ee-custom:14.5.0 --mode stdout
```

Compare task results and changed-task counts with the baseline run on the previous image. Investigate any collection-load or interpreter error here, while the image is still local and cheap to rebuild.

### 5. Publish and point automation at the new image

Push the tested image to the registry and update the job template, controller EE assignment, or CI variable to the new tag. Roll the change out one job template or environment at a time rather than repointing everything at once, keeping the previous tag available for the rollback path below.

### 6. Schedule refreshes around the release cadence

Minor releases ship approximately every four weeks following the ansible-core schedule, with Ansible 15 (on ansible-core 2.22) in development. Before moving the pin, review the unified changelog for the package line and the core changelog for the matching core tag, then repeat steps 1 through 5 as a new image tag rather than overwriting the current one.

## Verify

- Confirm the running image reports the pinned pair: community package `14.5.0` with ansible-core `2.21.5`.
- Confirm every collection the playbooks import resolves inside the image without a job-time install step.
- Run the full playbook suite against the new image and compare results with the baseline from the previous image.
- Confirm the published tag in the registry matches the tag the job templates reference.
- Confirm a fresh pull on a clean host reproduces the same run, proving no local layer was load-bearing.

## Rollback

If jobs regress on the new image, repoint the affected job templates to the previous image tag and rerun the baseline playbook path. Keep the previous tag in the registry until the new image has served clean runs for at least one full schedule cycle, then investigate the failing collection or dependency in a local rebuild before tagging again.

## Common errors

- **Collection missing at runtime.** The collection was installed on the build host but never declared in `requirements.yml`, so it is absent from the image. Declare it and rebuild; do not patch over it with a job-time install.
- **Python dependency drift.** An unpinned transitive dependency resolved differently on rebuild. Pin it in `requirements.txt` and rebuild.
- **System package missing.** A collection needs a native library that pip cannot provide. Add it to `bindep.txt` rather than shelling out to a package manager inside a playbook.
- **Tag moved under running jobs.** Overwriting a tag that jobs reference makes failures unrepeatable. Publish each Ansible line as a new immutable tag and move references explicitly.
- **Skipped changelog review before a core move.** A minor-line bump changed collection behaviour. Read the package-line and core changelogs before moving the pin, especially heading toward a new major core line.

## References

- Ansible community package 14.5.0 release announcement
- Ansible community package 14.4.0 release announcement
- Ansible 14 collections roadmap and release cadence
