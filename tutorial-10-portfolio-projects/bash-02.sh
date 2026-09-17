#!/bin/bash
# scripts/deploy-observability-stack.sh
set -euo pipefail

echo "=== Deploying Observability Stack ==="

# Add Helm repositories
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update

# 1. Prometheus + Grafana + Alertmanager
echo "--- Installing kube-prometheus-stack ---"
helm upgrade --install kube-prometheus-stack \
  prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --values monitoring/prometheus-values.yaml \
  --wait

# 2. Loki (log aggregation)
echo "--- Installing Loki ---"
helm upgrade --install loki \
  grafana/loki \
  --namespace monitoring \
  --values monitoring/loki-values.yaml \
  --wait

# 3. Promtail (log collection from pods)
helm upgrade --install promtail \
  grafana/promtail \
  --namespace monitoring \
  --set config.lokiAddress=http://loki.monitoring.svc.cluster.local:3100/loki/api/v1/push \
  --wait

# 4. Tempo (distributed tracing)
helm upgrade --install tempo \
  grafana/tempo \
  --namespace monitoring \
  --values monitoring/tempo-values.yaml \
  --wait

# 5. OpenTelemetry Collector
helm upgrade --install otel-collector \
  open-telemetry/opentelemetry-collector \
  --namespace monitoring \
  --values monitoring/otel-collector-values.yaml \
  --wait

echo "=== Stack deployed ==="
kubectl get pods -n monitoring

echo ""
echo "Access Grafana:"
echo "  kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80 -n monitoring"
echo "  URL: http://localhost:3000"
echo "  User: admin"
echo "  Pass: $(kubectl get secret kube-prometheus-stack-grafana -n monitoring -o jsonpath='{.data.admin-password}' | base64 -d)"
