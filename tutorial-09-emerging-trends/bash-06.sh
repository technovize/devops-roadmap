#!/usr/bin/env bash
set -euo pipefail

# Install Istio
istioctl install --set profile=production -y

# Enable automatic sidecar injection for the production namespace
kubectl label namespace production istio-injection=enabled

# Verify sidecars are being injected
kubectl get pods -n production -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[*].name}{"\n"}{end}'
