#!/usr/bin/env bash
set -euo pipefail

docker push $REGISTRY/$IMAGE_NAME:$COMMIT_SHA
docker push $REGISTRY/$IMAGE_NAME:latest
