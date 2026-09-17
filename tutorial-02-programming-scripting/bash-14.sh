#!/bin/bash
set -euo pipefail

IMAGE=""
TAG=""
CONTAINER_NAME="myapp"
HEALTH_URL="http://localhost:8080/health"
PREVIOUS_TAG=""

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

parse_args() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      --image) IMAGE="$2"; shift 2 ;;
      --tag)   TAG="$2";   shift 2 ;;
      *) echo "Unknown: $1"; exit 1 ;;
    esac
  done
  [[ -z "$IMAGE" || -z "$TAG" ]] && { echo "Usage: $0 --image IMAGE --tag TAG"; exit 1; }
}

wait_healthy() {
  log "Waiting for health check at $HEALTH_URL..."
  for i in $(seq 1 30); do
    if curl -sf "$HEALTH_URL" > /dev/null 2>&1; then
      log "Health check passed after ${i}s"
      return 0
    fi
    sleep 1
  done
  log "Health check timed out after 30s"
  return 1
}

rollback() {
  if [[ -n "$PREVIOUS_TAG" ]]; then
    log "Rolling back to $IMAGE:$PREVIOUS_TAG"
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    docker run -d --name "$CONTAINER_NAME" \
      -p 8080:8000 --restart=unless-stopped \
      "$IMAGE:$PREVIOUS_TAG"
    log "Rollback complete"
  else
    log "No previous version to roll back to"
  fi
}

main() {
  parse_args "$@"

  PREVIOUS_TAG=$(docker inspect --format='{{index .Config.Labels "version"}}' \
    "$CONTAINER_NAME" 2>/dev/null || echo "")

  log "Pulling $IMAGE:$TAG"
  docker pull "$IMAGE:$TAG"

  log "Stopping existing container"
  docker stop "$CONTAINER_NAME" 2>/dev/null || true
  docker rm "$CONTAINER_NAME" 2>/dev/null || true

  log "Starting $IMAGE:$TAG"
  docker run -d --name "$CONTAINER_NAME" \
    --label "version=$TAG" \
    -p 8080:8000 --restart=unless-stopped \
    "$IMAGE:$TAG"

  if wait_healthy; then
    log "Deployment successful: $IMAGE:$TAG"
    exit 0
  else
    log "Deployment failed — rolling back"
    rollback
    exit 1
  fi
}

main "$@"
