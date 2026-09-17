from flask import Flask, request, jsonify, Response
from prometheus_client import Counter, Histogram, Gauge, generate_latest, CONTENT_TYPE_LATEST
import time, random

app = Flask(__name__)

REQUEST_COUNT = Counter(
    'http_requests_total',
    'Total HTTP requests',
    ['method', 'endpoint', 'status']
)

REQUEST_LATENCY = Histogram(
    'http_request_duration_seconds',
    'HTTP request duration',
    ['method', 'endpoint'],
    buckets=[.005, .01, .025, .05, .1, .25, .5, 1, 2.5, 5]
)

ACTIVE_REQUESTS = Gauge('http_requests_active', 'Active HTTP requests')

@app.before_request
def before_request():
    request.start_time = time.time()
    ACTIVE_REQUESTS.inc()

@app.after_request
def after_request(response):
    duration = time.time() - request.start_time
    endpoint = request.path
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
    return response

@app.route('/health')
def health():
    return jsonify({"status": "healthy"})

@app.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)

@app.route('/api/orders', methods=['POST'])
def create_order():
    time.sleep(random.uniform(0.01, 0.5))
    return jsonify({"order_id": "ord_123"}), 201

if __name__ == '__main__':
    app.run(port=8000)
