---
last_verified: 2026-11-19
tool_version: 3.16.0
sources:
  - https://prometheus.io/docs/prometheus/latest/configuration/configuration/
  - https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/
  - https://prometheus.io/docs/prometheus/latest/querying/functions/#rate
  - https://prometheus.io/docs/alerting/latest/configuration/
  - https://github.com/prometheus/prometheus/releases/tag/v3.16.0
  - https://prometheus.io/download/
---
# Scrape the sample app and alert on errors

In [Prometheus — quick primer](../../Prometheus/notes/0000-primer-prometheus.md) you saw that Prometheus pulls metrics from targets and that alert rules fire when a condition holds. In [Monitoring and observability concepts](../../docs/concepts/monitoring-observability-concepts/0000-primer-monitoring-observability-concepts.md) you learned that metrics plus alerting turn raw numbers into actionable signals. This lesson connects the two: you point Prometheus at a sample app's `/metrics` endpoint, confirm the target is up, then write an error-rate alert and verify it fires by injecting failures yourself.

## What you'll learn

- Scrape the app's `/metrics` endpoint with a `scrape_config` (unique `job_name`, `static_configs` targets, `metrics_path: /metrics`, per-job `scrape_interval`) and confirm the target reports `up == 1` on the Targets page.
- Write an error-rate alerting rule built on `rate()` over a 5-minute range with a `for:` hold duration, labels, and annotations — then inject failures and watch the alert go pending and firing.

## Before you start

- [Prometheus — quick primer](../../Prometheus/notes/0000-primer-prometheus.md) — what a scrape job, a target, and an alerting rule are; Prometheus pulls, it does not wait to be pushed.
- [Monitoring and observability concepts](../../docs/concepts/monitoring-observability-concepts/0000-primer-monitoring-observability-concepts.md) — metrics, alerts, and why tracking error rates matters for reliability.
- [Probes, resource limits and autoscaling](../07-kubernetes/04-k8s-probes-limits-hpa.md) — a running app whose HTTP endpoints you can reach; here we scrape `/metrics` instead of probing `/health`.
- Prometheus v3.16.0 installed (`prometheus --version`), which includes `promtool` for config and rule validation (`promtool --version`).
- Python 3 to run the sample app (`python3 --version`).

## Walkthrough

1. Start the sample app and confirm `/metrics` answers.

   The kit ships a tiny sample app at `../../Prometheus/scripts/custom-app-exporter.py` that serves `/metrics` in Prometheus exposition format and counts requests and errors. Run it on port 8000:

   ```bash
   python3 ../../Prometheus/scripts/custom-app-exporter.py --port 8000 &
   ```

   In another terminal, hit the endpoint:

   ```bash
   curl -s http://localhost:8000/metrics
   ```

   You should see: `HELP`/`TYPE` lines plus counters such as `demo_http_requests_total` and `demo_http_errors_total`. If you get connection refused, the app is still starting — retry after a second.

2. Write the scrape config.

   Save this as `prometheus.yml`. It adds a `scrape_config` with a unique `job_name`, `static_configs` listing `localhost:8000`, `metrics_path: /metrics`, and a per-job `scrape_interval` of 5s (the global default is 1m, overridable per job):

   ```yaml
   global:
     scrape_interval: 15s
     evaluation_interval: 15s

   scrape_configs:
     - job_name: demo-app
       metrics_path: /metrics
       scrape_interval: 5s
       static_configs:
         - targets: ["localhost:8000"]
   ```

3. Validate the config before starting Prometheus.

   ```bash
   promtool check config prometheus.yml
   ```

   You should see: `Checking prometheus.yml` followed by a success line. A malformed file exits non-zero with a line and column, and Prometheus keeps its old config in memory until you fix it.

4. Start Prometheus and confirm the target is up.

   ```bash
   ./prometheus --config.file=prometheus.yml
   ```

   Open `http://localhost:9090/targets` and find the `demo-app` job.

   You should see: the `demo-app` target listed with `State: up` and an empty `lastError`. Equivalently, `up == 1` for that target. If it shows `down`, confirm `curl http://localhost:8000/metrics` works from the same host Prometheus runs on.

5. Write the error-rate alerting rule.

   Save this as `alerts.yml`. The rule computes the per-second error rate over 5 minutes with `rate()` and fires when it exceeds 0 for 30 seconds:

   ```yaml
   groups:
     - name: demo-app-alerts
       rules:
         - alert: DemoAppErrorRate
           expr: rate(demo_http_errors_total[5m]) > 0
           for: 30s
           labels:
             severity: warning
           annotations:
             summary: "Demo app error rate is elevated"
             description: "More than 0 errors per second over the last 5 minutes on {{ $labels.instance }}."
   ```

   `demo_http_errors_total` already counts only failed requests, so no `code=` filter is needed. If your counter carried an HTTP status label you would write `rate(http_errors_total{code=~"5.."}[5m])`. Use `rate()` for alerts because it is counter-reset safe and must be taken before any aggregation; `irate()` is for graphing volatile counters.

