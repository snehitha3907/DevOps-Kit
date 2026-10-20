# last_verified: 2026-10-20 · ArgoCD 3.3.3
"""Helper over the Argo CD REST API: report drift, diff live state, sync, roll back.

Purpose:
  Query an Argo CD API server for the Applications it manages, report the ones
  that are OutOfSync or Degraded, compare the live state of an Application's
  resources with the state rendered from its target revision, and trigger a
  targeted sync or a rollback to an earlier deployment.

  The helper uses the standard library only, so it can run from a CI job or a
  jump host without installing anything. The Argo CD CLI covers the same
  ground interactively; scripting the REST API is useful when the decision
  has to come from another system.

When to use:
  - "Which of my Applications are drifting right now?"       -> `report`
  - "What exactly differs between the cluster and Git?"        -> `diff`
  - "Sync only this Deployment, not the whole Application."   -> `sync --resource ...`
  - "Put the Application back to the deployment I had."       -> `rollback`

Prerequisites:
  - An Argo CD API server reachable over HTTPS, plus either an API token or a
    username and password that can be exchanged for one.
  - Project permissions for the Application being acted on.

Usage:
  python3 argocd-application-helper.py --server argocd.example.com report --project default
  python3 argocd-application-helper.py --server argocd.example.com diff guestbook
  python3 argocd-application-helper.py --server argocd.example.com sync guestbook \
      --resource apps/Deployment/guestbook/guestbook
  python3 argocd-application-helper.py --server argocd.example.com rollback guestbook \
      --to-revision 8f0a1c2

  The server address is read from --server or $ARGOCD_API_SERVER. The API
  token is read from --token or $ARGOCD_AUTH_TOKEN, the same variable the
  argocd CLI uses. Without a token, --username and --password are exchanged
  for one through the session endpoint.

Verify:
  `report` prints one line per Application with its sync and health status.
  `diff` prints the resolved revision of the rendered manifests, the revision
  currently live, and one row per resource that differs. `sync` and `rollback`
  echo the sync status and health of the Application after the call.

Common API errors:
  - 401/403: the token is missing, expired, or lacks access to the project.
  - 404: no Application with that name in the given project or namespace.
  - The response body of any error carries the server-side message; it is
    printed verbatim so the API's own wording is not lost.

Related kit material:
  ../notes/0000-primer-argocd.md
  ../notes/2026-08-11-argocd-quickstart.md
  ../snippets/2026-09-09-sync-app-and-verify-health.sh
  ../scripts/build-argocd-application-from-scratch.sh

API reference: https://cd.apps.argoproj.io/swagger.json
"""

import argparse
import json
import os
import ssl
import sys
import urllib.error
import urllib.parse
import urllib.request

DEFAULT_TIMEOUT = 30.0

# Defaults for the connection options. They are applied after parsing so that
# a value given before the subcommand survives the subcommand's own parsing.
COMMON_DEFAULTS = {
    "server": None,
    "token": None,
    "username": None,
    "password": None,
    "insecure": False,
    "timeout": DEFAULT_TIMEOUT,
    "app_namespace": None,
    "project": None,
}


class ArgoCDError(RuntimeError):
    """Raised when the API server returns an error or cannot be reached."""


