# last_verified: 2026-11-19 · OpenTelemetry Python SDK 1.45.2
"""Trace one request from an app into a database call.

Runs a tiny HTTP "app" on :8080 and a "database" simulator on :9090. Each request to
the app opens a root span ``serve-request``; the app then calls the database, injecting
the current W3C ``traceparent`` into the outgoing request so the database span becomes a
child of the app's span. Both spans are exported via OTLP to a local Collector on
localhost:4317, so they land in the same trace.

Start a Collector receiving OTLP on 4317 first (see OpenTelemetry/configs/collector-debug.yaml),
then run me and curl http://localhost:8080/.
"""

from __future__ import annotations

from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from threading import Thread
from urllib.request import Request, urlopen

from opentelemetry import propagate, trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.propagators.webtracecontext import WebTraceContextPropagator
from opentelemetry.sdk.resources import Resource, SERVICE_NAME
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor

propagate.set_global_textmap(WebTraceContextPropagator())

resource = Resource.create({SERVICE_NAME: "demo-app"})
provider = TracerProvider(resource=resource)
provider.add_span_processor(
    BatchSpanProcessor(OTLPSpanExporter(endpoint="localhost:4317"))
)
trace.set_tracer_provider(provider)
tracer = trace.get_tracer("demo-app")


class DatabaseHandler(BaseHTTPRequestHandler):
    """Database simulator: each /query becomes a child span of the incoming trace."""

    def do_GET(self):
        if self.path != "/query":
            self.send_response(404)
            self.end_headers()
            return
        # Extract the incoming W3C context so this span is a child of the app's span.
        ctx = propagate.extract(self.headers)
        with tracer.start_as_current_span("db-query", context=ctx) as span:
            span.set_attribute("db.system", "demo-db")
            span.set_attribute("db.operation", "SELECT")
            body = b'{"ok": true}'
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
        sc = span.get_span_context()
        self.log_message(
            "db span trace=%s span=%s parent=%s",
            format(sc.trace_id, "032x"),
            format(sc.span_id, "016x"),
            format(sc.parent_span_id, "016x") if sc.parent_span_id else "-",
        )

    def log_message(self, format, *args):  # noqa: ARG002
        print(format % args)


class AppHandler(BaseHTTPRequestHandler):
    """App: one root span per request, then an instrumented call to the database."""

    def do_GET(self):
        if self.path != "/":
            self.send_response(404)
            self.end_headers()
            return
        with tracer.start_as_current_span("serve-request") as span:
            span.set_attribute("http.route", "/")
            carrier = {}
            propagate.inject(carrier)
            req = Request("http://127.0.0.1:9090/query")
            for key, value in carrier.items():
                req.add_header(key, value)
            try:
                with urlopen(req, timeout=3) as resp:
                    resp.read()
                span.set_attribute("db.call.ok", True)
            except Exception as exc:  # collector down is fine for a first run
                span.set_attribute("db.call.ok", False)
                span.set_attribute("error", str(exc))
            trace_id = format(span.get_span_context().trace_id, "032x")
            span.set_attribute("trace.id", trace_id)
            body = b'{"traced": true}'
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
        print("served request trace=%s" % trace_id)

    def log_message(self, format, *args):  # noqa: ARG002
        pass


def main():
    db = ThreadingHTTPServer(("127.0.0.1", 9090), DatabaseHandler)
    app = ThreadingHTTPServer(("127.0.0.1", 8080), AppHandler)
    Thread(target=db.serve_forever, daemon=True).start()
    Thread(target=app.serve_forever, daemon=True).start()
    print("app on :8080, database simulator on :9090, exporting to localhost:4317")
    try:
        while True:
            pass
    except KeyboardInterrupt:
        provider.shutdown()
        db.shutdown()
        app.shutdown()


if __name__ == "__main__":
    main()
