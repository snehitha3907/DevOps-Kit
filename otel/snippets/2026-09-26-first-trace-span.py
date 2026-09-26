# last_verified: 2026-09-26 · opentelemetry-sdk n/a
"""My first trace span: wrap a bit of work, then ship it to a local Collector."""

from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import SimpleSpanProcessor

provider = TracerProvider()
provider.add_span_processor(SimpleSpanProcessor(OTLPSpanExporter(endpoint="localhost:4317")))
trace.set_tracer_provider(provider)

tracer = trace.get_tracer("first-span")
with tracer.start_as_current_span("say-hello") as span:
    span.set_attribute("hello.to", "world")
    print("sent one span to localhost:4317")
