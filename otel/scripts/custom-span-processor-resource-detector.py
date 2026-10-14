# last_verified: 2026-10-14 · opentelemetry-sdk n/a
"""Custom span processor + resource detector: attach app attributes and batch-export spans to an OTLP endpoint.

I wrote this to learn the seam between the SDK's built-in SimpleSpanProcessor and the
BatchSpanProcessor, and to see how a Resource attaches attributes that every span inherits.
It runs standalone: it starts a tracer, emits a handful of spans, and ships them to an
OTLP endpoint. Run me with `python3 <this-file>` after a Collector is listening on
localhost:4317.
"""

from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.resources import Resource, SERVICE_NAME, SERVICE_VERSION
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor


class AttributeAddingSpanProcessor:
    """A span processor that stamps a fixed attribute onto every span it sees.

    This is the shape a custom processor takes: implement `on_start`, `on_end`,
    and `shutdown`. The SDK calls `on_start` when a span begins and `on_end` when it
    finishes, so any per-span decoration that does not need the exporter can live here.
    """

    def __init__(self, exporter, attributes):
        self._exporter = exporter
        self._attributes = attributes

    def on_start(self, span, parent_context=None):
        for key, value in self._attributes.items():
            span.set_attribute(key, value)

    def on_end(self, span):
        self._exporter.export([span])

    def shutdown(self):
        self._exporter.shutdown()

    def force_flush(self, timeout_millis=30000):
        return True


def build_resource():
    """A Resource describes the process emitting spans, not the spans themselves.

    SERVICE_NAME and SERVICE_VERSION are the two fields the Collector and any backend
    rely on to group spans. Everything else here is extra metadata that shows up on
    every span without being set per-span.
    """
    return Resource.create(
        {
            SERVICE_NAME: "demo-batch-app",
            SERVICE_VERSION: "1.0.0",
            "deployment.environment": "dev",
            "service.instance.id": "demo-001",
        }
    )


def main():
    resource = build_resource()
    exporter = OTLPSpanExporter(endpoint="localhost:4317")
    provider = TracerProvider(resource=resource)

    # The custom processor is what this file is about: it stamps the app's
    # attributes onto every span in on_start, then hands each finished span to
    # the OTLP exporter in on_end. The BatchSpanProcessor is the batching layer
    # underneath it, so spans still get grouped before they leave the process.
    provider.add_span_processor(
        AttributeAddingSpanProcessor(
            BatchSpanProcessor(
                exporter, max_export_batch_size=128, schedule_delay_millis=2000
            ),
            {"app.name": "demo-batch-app", "app.environment": "dev"},
        )
    )
    trace.set_tracer_provider(provider)

    tracer = trace.get_tracer("demo-app")
    with tracer.start_as_current_span("do-work") as root:
        root.set_attribute("app.task", "demo")
        with tracer.start_as_current_span("sub-task-a"):
            with tracer.start_as_current_span("sub-task-b"):
                print("emitted a small trace; check the Collector log")

    provider.shutdown()


if __name__ == "__main__":
    main()