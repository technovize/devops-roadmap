#!/usr/bin/env bash
set -euo pipefail

# Update Kubernetes deployment with the new image
kubectl set image deployment/my-app \
  app=$REGISTRY/$IMAGE_NAME:$COMMIT_SHA \
  -n staging

# Wait for the rollout to complete
kubectl rollout status deployment/my-app -n staging --timeout=300s

# Run integration tests against staging
pytest tests/integration/ --base-url=https://staging.myapp.com
