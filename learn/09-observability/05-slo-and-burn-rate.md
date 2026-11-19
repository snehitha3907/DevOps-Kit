---
last_verified: 2026-11-19
tool_version: n/a
sources: []
---
# Define an SLO and alert on its burn rate

In [A Grafana dashboard kept in Git](04-grafana-dashboard-as-code.md) you provisioned a Prometheus data source and a dashboard that plots the sample app's request rate, error rate, and latency. You can see the app is erroring, but you do not yet know whether it is meeting a reliability target, or how fast it is consuming its error budget. This lesson turns those metrics into an availability SLO and two burn-rate alerts — one that catches a sudden regression (fast burn) and one that catches gradual erosion (slow burn).

## What you'll learn

- Write an availability SLO for the app: successful requests divided by total requests over a window, expressed as a Prometheus recording rule.
- Alert on a fast burn rate: the error ratio spikes over a short window, burning the budget quickly.
- Alert on a slow burn rate: the error ratio creeps up over a long window, eating the budget gradually.

## Before you start

- [A Grafana dashboard kept in Git](04-grafana-dashboard-as-code.md) — Prometheus is running, scraping the sample app, and the app exposes `demo_http_requests_total` and `demo_http_errors_total` on `/metrics`.
- [Scrape the sample app and alert on errors](03-prometheus-scrape-and-alert.md) — the Prometheus instance and sample app this lesson builds on.
- Prometheus installed (`prometheus --version`) with `promtool` available (`promtool --version`) to validate rule files, and `curl` to query the API.
- The sample app running on port 8000 and Prometheus on port 9090.

## Walkthrough

1. Confirm the error metrics exist.

   From the previous lesson, the sample app is at `http://localhost:8000/metrics` and Prometheus scrapes it on port 9090. Confirm the counters are present:

   ```bash
   curl -s "http://localhost:9090/api/v1/query?query=demo_http_errors_total" | python3 -m json.tool
   ```

   You should see: at least one series for `demo_http_errors_total`. If the result is empty, start the app and Prometheus from the previous lesson first.

2. Record the error ratio as a SLO series.

   Save this as `slo-rules.yml`. It precomputes the error ratio (errors ÷ requests) over 5 minutes — one minus that ratio is your availability SLO:

   ```yaml
   groups:
     - name: demo-app-slo
       interval: 1m
       rules:
         - record: job:demo_http_error_ratio:5m
           expr: |
             sum by (job) (rate(demo_http_errors_total[5m]))
             /
             clamp_min(sum by (job) (rate(demo_http_requests_total[5m])), 1e-9)
   ```

   This follows the same recording-rule shape as the existing reference [`Prometheus/configs/recording-vs-alerting-rules.yaml`](../../Prometheus/configs/recording-vs-alerting-rules.yaml): precompute once so dashboards and alerts reuse one series.

   Validate it:

   ```bash
   promtool check rules slo-rules.yml
   ```

   You should see: `Checking slo-rules.yml` followed by a success line confirming the expression is valid PromQL.

   For a 99.9% availability SLO, the allowed error ratio (your budget) is 0.001 (0.1%). The SLO itself is `1 - job:demo_http_error_ratio:5m`, so availability of 0.999 or above meets the target. Your business picks the target; this lesson uses 99.9% as an example.

3. Load the rules into Prometheus.

   Add the file to `rule_files` in your `prometheus.yml` (from the previous lesson) and reload:

   ```yaml
   rule_files:
     - "slo-rules.yml"
   ```

   ```bash
   curl -X POST http://localhost:9090/-/reload
   ```

   Confirm it loaded:

   ```bash
   curl -s "http://localhost:9090/api/v1/rules" | python3 -m json.tool
   ```

   You should see: the `demo-app-slo` group with `job:demo_http_error_ratio:5m` listed, state `active` once evaluated.

4. Add a fast burn-rate alert.

   A fast burn means the error ratio spikes over a short window and burns the budget in minutes. Add this entry under the `rules:` list in `slo-rules.yml`:

   ```yaml
         - alert: DemoAppFastBurn
           expr: |
             sum by (job) (rate(demo_http_errors_total[5m]))
             / clamp_min(sum by (job) (rate(demo_http_requests_total[5m])), 1e-9) > 0.01
           for: 2m
           labels:
             severity: critical
             burn: fast
           annotations:
             summary: "Fast burn rate on {{ $labels.job }}"
             description: "More than 1% of requests failed over the last 5 minutes — the 0.1% budget is being consumed quickly."
   ```

   Thresholds here are examples: tune `0.01` and `for: 2m` to your SLO and how fast you want to react.

   Reload Prometheus (`curl -X POST http://localhost:9090/-/reload`) and confirm the alert appears on the `/alerts` page (initially `inactive` or `pending` until the condition holds).

