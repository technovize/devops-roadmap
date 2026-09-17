#!/usr/bin/env bash
set -euo pipefail

# Step 1: Describe the pod for events
kubectl describe pod <pod-name> -n <namespace>

# Step 2: Get logs from the crashed container
kubectl logs <pod-name> -n <namespace> --previous

# Step 3: Common causes:
# - Missing environment variable -> check ConfigMap/Secret
kubectl get configmap -n <namespace>
kubectl get secret -n <namespace>

# - Failed liveness probe -> increase initialDelaySeconds
# - Wrong image tag -> check image pull status
kubectl describe pod <pod-name> | grep -A5 "Events:"

# - OOMKilled (out of memory) -> increase memory limit
kubectl describe pod <pod-name> | grep -i "OOM\|killed\|memory"
