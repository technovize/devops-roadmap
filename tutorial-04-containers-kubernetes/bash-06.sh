#!/usr/bin/env bash
set -euo pipefail

# Create namespaces
kubectl create namespace production
kubectl create namespace staging
kubectl create namespace monitoring

# List resources in a namespace
kubectl get pods -n staging

# List resources across all namespaces
kubectl get pods --all-namespaces
