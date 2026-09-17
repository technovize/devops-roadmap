# app.py — instrument this application with:
# 1. A counter for total requests by method, path, status
# 2. A histogram for request duration by method, path
# 3. A gauge for active requests
# 4. A /metrics endpoint
# 5. A /health endpoint

from flask import Flask, request, jsonify
from prometheus_client import Counter, Histogram, Gauge, generate_latest, CONTENT_TYPE_LATEST
import time
import random

app = Flask(__name__)

# TODO: Define your metrics here

@app.before_request
def before_request():
    # TODO: track active requests and start time
    pass

@app.after_request
def after_request(response):
    # TODO: record metrics after each request
    return response

@app.route('/health')
def health():
    return jsonify({"status": "healthy"})

@app.route('/metrics')
def metrics():
    # TODO: return prometheus metrics
    pass

@app.route('/api/orders', methods=['POST'])
def create_order():
    time.sleep(random.uniform(0.01, 0.5))  # Simulate variable latency
    return jsonify({"order_id": "ord_123", "status": "created"}), 201

if __name__ == '__main__':
    app.run(port=8000, debug=True)
