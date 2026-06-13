# What tripped me up running my first Ansible playbook

I hit several snags when trying to run a playbook across multiple hosts. Here's where things went sideways.

## SSH connection refused

My first attempt failed immediately with "SSH connection refused". The default inventory tries SSH to localhost, but I hadn't set up SSH keys. Adding `ansible_connection=local` to the inventory fixed it for localhost-only testing, but that won't work for real hosts.

The error message was cryptic at first: `SSH Error: ssh connection to localhost failed`. I spent 20 minutes troubleshooting before realizing Ansible defaults to SSH and I need explicit connection settings for localhost.

## pipx vs system install

I initially installed Ansible via `pipx install ansible` after seeing online recommendations. It installed fine, but `ansible-playbook` wasn't found on my PATH. Had to add `~/.local/bin` to PATH or run via `pipx run ansible-playbook`. For simplicity, I switched to `sudo apt install ansible` which just worked.

What tripped me up: pipx installs to an isolated environment, so the usual PATH lookup fails. I kept getting "command not found" even though the install succeeded.

## Permission errors with become

Running the playbook without `become: yes` gave "permission denied" errors when trying to install packages. The `apt` module requires root privileges. Adding `become: yes` at the play level fixed most issues, but I also needed to ensure my user is in the sudo group.

The error `FAILED! => {"changed": false, "msg": "Failed to install some of the specified packages"}` was misleading - it wasn't a package issue, it was a privilege issue.

## Multiple hosts need password

When I tried to scale beyond localhost, Ansible prompted for SSH passwords on each host. Setting up SSH key-based authentication with `ssh-copy-id` saved this, but the initial password prompts were confusing. Also, the default `ssh_args` in ansible.cfg can timeout on some systems - needed to adjust in `ansible.cfg`.

Each host prompted for a password separately, and my terminal got cluttered with prompts. Using `--ask-become-pass` once for privilege escalation was cleaner than multiple SSH prompts.

## Inventory quirks

The inventory file format took trial and error. I expected `192.168.1.10` to work directly, but Ansible needs it as `192.168.1.10 ansible_user=ubuntu` to connect properly. Without the user specification, Ansible defaults to my current username which doesn't exist on the target.

## Got stuck on

The `ansible_connection=local` requirement for localhost wasn't obvious. The docs assume SSH setup, but for quick testing on a single machine, local connection is essential. Also, the `pipx` PATH issue delayed my first run by nearly an hour.

## What I'll try next

I'll set up proper SSH keys for my test hosts and try running the playbook against actual remote machines instead of just localhost. Maybe I'll also try the `ansible.builtin.apt` module syntax to see if it behaves differently than the short form.