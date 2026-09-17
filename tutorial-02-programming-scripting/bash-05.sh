#!/bin/bash

# Stop the script immediately if any command fails
set -e

# Stop on undefined variables
set -u

# Propagate errors through pipes
set -o pipefail

echo "Starting deployment..."

# If this fails, the script stops immediately (due to set -e)
docker build -t my-app:latest .

echo "Build successful. Pushing image..."
docker push my-app:latest

echo "Deployment complete."