class ArgoCDClient:
    """Small REST client for the Argo CD API server.

    Only the standard library is used. One client instance holds the bearer
    token, so the session exchange happens once per run.
    """

    def __init__(self, server, token=None, timeout=DEFAULT_TIMEOUT, verify_tls=True):
        self.server = server.rstrip("/")
        self.token = token
        self.timeout = timeout
        self._ssl_context = None
        if not verify_tls:
            context = ssl.create_default_context()
            context.check_hostname = False
            context.verify_mode = ssl.CERT_NONE
            self._ssl_context = context

    # -- plumbing ---------------------------------------------------------
    def _url(self, path, params=None):
        url = self.server + path
        query = {k: v for k, v in (params or {}).items() if v not in (None, "", [], ())}
        if query:
            url += "?" + urllib.parse.urlencode(query, doseq=True)
        return url

    def _request(self, method, path, params=None, payload=None):
        headers = {"Accept": "application/json"}
        body = None
        if payload is not None:
            body = json.dumps(payload).encode("utf-8")
            headers["Content-Type"] = "application/json"
        if self.token:
            headers["Authorization"] = "Bearer " + self.token
        request = urllib.request.Request(
            self._url(path, params), data=body, headers=headers, method=method
        )
        try:
            with urllib.request.urlopen(
                request, timeout=self.timeout, context=self._ssl_context
            ) as response:
                raw = response.read().decode("utf-8")
        except urllib.error.HTTPError as exc:
            detail = exc.read().decode("utf-8", "replace").strip()
            raise ArgoCDError(
                "%s %s failed: HTTP %s %s" % (method, path, exc.code, detail)
            ) from exc
        except urllib.error.URLError as exc:
            raise ArgoCDError("%s %s failed: %s" % (method, path, exc.reason)) from exc
        except OSError as exc:
            raise ArgoCDError("%s %s failed: %s" % (method, path, exc)) from exc
        if not raw.strip():
            return {}
        try:
            return json.loads(raw)
        except ValueError as exc:
            raise ArgoCDError("%s %s failed: response was not JSON" % (method, path)) from exc

    @staticmethod
    def _app_path(name):
        return "/api/v1/applications/" + urllib.parse.quote(name, safe="")

    # -- session ----------------------------------------------------------
    def login(self, username, password):
        """Exchange a username and password for an API token."""
        payload = self._request(
            "POST", "/api/v1/session", payload={"username": username, "password": password}
        )
        token = payload.get("token")
        if not token:
            raise ArgoCDError("the session endpoint did not return a token")
        self.token = token
        return token

    # -- applications -----------------------------------------------------
    def list_applications(self, projects=None, selector=None, repo=None, app_namespace=None):
        """Return every Application the server knows about."""
        payload = self._request(
            "GET",
            "/api/v1/applications",
            params={
                "projects": projects,
                "selector": selector,
                "repo": repo,
                "appNamespace": app_namespace,
            },
        )
        return payload.get("items") or []

    def get_application(self, name, app_namespace=None, project=None):
        """Return one Application, including its status and deployment history."""
        return self._request(
            "GET",
            self._app_path(name),
            params={"appNamespace": app_namespace, "project": project},
        )

    def get_manifests(self, name, revision=None, app_namespace=None, project=None):
        """Return the manifests rendered for a revision of an Application."""
        return self._request(
            "GET",
            self._app_path(name) + "/manifests",
            params={
                "revision": revision,
                "appNamespace": app_namespace,
                "project": project,
            },
        )

    def get_managed_resources(self, name, app_namespace=None, project=None):
        """Return the live resources of an Application with their target/live diff."""
        payload = self._request(
            "GET",
            self._app_path(name) + "/managed-resources",
            params={"appNamespace": app_namespace, "project": project},
        )
        return payload.get("items") or []

    def sync(self, name, revision=None, prune=False, resources=None, app_namespace=None, project=None):
        """Trigger a sync, optionally limited to a subset of resources."""
        payload = {"name": name, "prune": prune}
        if revision:
            payload["revision"] = revision
        if resources:
            payload["resources"] = resources
        if app_namespace:
            payload["appNamespace"] = app_namespace
        if project:
            payload["project"] = project
        return self._request("POST", self._app_path(name) + "/sync", payload=payload)

    def rollback(self, name, history_id, prune=False, app_namespace=None, project=None):
        """Roll an Application back to the deployment recorded under a history id."""
        payload = {"name": name, "id": history_id, "prune": prune}
        if app_namespace:
            payload["appNamespace"] = app_namespace
        if project:
            payload["project"] = project
        return self._request("POST", self._app_path(name) + "/rollback", payload=payload)


# -- helpers ---------------------------------------------------------------
def app_sync_status(app):
    """Sync status of an Application, e.g. Synced or OutOfSync."""
    status = app.get("status") or {}
    return (status.get("sync") or {}).get("status") or "Unknown"


def app_health_status(app):
    """Health status of an Application, e.g. Healthy or Degraded."""
    status = app.get("status") or {}
    return (status.get("health") or {}).get("status") or "Unknown"


def app_target_revision(app):
    """The revision the Application wants to run."""
    spec = app.get("spec") or {}
    source = spec.get("source") or {}
    if source.get("targetRevision"):
        return source["targetRevision"]
    for entry in spec.get("sources") or []:
        if entry.get("targetRevision"):
            return entry["targetRevision"]
    return ""


def app_live_revision(app):
    """The revision the cluster was last compared against."""
    status = app.get("status") or {}
    return (status.get("sync") or {}).get("revision") or ""


