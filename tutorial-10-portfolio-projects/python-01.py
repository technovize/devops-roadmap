# app/main.py — a fully instrumented FastAPI application for the demo

from fastapi import FastAPI, Request, Response
from prometheus_client import Counter, Histogram, Gauge, generate_latest, CONTENT_TYPE_LATEST
from opentelemetry import trace
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
import structlog
import time
import random

app = FastAPI(title="Observable Demo App")
FastAPIInstrumentor.instrument_app(app)   # Auto-instrument all routes

tracer = trace.get_tracer("demo-app")
log = structlog.get_logger()

# -- Prometheus metrics ------------------------------------------------------
REQUEST_COUNT = Counter(
    "http_requests_total",
    "Total HTTP requests",
    ["method", "endpoint", "status"]
)

REQUEST_LATENCY = Histogram(
    "http_request_duration_seconds",
    "HTTP request duration",
    ["method", "endpoint"],
    buckets=[.005, .01, .025, .05, .1, .25, .5, 1, 2.5, 5, 10]
)

ACTIVE_REQUESTS = Gauge(
    "http_requests_active",
    "Currently active HTTP requests"
)

ORDER_TOTAL = Counter(
    "orders_processed_total",
    "Total orders processed",
    ["status", "payment_method"]
)

ORDER_VALUE = Histogram(
    "order_value_dollars",
    "Distribution of order values",
    buckets=[10, 25, 50, 100, 250, 500, 1000]
)

# -- Middleware: instrument every request ------------------------------------
@app.middleware("http")
async def metrics_middleware(request: Request, call_next):
    ACTIVE_REQUESTS.inc()
    start = time.time()

    response = await call_next(request)

    duration = time.time() - start
    endpoint = request.url.path

    REQUEST_COUNT.labels(
        method=request.method,
        endpoint=endpoint,
        status=str(response.status_code)
    ).inc()

    REQUEST_LATENCY.labels(
        method=request.method,
        endpoint=endpoint
    ).observe(duration)

    ACTIVE_REQUESTS.dec()

    # Add trace ID to response headers for correlation
    span = trace.get_current_span()
    if span.is_recording():
        response.headers["X-Trace-Id"] = format(span.get_span_context().trace_id, '032x')

    return response

# -- Endpoints ---------------------------------------------------------------
@app.get("/health")
async def health():
    return {"status": "healthy", "version": "1.0.0"}

@app.get("/metrics")
async def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)

@app.post("/api/orders")
async def create_order(order: dict):
    with tracer.start_as_current_span("create_order") as span:
        span.set_attribute("order.amount", order.get("amount", 0))
        span.set_attribute("order.items", len(order.get("items", [])))

        log.info(
            "Processing order",
            amount=order.get("amount"),
            items=len(order.get("items", [])),
            customer_id=order.get("customer_id")
        )

        # Simulate processing with variable latency
        with tracer.start_as_current_span("payment_processing"):
            await process_payment(order)

        with tracer.start_as_current_span("inventory_check"):
            await check_inventory(order)

        ORDER_TOTAL.labels(
            status="completed",
            payment_method=order.get("payment_method", "card")
        ).inc()

        ORDER_VALUE.observe(order.get("amount", 0))

        log.info("Order completed successfully", order_id="ord_abc123")
        return {"order_id": "ord_abc123", "status": "completed"}
