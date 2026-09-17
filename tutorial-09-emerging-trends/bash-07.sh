#!/usr/bin/env bash
set -euo pipefail

# Install Linkerd CLI
brew install linkerd

# Validate cluster compatibility
linkerd check --pre

# Install Linkerd control plane
linkerd install --crds | kubectl apply -f -
linkerd install | kubectl apply -f -

# Verify installation
linkerd check

# Inject Linkerd proxy into a deployment
kubectl get deploy -n production -o yaml | \
  linkerd inject - | \
  kubectl apply -f -

# Real-time traffic stats
linkerd viz stat deploy -n production

# Live tap — inspect actual request/response data
linkerd viz tap deploy/my-app -n production \
  --to deploy/payment-service

# Service topology map
linkerd viz edges pod -n production
