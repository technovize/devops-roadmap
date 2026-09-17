#!/usr/bin/env bash
set -euo pipefail

# Install Hubble CLI
export HUBBLE_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/hubble/master/stable.txt)
brew install hubble

# Port-forward Hubble relay
cilium hubble port-forward &

# Observe all traffic to the payment service
hubble observe --namespace production --to-label app=payment-service

# Observe dropped packets (denied by network policy)
hubble observe --verdict DROPPED --namespace production

# Observe DNS queries from a specific pod
hubble observe --namespace production \
  --from-pod production/my-app-abc123 \
  --protocol DNS
