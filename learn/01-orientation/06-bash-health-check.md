---
last_verified: 2026-11-02
tool_version: "bash 5.2, ShellCheck 0.11.0, curl 8.14.1"
sources:
  - https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
  - https://github.com/koalaman/shellcheck/releases/tag/v0.11.0
  - https://curl.se/docs/manpage.html
---

# Write a safe Bash health-check script

The previous lesson taught you to write YAML that validates. Now you will write your first real Bash script: a health check that asks "is this service up?" and answers with an exit code the caller can trust. This continues the scripting basics by adding strict error handling, quoting, functions, and a real network check.

## What you'll learn

- Use `set -euo pipefail`, quoting, and functions in a script.
- Check whether a service is healthy and exit non-zero when it is not.
- Make the script pass ShellCheck.

## Before you start

- [Manage processes and services with systemd](03-processes-and-services.md) — how to list processes, signal them, and manage systemd services; confirms you can reason about "is this thing running?" from the command line.
- [Scripting and automation — the basics](../../docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md) — shebang, variables, functions, exit codes, and pipelines.
- Bash 5.2 or newer. Confirm with `bash --version`.
- `curl` installed. Confirm with `curl --version | head -1`.
- ShellCheck installed to lint your script. Confirm with `shellcheck --version | head -1`.

## Walkthrough

1. Create the script with a strict-mode header.

   ```bash
   #!/bin/bash
   set -euo pipefail
   IFS=$'\n\t'
   ```

   You should see: `set -e` exits the script when a command fails, `set -u` errors on unset variables, `set -o pipefail` makes a pipeline fail if any part of it fails, and `IFS` restricts word splitting to newline and tab so loops over filenames stay safe. `set -o pipefail` needs Bash — a `#!/bin/sh` script cannot use it.

2. Add a function that checks a URL with `curl`.

   ```bash
   is_healthy() {
     local url="${1:?missing url}"
     curl --fail --silent --show-error --max-time 5 "$url" > /dev/null
   }
   ```

   You should see: `local url="${1:?missing url}"` requires an argument and fails fast if none is given. `curl --fail` makes curl return a non-zero exit status on HTTP 4xx/5xx (and on connection failure) instead of its default behavior of returning 0 even on an error page. `--silent --show-error` keeps output quiet but still reports failures, and `--max-time 5` prevents the script from hanging forever on a dead host.

3. Add a second function that prints a verdict and returns the right exit code.

   ```bash
   check_service() {
     local url="${1:?missing url}"
     if is_healthy "$url"; then
       printf 'healthy: %s\n' "$url"
       return 0
     else
       printf 'not healthy: %s\n' "$url" >&2
       return 1
     fi
   }
   ```

   You should see: `if is_healthy "$url"` runs the check inside a condition, so `set -e` does not abort the script when the service is down — the `else` branch handles the failure deliberately. Double-quoting `"$url"` prevents word splitting and globbing (ShellCheck rule SC2086). The function returns 0 for healthy, 1 for down, so callers can act on the exit code.

4. Add a `main` function and call it.

   ```bash
   main() {
     local url="${1:?Usage: service-health-check.sh <url>}"
     check_service "$url"
   }

   main "$@"
   ```

   You should see: `"$@"` forwards all arguments to `main`, which requires exactly one URL. Run `chmod +x service-health-check.sh` and then `./service-health-check.sh http://example.com/`.

   A complete, shellcheck-clean version of this script lives at `../../docs/concepts/scripting-automation-bash-python/scripts/service-health-check.sh` — link to it rather than copying it here.

## Exercise

In your lab shell:

1. Create `service-health-check.sh` with the strict-mode header, the `is_healthy`, `check_service`, and `main` functions from the Walkthrough, and the final `main "$@"` call.
2. Make it executable with `chmod +x service-health-check.sh`.
3. Run it against a reachable URL (for example `http://example.com/`) and confirm it prints `healthy:` and exits 0.
4. Run it against an unreachable target (for example `http://127.0.0.1:19999/`) and confirm it prints `not healthy:` to stderr and exits non-zero.
5. Run `shellcheck service-health-check.sh` and fix anything it reports until the output is clean.

Do not paste the solution here; the point is the practice.

## Check your work

```bash
bash --version | head -1
shellcheck service-health-check.sh; echo "shellcheck exit=$?"
./service-health-check.sh http://example.com/ > /dev/null; echo "healthy exit=$?"
./service-health-check.sh http://127.0.0.1:19999/ > /dev/null 2>&1; echo "unhealthy exit=$?"
```

You should see:

- Bash 5.2 (or newer) from `bash --version`.
- `shellcheck exit=0` — no warnings.
- `healthy exit=0` — a reachable service returns success.
- `unhealthy exit=1` — an unreachable service returns non-zero.

## Common mistakes

- Forgetting `"$url"` quotes — an unquoted `$url` splits on spaces and globs, triggering ShellCheck SC2086 and breaking on URLs with special characters.
- Relying on plain `curl` without `--fail` — curl returns 0 even on HTTP 404/500, so a broken service would look healthy. Always use `curl --fail` for health checks.
- Letting `set -e` kill the script inside the health check — put `curl` inside `if ...; then ...; else ...; fi` so a down service is handled by your code, not by `set -e`.
- Omitting `--max-time` — without it, curl can block indefinitely on a host that accepts the connection but never answers.

## Next

[Networking fundamentals](../../docs/concepts/networking-fundamentals/0000-primer-networking-fundamentals.md)