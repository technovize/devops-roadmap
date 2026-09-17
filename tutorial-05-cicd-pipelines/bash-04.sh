#!/usr/bin/env bash
set -euo pipefail

# Build and tag a Docker image with the commit SHA
docker build \
  --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --build-arg VCS_REF=$COMMIT_SHA \
  -t $REGISTRY/$IMAGE_NAME:$COMMIT_SHA \
  -t $REGISTRY/$IMAGE_NAME:latest \
  .