def app_history(app):
    """The deployment history of an Application, newest id first."""
    status = app.get("status") or {}
    entries = [entry for entry in (status.get("history") or []) if entry.get("id") is not None]
    return sorted(entries, key=lambda entry: entry.get("id"), reverse=True)


def resource_key(item):
    """Identity of a Kubernetes object, matching the fields the API reports."""
    return (
        item.get("group") or "",
        item.get("kind") or "",
        item.get("namespace") or "",
        item.get("name") or "",
    )


def resource_label(key):
    """Human-readable label for a resource identity."""
    group, kind, namespace, name = key
    parts = ["%s/%s" % (kind, name)]
    if group:
        parts.append("group=" + group)
    parts.append("ns=" + (namespace or "-"))
    return " ".join(parts)


def parse_resource_selector(raw):
    """Parse kind/namespace/name or group/kind/namespace/name into a sync filter."""
    parts = [part.strip() for part in raw.split("/") if part.strip()]
    if len(parts) == 3:
        kind, namespace, name = parts
        return {"group": "", "kind": kind, "namespace": namespace, "name": name}
    if len(parts) == 4:
        group, kind, namespace, name = parts
        return {"group": group, "kind": kind, "namespace": namespace, "name": name}
    raise ValueError(
        "resource selector %r must look like kind/namespace/name or "
        "group/kind/namespace/name" % raw
    )


def format_patch(patch_text, limit=6):
    """Render the JSON patch the API returns for a changed resource."""
    try:
        operations = json.loads(patch_text)
    except ValueError:
        return [patch_text.strip()[:160]]
    if not isinstance(operations, list):
        return [str(operations)[:160]]
    lines = []
    for operation in operations:
        if not isinstance(operation, dict):
            continue
        kind = operation.get("op", "?")
        path = operation.get("path", "")
        if "value" in operation:
            lines.append("%s %s -> %s" % (kind, path, json.dumps(operation["value"])[:100]))
        else:
            lines.append("%s %s" % (kind, path))
    return lines[:limit] or ["(no patch detail returned)"]


def print_table(headers, rows):
    """Print a fixed-width table."""
    widths = [len(header) for header in headers]
    text_rows = []
    for row in rows:
        cells = ["" if cell is None else str(cell) for cell in row]
        text_rows.append(cells)
        for index, cell in enumerate(cells):
            widths[index] = max(widths[index], len(cell))
    print("  ".join(header.ljust(widths[index]) for index, header in enumerate(headers)))
    print("  ".join("-" * width for width in widths))
    for cells in text_rows:
        print("  ".join(cell.ljust(widths[index]) for index, cell in enumerate(cells)))


# -- commands --------------------------------------------------------------
def command_report(client, args):
    """List the Applications that are OutOfSync or Degraded."""
    projects = [args.project] if args.project else None
    applications = client.list_applications(
        projects=projects,
        selector=args.selector,
        repo=args.repo,
        app_namespace=args.app_namespace,
    )
    if args.as_json:
        json.dump(applications, sys.stdout, indent=2)
        sys.stdout.write("\n")
        return 0

    rows = []
    attention = 0
    for application in applications:
        sync_status = app_sync_status(application)
        health_status = app_health_status(application)
        drifting = sync_status != "Synced" or health_status == "Degraded"
        if drifting:
            attention += 1
        if not args.show_all and not drifting:
            continue
        metadata = application.get("metadata") or {}
        spec = application.get("spec") or {}
        rows.append(
            [
                metadata.get("name", "?"),
                spec.get("project", "default"),
                sync_status,
                health_status,
                app_target_revision(application),
                app_live_revision(application)[:12],
            ]
        )

    print_table(
        ["NAME", "PROJECT", "SYNC", "HEALTH", "TARGET", "LIVE"], rows
    )
    print()
    print("%d application(s) reported, %d OutOfSync or Degraded." % (len(applications), attention))
    return 0


