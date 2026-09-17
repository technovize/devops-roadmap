#!/usr/bin/env bash
set -euo pipefail

# Check Cilium status
cilium status

# Check init container logs
kubectl logs -n kube-system ds/cilium -c clean-cilium-state

# Common cause: Previous CNI leaving stale state
# Fix: Recreate the nodes or manually clean up
kubectl delete pod -n kube-system -l k8s-app=cilium

# Check kernel version (eBPF requires Linux 4.9+)
uname -r
