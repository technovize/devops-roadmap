#!/usr/bin/env bash
set -euo pipefail

# Run and test
pip install flask prometheus-client
python app.py &

# Generate some traffic
for i in {1..50}; do
  curl -s -X POST http://localhost:8000/api/orders > /dev/null
  curl -s http://localhost:8000/health > /dev/null
done

# View metrics
curl http://localhost:8000/metrics | grep http_requests
