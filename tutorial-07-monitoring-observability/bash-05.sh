#!/usr/bin/env bash
set -euo pipefail

# Check Prometheus UI: Status -> Targets
# Common causes:

# 1. Wrong port or path in scrape config
# Fix: verify the metrics endpoint manually
curl http://your-app:8000/metrics

# 2. Network issue — Prometheus can't reach the target
# Fix: Check if they're on the same Docker network
docker network inspect bridge

# 3. Firewall or security group blocking port
# Fix: open the metrics port in security group

# 4. App not exposing metrics yet (still starting up)
# Fix: Add initialDelaySeconds to the ServiceMonitor
