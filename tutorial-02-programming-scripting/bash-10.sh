#!/bin/bash
set -euo pipefail

IMAGE="my-registry/my-app"
VERSION=${1:-"latest"}
CONTAINER_NAME="my-app"
HEALTH_URL="http://localhost:8080/health"

echo "=== Deployment: $IMAGE:$VERSION ==="

# Pull the new image
docker pull "$IMAGE:$VERSION"

# Store current version for rollback
CURRENT_VERSION=$(docker inspect --format='{{index .Config.Labels "version"}}' "$CONTAINER_NAME" 2>/dev/null || echo "none")

# Run the new container
echo "Starting new container..."
docker stop "$CONTAINER_NAME" 2>/dev/null || true
docker run -d --name "$CONTAINER_NAME" \
    --label "version=$VERSION" \
    -p 8080:8080 \
    --restart=unless-stopped \
    "$IMAGE:$VERSION"

# Wait for health check to pass
echo "Waiting for health check..."
for i in {1..30}; do
    if curl -sf "$HEALTH_URL" > /dev/null; then
        echo "(correct) Health check passed after ${i}s"
        echo "=== Deployment successful: $IMAGE:$VERSION ==="
        exit 0
    fi
    sleep 1
done

# Health check failed — rollback
echo "(incorrect) Health check failed. Rolling back to $CURRENT_VERSION..."
docker stop "$CONTAINER_NAME"
docker run -d --name "$CONTAINER_NAME" \
    -p 8080:8080 \
    --restart=unless-stopped \
    "$IMAGE:$CURRENT_VERSION"
echo "Rollback complete."
exit 1
