#!/usr/bin/env bash
set -euo pipefail

# Install Cilium as the Kubernetes CNI
helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium \
  --namespace kube-system \
  --set kubeProxyReplacement=true \  # Replace kube-proxy entirely with eBPF
  --set hubble.relay.enabled=true \  # Enable Hubble for network observability
  --set hubble.ui.enabled=true       # Enable Hubble UI dashboard