def command_diff(client, args):
    """Compare the live resources of an Application with its target revision."""
    application = client.get_application(
        args.name, app_namespace=args.app_namespace, project=args.project
    )
    status = application.get("status") or {}
    spec = application.get("spec") or {}
    target_revision = app_target_revision(application)
    wanted_revision = args.revision or target_revision or None

    manifests = client.get_manifests(
        args.name,
        revision=wanted_revision,
        app_namespace=args.app_namespace,
        project=args.project,
    )
    rendered = manifests.get("manifests") or manifests.get("items") or []
    resolved_revision = manifests.get("revision") or ""

    managed = client.get_managed_resources(
        args.name, app_namespace=args.app_namespace, project=args.project
    )
    managed_by_key = {resource_key(item): item for item in managed}
    declared_by_key = {resource_key(item): item for item in (status.get("resources") or [])}

    print("Application : %s (project %s)" % (args.name, spec.get("project", "default")))
    print("Sync status : %s   Health: %s" % (app_sync_status(application), app_health_status(application)))
    print("Target rev  : %s" % (target_revision or "(not set)"))
    print("Live rev    : %s" % (app_live_revision(application) or "(unknown)"))
    if wanted_revision:
        print(
            "Rendered    : %s -> %s (%d manifest(s))"
            % (wanted_revision, resolved_revision or "(unresolved)", len(rendered))
        )
    print()

    rows = []
    for key, item in managed_by_key.items():
        if item.get("modified"):
            state = "CHANGED"
        else:
            state = "IN-SYNC"
        if key not in declared_by_key:
            state = "EXTRA"
        rows.append([state, resource_label(key), item.get("resourceVersion", "")[:12]])
    for key in declared_by_key:
        if key not in managed_by_key:
            rows.append(["MISSING", resource_label(key), ""])

    print_table(["STATE", "RESOURCE", "RV"], rows)

    print()
    changed = [item for item in managed if item.get("modified")]
    if changed:
        print("Differences reported by the API:")
        for item in changed:
            print("  %s" % resource_label(resource_key(item)))
            for line in format_patch(item.get("diff") or ""):
                print("    %s" % line)
        print()

    counts = {"CHANGED": 0, "IN-SYNC": 0, "EXTRA": 0, "MISSING": 0}
    for row in rows:
        counts[row[0]] = counts.get(row[0], 0) + 1
    print(
        "Summary: %d changed, %d in-sync, %d extra, %d missing."
        % (counts["CHANGED"], counts["IN-SYNC"], counts["EXTRA"], counts["MISSING"])
    )
    return 0


def command_sync(client, args):
    """Sync an Application, optionally limited to specific resources."""
    resources = None
    if args.resource:
        resources = []
        for selector in args.resource:
            try:
                resources.append(parse_resource_selector(selector))
            except ValueError as exc:
                raise ArgoCDError(str(exc)) from exc

    application = client.sync(
        args.name,
        revision=args.revision,
        prune=args.prune,
        resources=resources,
        app_namespace=args.app_namespace,
        project=args.project,
    )
    scope = "%d resource(s)" % len(resources) if resources else "all resources"
    print("Sync requested for %s (%s)." % (args.name, scope))
    print_application_result(application)
    return 0


def command_rollback(client, args):
    """Roll an Application back to an earlier deployment."""
    application = client.get_application(
        args.name, app_namespace=args.app_namespace, project=args.project
    )
    history = app_history(application)
    if not history:
        raise ArgoCDError("%s has no deployment history to roll back to" % args.name)

    history_id = args.id
    if history_id is None and args.to_revision:
        match = next(
            (entry for entry in history if entry.get("revision") == args.to_revision), None
        )
        if match is None:
            raise ArgoCDError(
                "no deployment of revision %s in the history of %s" % (args.to_revision, args.name)
            )
        history_id = match.get("id")
    if history_id is None:
        live_revision = app_live_revision(application)
        earlier = next(
            (entry for entry in history if entry.get("revision") != live_revision), None
        )
        if earlier is None:
            raise ArgoCDError("%s has no earlier deployment to roll back to" % args.name)
        history_id = earlier.get("id")

    result = client.rollback(
        args.name,
        history_id,
        prune=args.prune,
        app_namespace=args.app_namespace,
        project=args.project,
    )
    print("Rollback of %s requested for deployment id %s." % (args.name, history_id))
    print_application_result(result)
    return 0


def print_application_result(application):
    """Print the state of an Application after a write call."""
    if not application:
        print("The API returned an empty response.")
        return
    status = application.get("status") or {}
    operation = status.get("operationState") or {}
    print("Sync status : %s   Health: %s" % (app_sync_status(application), app_health_status(application)))
    print("Live rev    : %s" % (app_live_revision(application) or "(unknown)"))
    if operation:
        print("Operation   : %s %s" % (operation.get("phase", "?"), operation.get("message", "")))


