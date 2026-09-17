#!/usr/bin/env bash
set -euo pipefail

# Diagnose
docker run --rm my-app:latest     # See the error output
docker logs <container-id>        # Check logs from a stopped container

# Common causes and fixes:
# 1. CMD uses shell form and shell exits
# Bad:  CMD "python app.py"
# Good: CMD ["python", "app.py"]

# 2. Application crashes on startup — check environment variables
docker run --rm -e DATABASE_URL=postgres://... my-app:latest

# 3. Port conflict
docker run --rm -p 8081:8000 my-app:latest  # Use a different host port
