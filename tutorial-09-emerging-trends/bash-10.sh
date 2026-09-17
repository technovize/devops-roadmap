#!/usr/bin/env bash
set -euo pipefail

# Check rollout status
kubectl argo rollouts get rollout myapp --watch

# Common cause: Pause step without a duration (requires manual promotion)
# Rollout is paused waiting for: kubectl argo rollouts promote myapp

# Common cause: AnalysisRun failing
kubectl get analysisrun -l rollout.argoproj.io/rollout=myapp
kubectl describe analysisrun myapp-abc123

# Check analysis metrics
kubectl argo rollouts get rollout myapp --watch
# Look for: AnalysisRun "Degraded" or "Failed"

# Abort a failed rollout
kubectl argo rollouts abort myapp
