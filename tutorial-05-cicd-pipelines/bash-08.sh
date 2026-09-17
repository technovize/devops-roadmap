#!/usr/bin/env bash
set -euo pipefail

kubectl set image deployment/my-app \
  app=$REGISTRY/$IMAGE_NAME:$COMMIT_SHA \
  -n production

kubectl rollout status deployment/my-app -n production --timeout=300s
