---
last_verified: 2026-07-12
tool_version: n/a
---

# Scripting & Automation (Bash/Python) — quick primer

> First-day notes on scripting and automation. What it is, why it matters, and the key ideas to know.

## What is it?

Scripting means writing short programs — scripts — that automate repetitive tasks. Instead of typing 15 commands manually, I write a script that runs them in sequence, checks for errors, and adapts to different inputs.

Bash is the native shell language on Linux. It's best for running commands, managing files, and orchestrating other programs. Python is a general-purpose language that's great for anything more complex: parsing logs, making API calls, manipulating data structures.

Together, they're the two main tools for DevOps automation.

## Why does it matter for DevOps?

DevOps is about automating everything. Provisioning servers, deploying applications, running tests, rotating logs, backing up data, monitoring health — if I do it more than once, I should script it.

Without scripting skills, I'd be:
- Manually SSH-ing into servers to run commands (slow, error-prone)
- Copy-pasting the same shell commands over and over
- Unable to parse and act on tool output programmatically
- Stuck when a CI/CD pipeline needs a custom step

## Key terminology

- **Shebang** — The first line of a script that tells the OS which interpreter to use. `#!/bin/bash` for bash, `#!/usr/bin/env python3` for Python.
- **Variable** — A named value. In bash: `NAME="world"`, used as `$NAME`. In Python: `name = "world"`.
- **Function** — A reusable block of code. Defines once, call many times. In bash with `function_name() { ... }`, in Python with `def function_name():`.
- **Exit code** — A number a program returns when it exits. 0 means success, anything else means an error. In bash, `$?` captures the last exit code. In Python, `sys.exit(1)`.
- **stdout / stderr** — Standard output (normal results) and standard error (error messages). I can redirect them separately: `cmd 2>/dev/null` silences errors.
- **Loop** — Repeats a block of code. `for item in list; do ... done` in bash, `for item in list:` in Python.
- **Conditional** — Runs code only when a condition is true. `if [ -f "$file" ]; then` in bash, `if os.path.exists(file):` in Python.
- **Pipeline** — Chains commands by feeding one's output into the next. `journalctl | grep error | head -5` is a pipeline.
- **Module/Package** — A reusable library. Python has `import os`, `import requests`, `import json`. Bash sources other scripts with `source file.sh`.

## A concrete example

A tiny backup script that shows the pattern:

```bash
#!/bin/bash
# Backup a directory with a timestamp
BACKUP_DIR="/var/backups"
SOURCE="/etc/nginx"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVE="nginx-configs-$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_DIR/$ARCHIVE" "$SOURCE" && echo "Backup saved: $ARCHIVE"
```

In Python, the same idea with more structure:

```python
#!/usr/bin/env python3
import subprocess, sys, datetime

backup_dir = "/var/backups"
source = "/etc/nginx"
timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
archive = f"nginx-configs-{timestamp}.tar.gz"

result = subprocess.run(["tar", "-czf", f"{backup_dir}/{archive}", source])
if result.returncode == 0:
    print(f"Backup saved: {archive}")
else:
    print("Backup failed!", file=sys.stderr)
    sys.exit(1)
```

Both do the same thing — create a timestamped tarball — but Python gives me richer error handling when I need it.

## How this connects to what's next

Scripts are the glue of DevOps. Ansible playbooks are YAML but often call scripts. CI/CD pipelines run scripts at every stage. Infrastructure tools like Terraform support local-exec provisioners that run scripts. Monitoring agents run collection scripts. Scripting is the skill I'll reach for every single day.