5. Add a slow burn-rate alert.

   A slow burn means the error ratio stays above budget over a long window and erodes the budget day by day. Add a second entry under the `rules:` list in `slo-rules.yml`:

   ```yaml
         - alert: DemoAppSlowBurn
           expr: |
             sum by (job) (rate(demo_http_errors_total[24h]))
             / clamp_min(sum by (job) (rate(demo_http_requests_total[24h])), 1e-9) > 0.001
           for: 30m
           labels:
             severity: warning
             burn: slow
           annotations:
             summary: "Slow burn rate on {{ $labels.job }}"
             description: "Error ratio near the SLO budget over the last 24 hours."
   ```

   In production the slow window is typically 24 hours or 7 days; the principle is the same — a lower threshold over a longer window catches gradual erosion that a fast-burn alert misses.

   Reload and confirm both alerts load:

   ```bash
   curl -s "http://localhost:9090/api/v1/rules" | python3 -m json.tool
   ```

   You should see: both `DemoAppFastBurn` and `DemoAppSlowBurn` listed under the `demo-app-slo` group.

6. Confirm the SLO value and trigger the fast-burn alert.

   Query the recorded error ratio and derive availability:

   ```bash
   curl -s "http://localhost:9090/api/v1/query?query=job:demo_http_error_ratio:5m" | python3 -m json.tool
   curl -s "http://localhost:9090/api/v1/query?query=1 - job:demo_http_error_ratio:5m" | python3 -m json.tool
   ```

   You should see: a value near 0 (healthy) for the error ratio, and availability near 1 — e.g. `0.999` or better meets a 99.9% SLO example.

   Now inject errors and watch the fast-burn alert:

   ```bash
   for i in $(seq 1 60); do curl -s http://localhost:8000/demo?fail=1 >/dev/null; sleep 1; done
   ```

   After the `for: 2m` hold, check:

   ```bash
   curl -s "http://localhost:9090/api/v1/query?query=ALERTS{alertstate=\"firing\"}" | python3 -m json.tool
   ```

   You should see: `DemoAppFastBurn` with `state: firing`, and the same alert on the `/alerts` page. Stop injecting and it resolves once the error ratio falls below threshold.

## Exercise

Do the flow on your own against a fresh Prometheus instance:

1. Run the sample app on a different port (e.g. 8001) and scrape it with a new `scrape_config`.
2. Write `my-slo-rules.yml` with the availability recording rule (`job:demo_http_error_ratio:5m`) and both burn-rate alerts (fast over a short window, slow over a long window).
3. Validate with `promtool check rules`, add to `rule_files`, and reload Prometheus.
4. Confirm both alerts load and the SLO recording rule returns a value.
5. Inject errors against the app and confirm the fast-burn alert goes pending, then firing, on `/alerts`.
6. Stop the errors and confirm the alert resolves.

No solution is provided — run each step and verify it yourself.

## Check your work

```bash
promtool check rules my-slo-rules.yml                                                 # rules validate
curl -s http://localhost:9090/api/v1/rules | python3 -m json.tool                     # demo-app-slo group loaded
curl -s "http://localhost:9090/api/v1/query?query=job:demo_http_error_ratio:5m" | python3 -m json.tool  # error ratio returns a value
curl -s "http://localhost:9090/api/v1/query?query=ALERTS{alertname=\"DemoAppFastBurn\"}" | python3 -m json.tool  # fast-burn alert present
```

You should see: `promtool` exits 0, the `demo-app-slo` rule group is listed, the error-ratio series returns a value, and `DemoAppFastBurn` appears in the rules output (state depends on whether the condition currently holds).

## Common mistakes

- `rate()` on a counter that just restarted returns a spike or nothing: counters reset on restart, so treat the first few scrapes after a restart as unreliable.
- Division by zero: when no requests have been scraped yet, the denominator is zero and the ratio series disappears; `clamp_min(..., 1e-9)` avoids a hard divide-by-zero but the series is still absent until data arrives.
- Slow burn over `[24h]` needs 24 hours of data: in the lab the slow-burn rule loads but cannot fire until a full day of scrapes exists — that is expected; use a shorter window while learning, then switch to 24h/7d in production.
- `for:` too short makes the alert flappy; `for:` too long delays detection. Match the hold duration to how quickly you want to page.

## Next

[Trace one request with OpenTelemetry](06-otel-trace-request.md)
