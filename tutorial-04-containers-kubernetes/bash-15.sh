#!/usr/bin/env bash
set -euo pipefail

# Check service selector matches pod labels
kubectl get svc my-service -o yaml | grep selector -A5
kubectl get pods --show-labels | grep <app-label>

# Check endpoints (empty = no pods matched)
kubectl get endpoints my-service

# Test connectivity from within the cluster
kubectl run test --image=busybox --rm -it --restart=Never -- \
  wget -qO- http://my-service:80/health

# Check if pods are Ready (readiness probe must pass)
kubectl get pods -o wide