6. Validate the rule file.

   ```bash
   promtool check rules alerts.yml
   ```

   You should see: `Checking alerts.yml` followed by a success line confirming the expression is valid PromQL.

7. Load the rules and reload Prometheus.

   Add `rule_files` to `prometheus.yml`:

   ```yaml
   rule_files:
     - "alerts.yml"
   ```

   Then reload Prometheus so it picks up the new file:

   ```bash
   # via signal
   kill -HUP <prometheus-pid>

   # or via HTTP
   curl -X POST http://localhost:9090/-/reload
   ```

   A malformed reload is not applied and the old config stays in memory — if reload fails, `promtool check config` will have told you why.

   Confirm the rule loaded:

   ```bash
   curl -s "http://localhost:9090/api/v1/rules" | python3 -m json.tool
   ```

   You should see: the `demo-app-alerts` group with the `DemoAppErrorRate` rule listed (state will be `inactive` until it fires).

8. Inject failures and confirm the alert fires.

   Generate errors against the app's `/demo?fail=1` endpoint (it returns 500 and increments `demo_http_errors_total`):

   ```bash
   for i in $(seq 1 25); do curl -s http://localhost:8000/demo?fail=1 >/dev/null; sleep 1; done
   ```

   Wait for the rule's `for:` duration (30 seconds) to elapse, then check the alert state:

   ```bash
   curl -s "http://localhost:9090/api/v1/query?query=ALERTS{alertstate=\"firing\"}" | python3 -m json.tool
   ```

   You should see: `DemoAppErrorRate` with `state: firing`, and the same alert listed on the `/alerts` page. Before `for:` elapsed it was `pending`; after it holds, it is `firing`.

## Exercise

Do the whole flow on your own, against a fresh Prometheus instance:

1. Run the sample app on a different port (e.g. 8001).
2. Write `my-prometheus.yml` with a `scrape_config` named `my-app` that scrapes `localhost:8001/metrics` with `scrape_interval: 10s`.
3. Validate it with `promtool check config`.
4. Start Prometheus with that config and confirm the `my-app` target is `up` on the Targets page.
5. Write `my-alerts.yml` with an error-rate alert (`rate()` over a 5-minute range, `for:` hold duration, `labels` and `annotations`), validate it with `promtool check rules`, and add it to `rule_files`.
6. Reload Prometheus and confirm the rule loads.
7. Inject failures and confirm your alert goes pending, then firing, on the `/alerts` page.

No solution is provided — run each step and verify it yourself.

## Check your work

```bash
curl -sf http://localhost:8001/metrics | head -5                       # /metrics answers
promtool check config my-prometheus.yml                                # config validates
promtool check rules my-alerts.yml                                     # rule validates
curl -s http://localhost:9090/targets                                  # my-app target State: up
curl -s "http://localhost:9090/api/v1/query?query=ALERTS{alertstate=\"firing\"}"  # your alert fires
```

You should see: the `/metrics` endpoint returns `HELP`/`TYPE` lines, both `promtool` commands exit 0, the `my-app` target shows `State: up`, and `ALERTS{alertstate="firing"}` returns your alert by name.

## Common mistakes

- `scrape_interval: 15` instead of `15s`: Prometheus expects a duration (`15s`), not a bare number; `promtool check config` exits non-zero and a bad reload is not applied.
- Missing `job_name`: it is a required field in every `scrape_config`.
- Target shows `up == 0`: wrong host:port, wrong `metrics_path`, wrong `scheme`, or the app listening on localhost only. Confirm by curling `<target>/metrics` from the Prometheus host and read `lastError` on `/targets`.
- `scrape_timeout` greater than `scrape_interval`: accepted by the schema but every scrape races the next interval; lower the timeout or raise the interval.
- Alert stuck in `pending` or never fires: the expression returns no samples, the `for:` duration is longer than the condition ever holds, or the rule group was never loaded. Confirm the raw expression returns data in `/graph`, check `ALERTS{alertstate="pending"}` and `/alerts` before blaming Alertmanager.
- Using `irate()` for an alert, or aggregating before applying `rate()`: `rate()` belongs to alerts and must come before any aggregation.

## Next

[A Grafana dashboard kept in Git](../../00_index/learning-path.md)
