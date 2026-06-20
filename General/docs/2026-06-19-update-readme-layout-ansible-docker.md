# README Layout update — Ansible/docs, Docker/docs, Docker/notebooks

I updated the DevOps-Kit README Layout section today. The Ansible listing didn't mention its `docs/` subdirectory even though I've got the ansible-lint doc in there. And Docker was missing both `docs/` and `notebooks/` — the networking drivers notebook was invisible from the layout description.

Took a quick look at what's actually on disk:

- `Ansible/docs/` — has `2026-06-15-wiring-ansible-lint.md`
- `Docker/docs/` — has `docker-run-vs-compose.md`
- `Docker/notebooks/` — has `comparing-docker-networking-drivers.ipynb`

I updated three lines in README.md:

1. Ansible Layout line — added "docs" to the list.
2. Docker Layout line — added "docs, and a networking drivers notebook".
3. Coverage table — Docker Notebooks column was `—`, changed to `1` (the notebook was already merged but the table never got updated).

Also bumped the "Last updated" date to today.

Nothing fancy — just keeping the README in sync with what's actually in the directories. The Coverage table count was the thing I almost missed; I should double-check those numbers more often after merges.
