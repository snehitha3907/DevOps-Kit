---
last_verified: 2026-11-13
tool_version: "14.6.0"
sources:
  - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html
  - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/service_module.html
  - https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html
---

# Configure a host with an Ansible playbook

In the Ansible primer you saw what playbooks, modules, and tasks are, and in the processes-and-services lesson you learned how systemd starts and enables a service. Now you combine them: write an Ansible playbook that installs a package and starts its service on a managed host, then run it twice to watch idempotency in action — Ansible only changes things when they need changing.

## What you'll learn

- Write a playbook that installs a package with `ansible.builtin.apt` and starts and enables its service with `ansible.builtin.service`
- Run a playbook twice and confirm the second run reports no changes

## Before you start

- [Ansible — quick primer](../../Ansible/notes/0000-primer-ansible.md) — playbooks, modules, tasks, and idempotency; the `apt` and `service` modules build on this vocabulary.
- [Manage processes and services with systemd](../01-orientation/03-processes-and-services.md) — how `state: started` and `enabled: true` map to `systemctl start` and `systemctl enable`.
- [Read and write YAML that validates](../01-orientation/05-yaml-basics.md) — the playbook is YAML; validate it before you run it.
- Ansible installed on the control node (`ansible --version`) and a Debian/Ubuntu host you can reach. Confirm Ansible is present with `ansible --version`.

## Walkthrough

1. Create an inventory file that names your managed host.

   Save `Ansible/configs/lab-inventory.ini`:

   ```ini
   [webservers]
   localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python3
   ```

   You should see: an inventory with one host, `localhost`, in the `webservers` group, told to connect locally instead of over SSH.

   The companion playbook targets the `webservers` group from this inventory.

2. Write the playbook that installs and starts nginx.

   Save `Ansible/configs/configure-webserver.yml`:

   ```yaml
   ---
   - name: Install and start nginx
     hosts: webservers
     become: yes
     tasks:
       - name: Ensure nginx is installed
         ansible.builtin.apt:
           name: nginx
           state: present
           update_cache: yes

       - name: Ensure nginx is started and enabled
         ansible.builtin.service:
           name: nginx
           state: started
           enabled: true
   ```

   You should see: two tasks — one that makes sure the `nginx` package is present (refreshing the apt cache first), and one that starts the `nginx` service and enables it to start on boot.

   `state: present` on apt is idempotent: if nginx is already installed, Ansible does nothing. `state: started` on the service module is also idempotent — a running service is left alone.

3. Check the playbook's syntax before running it.

   ```bash
   ansible-playbook -i Ansible/configs/lab-inventory.ini Ansible/configs/configure-webserver.yml --syntax-check
   ```

   You should see: no errors, and the playbook printed back — meaning the YAML and module usage are valid.

4. Run the playbook the first time.

   ```bash
   ansible-playbook -i Ansible/configs/lab-inventory.ini Ansible/configs/configure-webserver.yml --become
   ```

   You should see: both tasks report a result, and the play recap shows what changed on the first run. The `--become` flag escalates privileges (sudo by default) so apt can install packages and the service manager can start services.

5. Run the playbook a second time.

   ```bash
   ansible-playbook -i Ansible/configs/lab-inventory.ini Ansible/configs/configure-webserver.yml --become
   ```

   You should see: both tasks report `ok` (no changes) and the play recap shows `changed=0` — the second run changed nothing, which is idempotency.

   If nginx was already installed and running, even the first run may report `changed=0`; that is fine — the point is that running twice produces the same result.

## Exercise

On your own lab host:

1. Write a playbook `configure-db.yml` that installs and starts a different service (for example `postgresql` or `mysql`) using `ansible.builtin.apt` and `ansible.builtin.service`, targeting your own inventory.
2. Add a syntax-check step and run the playbook twice with `--become`.
3. Confirm the second run reports `changed=0`.

Do not paste the solution here; the point is the practice.

## Check your work

```bash
ansible-inventory -i Ansible/configs/lab-inventory.ini --graph
ansible-playbook -i Ansible/configs/lab-inventory.ini Ansible/configs/configure-webserver.yml --become
```

You should see: the inventory graph lists `webservers` with `localhost`, and the second `ansible-playbook` run's recap line ends with `changed=0 failed=0` (both tasks report `ok`).

## Common mistakes

- Forgetting `--become` — installing packages and starting services needs root, so the run fails with permission errors; always pass `--become` (or set `become: yes` in the play, as shown).
- "no hosts matched" — the inventory path or host group is wrong; validate with `ansible-inventory -i <inventory> --graph` before running the playbook.
- `apt` failures — the `ansible.builtin.apt` module needs `python3-apt` on the target host; install it first if the module reports it is missing.
- Expecting changes on the second run — idempotency means `changed=0` is the correct, expected result, not an error.

## Next

[Kubernetes — quick primer](../../Kubernetes/notes/0000-primer-kubernetes.md)
