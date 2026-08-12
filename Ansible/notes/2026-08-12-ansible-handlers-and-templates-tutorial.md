---
last_verified: 2026-08-12
tool_version: n/a
---

# Ansible handlers and templates tutorial — what tripped me up

I followed the official Ansible tutorial on handlers and templates to understand how to conditionally run tasks and generate config files dynamically. Here's the walkthrough and where I got stuck.

## Steps

1. **Set up the project** — Created a simple project with an inventory file pointing at localhost and a playbook that installs nginx.
2. **Added a template** — Wrote a Jinja2 template for the nginx config that inserts the server name from a variable. Used the `template` module to copy it to `/etc/nginx/nginx.conf`.
3. **Added a handler** — Created a handler named `restart nginx` that runs `systemctl restart nginx`. The main task uses `notify: restart nginx` so the service only reloads when the config actually changes.
4. **Ran the playbook** — Executed `ansible-playbook -i inventory playbook.yml` and watched the task report show `changed` for the template and `ok` for the handler on the first run.
5. **Tested idempotency** — Ran the playbook a second time. The template task reported `ok` (no changes), and the handler did not fire. That's the expected behavior.

## Got stuck on

- **Handler name matching** — I named the handler `Restart Nginx` with capital letters, but the notify line said `restart nginx`. Handlers are matched by exact name, so the notification was silently ignored. The service never restarted, and I didn't realize it until I checked the handler summary.
- **Template variable scope** — I defined a variable in `group_vars/all.yml` called `server_name`, but the template rendered it as a literal string `{{ server_name }}` instead of the value. The issue was that my variable file used `---` YAML document start markers incorrectly — I had two `---` lines in one file, so the second variable block was treated as a separate document and never loaded.
- **`notify` only fires on `changed`** — I expected the handler to run every time the playbook executes. It doesn't. Handlers only fire when a task they're notified by reports `changed`. On the second run, the template was `ok`, so the handler stayed quiet. This is correct behavior, but the tutorial didn't emphasize it enough for me to internalize it on the first read.
- **Template vs `copy`** — I kept reaching for `copy` out of habit because it's simpler. The difference is that `template` runs the file through Jinja2, so variables get substituted. I copy-pasted a static file first and wondered why `{{ server_name }}` appeared in the actual config on the server.

## What I'd try next

I want to combine handlers with a more complex template that loops over multiple server blocks. I'd also like to try `listen` on handlers so one handler can respond to notifications from multiple tasks, and I want to test whether a handler that fails stops the playbook or just reports the failure.
