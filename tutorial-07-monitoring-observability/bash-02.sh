#!/usr/bin/env bash
set -euo pipefail

# 1. Metrics — Prometheus + Grafana + Alertmanager
helm install kube-prometheus-stack \
  prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace \
  -f monitoring/prometheus-values.yaml

# 2. Logs — Loki + Fluent Bit
helm install loki \
  grafana/loki \
  -n monitoring \
  -f monitoring/loki-values.yaml

helm install fluent-bit \
  fluent/fluent-bit \
  -n monitoring \
  -f monitoring/fluent-bit-values.yaml

# 3. Traces — Tempo (Grafana's trace store)
helm install tempo \
  grafana/tempo \
  -n monitoring \
  -f monitoring/tempo-values.yaml

# 4. OTel Collector — receives and routes all telemetry
helm install otel-collector \
  open-telemetry/opentelemetry-collector \
  -n monitoring \
  -f monitoring/otel-collector-values.yaml

# Verify all pods are running
kubectl get pods -n monitoring
