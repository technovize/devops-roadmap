#!/usr/bin/env bash
set -euo pipefail

docker compose up -d

# Open Prometheus: http://localhost:9090
# Query: http_requests_total
# Query: rate(http_requests_total[5m])

# Open Grafana: http://localhost:3000 (admin/admin)
# Add Prometheus data source: http://prometheus:9090
# Create a panel with: sum(rate(http_requests_total[5m])) by (status)
