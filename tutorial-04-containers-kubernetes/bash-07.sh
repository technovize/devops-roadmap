#!/usr/bin/env bash
set -euo pipefail

kubectl apply -f hpa.yaml
kubectl get hpa -n production
