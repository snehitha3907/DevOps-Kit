---
last_verified: 2026-09-16
tool_version: 14.4.0
sources:
  - https://docs.ansible.com/projects/ansible/latest/porting_guides/porting_guide_14.html
---
# Production-ready Ansible project scaffold
#
# Layout:
#   ansible.cfg            — project config (inventory, callbacks, become defaults)
#   inventory/            — production.ini + staging.ini (static inventory)
#   group_vars/           — all.yaml (shared) + production.yaml / staging.yaml (env)
#   playbooks/            — site.yml (orchestrates everything) + per-group playbooks
#   roles/                — webserver, dbserver, loadbalancer (each: tasks, handlers,
#                            defaults, vars, meta, templates)
#   ci/                   — GitHub Actions workflow (ansible-lint + syntax check)
#
# Usage:
#   ansible-playbook -i inventory/production.ini playbooks/site.yml
#   ansible-playbook -i inventory/staging.ini playbooks/site.yml --tags webserver
#   ansible-lint playbooks/

## Project layout

```
production-ansible-project/
├── ansible.cfg
├── README.md
├── ci/
│   └── ansible-ci.yml            # GitHub Actions: lint, syntax, deploy
├── group_vars/
│   ├── all.yaml                  # shared defaults for every host
│   ├── production.yaml           # production overrides
│   └── staging.yaml              # staging overrides
├── inventory/
│   ├── production.ini            # production hosts
│   └── staging.ini               # staging hosts
├── playbooks/
│   ├── site.yml                  # full stack deploy
│   ├── webservers.yml            # web tier only
│   ├── dbservers.yml             # db tier only
│   └── loadbalancers.yml         # LB tier only
└── roles/
    ├── webserver/
    │   ├── defaults/main.yml
    │   ├── handlers/main.yml
    │   ├── meta/main.yml
    │   ├── tasks/main.yml
    │   ├── templates/nginx.conf.j2
    │   └── vars/main.yml
    ├── dbserver/
    │   ├── defaults/main.yml
    │   ├── handlers/main.yml
    │   ├── meta/main.yml
    │   ├── tasks/main.yml
    │   ├── templates/postgresql.conf.j2
    │   └── vars/main.yml
    └── loadbalancer/
        ├── defaults/main.yml
        ├── handlers/main.yml
        ├── meta/main.yml
        ├── tasks/main.yml
        ├── templates/haproxy.cfg.j2
        └── vars/main.yml
```

## Design notes

- **Static inventory** with `ansible_host` aliases so hostnames stay clean while IPs
  live in one place. Group vars split shared (`all.yaml`) from environment-specific
  (`production.yaml`, `staging.yaml`) so the same playbooks deploy to either.
- **One playbook per tier** (`webservers.yml`, `dbservers.yml`, `loadbalancers.yml`)
  plus a top-level `site.yml` that runs all three in order. Order matters: the
  load balancer needs the web servers up first, and the web servers need the
  database reachable.
- **Roles are self-contained** — each role ships defaults, handlers, tasks, a
  template, and metadata. Nothing leaks between roles; variables are namespaced
  under the role name (`webserver_*`, `dbserver_*`, `loadbalancer_*`).
- **Handlers exist for real** — `Restart nginx`, `Reload postgresql`, and
  `Reload haproxy` are notified by the template tasks so config changes trigger a
  reload, not a full restart, when the service is already running.
- **CI runs ansible-lint** plus `--syntax-check` on every pull request so broken
  playbooks never reach the deploy step.

## Quick start

```bash
# 1. Install
pipx install ansible

# 2. Install collections (they live in ansible_collections/ at the project root)
ansible-galaxy collection install -r group_vars/collections.yml

# 3. Dry run against production
ansible-playbook -i inventory/production.ini playbooks/site.yml --check --diff

# 4. Deploy for real
ansible-playbook -i inventory/production.ini playbooks/site.yml
```

## Verify

```bash
ansible-playbook -i inventory/production.ini playbooks/site.yml --syntax-check
ansible-lint playbooks/
ansible -i inventory/production.ini all -a 'echo hi'   # inventory ping
```