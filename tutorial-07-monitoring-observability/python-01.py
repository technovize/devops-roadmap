# pip install prometheus-client
from prometheus_client import Counter, Histogram, Gauge, start_http_server
import time

# -- Define Metrics ----------------------------------------------------------

# Counter: monotonically increasing — total requests, total errors
http_requests_total = Counter(
    'http_requests_total',
    'Total number of HTTP requests',
    ['method', 'endpoint', 'status_code']  # Labels for filtering/grouping
)

http_errors_total = Counter(
    'http_errors_total',
    'Total number of HTTP errors',
    ['method', 'endpoint', 'error_type']
)

# Histogram: tracks distribution of values — ideal for latency
http_request_duration_seconds = Histogram(
    'http_request_duration_seconds',
    'HTTP request duration in seconds',
    ['method', 'endpoint'],
    buckets=[0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5, 5.0, 10.0]
)

# Gauge: value that can go up and down — queue depth, active connections
db_connection_pool_active = Gauge(
    'db_connection_pool_active',
    'Number of active database connections'
)

db_connection_pool_size = Gauge(
    'db_connection_pool_size',
    'Total size of database connection pool'
)

# -- Use in a Django/Flask View ----------------------------------------------

def track_request(method, endpoint):
    """Decorator for instrumenting HTTP request handlers."""
    def decorator(func):
        def wrapper(*args, **kwargs):
            start_time = time.time()
            status_code = 200

            try:
                result = func(*args, **kwargs)
                # Extract status code from response if available
                if hasattr(result, 'status_code'):
                    status_code = result.status_code
                return result
            except Exception as e:
                status_code = 500
                http_errors_total.labels(
                    method=method,
                    endpoint=endpoint,
                    error_type=type(e).__name__
                ).inc()
                raise
            finally:
                duration = time.time() - start_time
                http_requests_total.labels(
                    method=method,
                    endpoint=endpoint,
                    status_code=str(status_code)
                ).inc()
                http_request_duration_seconds.labels(
                    method=method,
                    endpoint=endpoint
                ).observe(duration)

        return wrapper
    return decorator


# -- Django Integration -----------------------------------------------------

# In urls.py — expose /metrics endpoint for Prometheus to scrape
from django.urls import path
from prometheus_client import generate_latest, CONTENT_TYPE_LATEST
from django.http import HttpResponse

def metrics_view(request):
    return HttpResponse(
        generate_latest(),
        content_type=CONTENT_TYPE_LATEST
    )

# urls.py
urlpatterns = [
    path('metrics', metrics_view),
    # ... other URLs
]
