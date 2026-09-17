#!/usr/bin/env bash
set -euo pipefail

# Start all services (detached)
docker compose up -d

# Start and rebuild images
docker compose up -d --build

# View logs for all services
docker compose logs -f

# View logs for a specific service
docker compose logs -f web

# Run a one-off command in a service container
docker compose exec web python manage.py migrate
docker compose exec web python manage.py createsuperuser

# Scale a service (run 3 instances of the web container)
docker compose up -d --scale web=3

# Stop all services
docker compose down

# Stop and remove volumes (wipes database data)
docker compose down -v
