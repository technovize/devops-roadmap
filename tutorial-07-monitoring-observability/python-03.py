# pip install opentelemetry-api opentelemetry-sdk opentelemetry-instrumentation-django
# pip install opentelemetry-exporter-otlp-proto-grpc

from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.resources import Resource

# -- Setup ----------------------------------------------------------------------

resource = Resource.create({
    "service.name":    "payment-service",
    "service.version": "1.2.0",
    "deployment.environment": "production",
})

provider = TracerProvider(resource=resource)

# Export traces to an OTel Collector (which forwards to Jaeger/Tempo)
exporter = OTLPSpanExporter(
    endpoint="http://otel-collector.monitoring.svc.cluster.local:4317",
    insecure=True
)

provider.add_span_processor(BatchSpanProcessor(exporter))
trace.set_tracer_provider(provider)

tracer = trace.get_tracer("payment-service")


# -- Automatic Instrumentation --------------------------------------------------
# Django, Flask, FastAPI, requests, psycopg2, redis — all auto-instrumented

# settings.py (Django)
INSTALLED_APPS = [
    "opentelemetry.instrumentation.django",
    # ...
]


# -- Manual Spans ---------------------------------------------------------------

def process_payment(user_id: str, amount: float):
    with tracer.start_as_current_span("process_payment") as span:
        # Attach attributes to the span
        span.set_attribute("user.id",        user_id)
        span.set_attribute("payment.amount", amount)
        span.set_attribute("payment.currency", "USD")

        # Child span for Stripe API call
        with tracer.start_as_current_span("stripe.charge") as stripe_span:
            try:
                result = stripe_client.charge(amount=amount)
                stripe_span.set_attribute("stripe.charge_id", result.id)
                stripe_span.set_attribute("stripe.status", "success")
                return result

            except stripe.error.CardError as e:
                stripe_span.set_attribute("stripe.status", "declined")
                stripe_span.set_attribute("stripe.decline_code", e.decline_code)
                stripe_span.record_exception(e)
                stripe_span.set_status(trace.StatusCode.ERROR, str(e))
                raise

        # Child span for database write
        with tracer.start_as_current_span("db.save_transaction"):
            save_transaction_to_db(user_id=user_id, amount=amount, charge_id=result.id)
