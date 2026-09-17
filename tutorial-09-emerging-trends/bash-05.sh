#!/usr/bin/env bash
set -euo pipefail

# Monitor a rollout in progress
kubectl argo rollouts get rollout my-app -n production --watch

# Manually promote (skip a pause step)
kubectl argo rollouts promote my-app -n production

# Abort and rollback immediately
kubectl argo rollouts abort my-app -n production
