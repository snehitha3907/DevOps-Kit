// last_verified: 2026-09-30 · Grafana Cloud (n/a)
// My first dashboard over the HTTP API. I set GRAFANA_URL and GRAFANA_TOKEN in the shell first.
// TODO: not sure of the request path or field names yet - checking the dashboard API docs.

const base = process.env.GRAFANA_URL;
const token = process.env.GRAFANA_TOKEN;
const dashboard = { title: 'first-dashboard', panels: [{ title: 'up', type: 'stat' }] };

async function main() {
  const res = await fetch(`${base}/api/dashboards/db`, {
    method: 'POST',
    headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ dashboard }),
  });
  console.log(res.status, await res.text());
}

main();
