#!/bin/bash
# deploy.sh — write this script from scratch following the requirements below

# REQUIREMENTS:
# 1. Accept --image and --tag arguments
# 2. Pull the specified Docker image
# 3. Stop any existing container with the same name
# 4. Start the new container on port 8080
# 5. Poll /health for up to 30 seconds
# 6. Roll back to the previous image if health check fails
# 7. Log all actions with timestamps
# 8. Exit with code 0 on success, 1 on failure

# STARTER STRUCTURE — complete the missing parts:
set -euo pipefail

IMAGE=""
TAG=""
CONTAINER_NAME="myapp"
HEALTH_URL="http://localhost:8080/health"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

parse_args() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      --image) IMAGE="$2"; shift 2 ;;
      --tag)   TAG="$2";   shift 2 ;;
      *) echo "Unknown argument: $1"; exit 1 ;;
    esac
  done
  [[ -z "$IMAGE" || -z "$TAG" ]] && { echo "Usage: $0 --image IMAGE --tag TAG"; exit 1; }
}

wait_healthy() {
  # TODO: implement 30-second polling loop
  # Return 0 if healthy, 1 if timeout
  :
}

main() {
  parse_args "$@"
  # TODO: implement pull, stop old, start new, health check, rollback
  :
}

main "$@"