# -- wiring ----------------------------------------------------------------
def resolve_client(args):
    """Build a client from the command line and the environment."""
    server = args.server or os.environ.get("ARGOCD_API_SERVER")
    if not server:
        raise ArgoCDError("no API server given: pass --server or set ARGOCD_API_SERVER")
    if "://" not in server:
        server = "https://" + server

    token = args.token or os.environ.get("ARGOCD_AUTH_TOKEN")
    client = ArgoCDClient(
        server, token=token, timeout=args.timeout, verify_tls=not args.insecure
    )
    if not client.token:
        username = args.username or os.environ.get("ARGOCD_USERNAME")
        password = args.password or os.environ.get("ARGOCD_PASSWORD")
        if not username or not password:
            raise ArgoCDError(
                "no credentials given: pass --token, or --username and --password"
            )
        client.login(username, password)
    return client


def build_parser():
    """Build the argument parser with one subcommand per action.

    The connection options are accepted both before and after the subcommand.
    They are declared with a suppressed default so that a value given before
    the subcommand is not overwritten by the subcommand's own default.
    """
    common = argparse.ArgumentParser(add_help=False)
    common.add_argument(
        "--server", default=argparse.SUPPRESS, help="Argo CD API server, e.g. argocd.example.com"
    )
    common.add_argument(
        "--token", default=argparse.SUPPRESS, help="API token; falls back to $ARGOCD_AUTH_TOKEN"
    )
    common.add_argument(
        "--username", default=argparse.SUPPRESS, help="account used to obtain a token"
    )
    common.add_argument(
        "--password", default=argparse.SUPPRESS, help="password of the account"
    )
    common.add_argument(
        "--insecure",
        action="store_true",
        default=argparse.SUPPRESS,
        help="do not verify the server certificate",
    )
    common.add_argument(
        "--timeout",
        type=float,
        default=argparse.SUPPRESS,
        help="request timeout in seconds",
    )
    common.add_argument(
        "--app-namespace",
        dest="app_namespace",
        default=argparse.SUPPRESS,
        help="namespace the Application lives in",
    )
    common.add_argument(
        "--project", default=argparse.SUPPRESS, help="Argo CD project name"
    )

    parser = argparse.ArgumentParser(
        description="Report, diff, sync, and roll back Argo CD Applications.",
        parents=[common],
    )
    subcommands = parser.add_subparsers(dest="command", required=True)

    report = subcommands.add_parser(
        "report", parents=[common], help="list Applications that are OutOfSync or Degraded"
    )
    report.add_argument("--all", dest="show_all", action="store_true", help="include healthy Applications")
    report.add_argument("--selector", help="only Applications matching this label selector")
    report.add_argument("--repo", help="only Applications from this repository URL")
    report.add_argument("--json", dest="as_json", action="store_true", help="print the raw API payload")
    report.set_defaults(func=command_report)

    diff = subcommands.add_parser(
        "diff", parents=[common], help="compare live resources with the target revision"
    )
    diff.add_argument("name", help="Application name")
    diff.add_argument(
        "--revision", help="revision to render the desired state from (default: the target revision)"
    )
    diff.set_defaults(func=command_diff)

    sync = subcommands.add_parser(
        "sync", parents=[common], help="sync an Application, optionally a subset of resources"
    )
    sync.add_argument("name", help="Application name")
    sync.add_argument("--revision", help="revision to sync to (default: the target revision)")
    sync.add_argument(
        "--prune", action="store_true", help="delete resources that are no longer in Git"
    )
    sync.add_argument(
        "--resource",
        action="append",
        help="sync only this resource: kind/namespace/name or group/kind/namespace/name",
    )
    sync.set_defaults(func=command_sync)

    rollback = subcommands.add_parser(
        "rollback", parents=[common], help="roll an Application back to an earlier deployment"
    )
    rollback.add_argument("name", help="Application name")
    rollback.add_argument("--id", type=int, help="deployment history id to roll back to")
    rollback.add_argument(
        "--to-revision", dest="to_revision", help="roll back to the deployment of this revision"
    )
    rollback.add_argument(
        "--prune", action="store_true", help="delete resources that are no longer in Git"
    )
    rollback.set_defaults(func=command_rollback)

    return parser


def main(argv=None):
    parser = build_parser()
    args = parser.parse_args(argv)
    for key, value in COMMON_DEFAULTS.items():
        if not hasattr(args, key):
            setattr(args, key, value)
    try:
        client = resolve_client(args)
        return args.func(client, args)
    except ArgoCDError as exc:
        print("error: %s" % exc, file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
