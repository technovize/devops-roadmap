#!/usr/bin/env bash
set -euo pipefail

# -- Images ----------------------------------------------

# Pull an image from Docker Hub
docker pull python:3.12-slim

# List local images
docker images

# Remove an image
docker rmi python:3.12-slim

# Build an image from a Dockerfile in the current directory
docker build -t my-app:1.0.0 .

# Tag an image for a registry
docker tag my-app:1.0.0 myregistry.azurecr.io/my-app:1.0.0

# Push an image to a registry
docker push myregistry.azurecr.io/my-app:1.0.0


# -- Containers ------------------------------------------

# Run a container (foreground)
docker run python:3.12-slim python --version

# Run a container in the background (detached)
docker run -d --name my-app -p 8080:8000 my-app:1.0.0

# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# View container logs
docker logs my-app
docker logs -f my-app        # Follow (tail) logs in real time

# Execute a command inside a running container
docker exec -it my-app bash  # Open an interactive shell

# Stop and remove a container
docker stop my-app
docker rm my-app

# Stop and remove in one command
docker rm -f my-app


# -- System ----------------------------------------------

# Remove all stopped containers, unused images, and build cache
docker system prune -a

# Show disk usage
docker system df
