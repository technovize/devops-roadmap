#!/usr/bin/env bash
set -euo pipefail

# Check: Is the exporter configured to the correct endpoint?
exporter = OTLPSpanExporter(
    endpoint="http://otel-collector:4317",  # gRPC endpoint
    # endpoint="http://otel-collector:4318",  # HTTP endpoint
    insecure=True
)

# Check: Is the OTel collector running?
kubectl get pods -n monitoring | grep otel

# Check collector logs for errors
kubectl logs -n monitoring deployment/otel-collector

# Verify traces are being sent (add a debug exporter):
exporters:
  debug:
    verbosity: detailed

service:
  pipelines:
    traces:
      exporters: [otlp/tempo, debug]   # Add debug temporarily
