#!/usr/bin/env bash
set -euo pipefail

# Create a sample Django project structure
mkdir django-docker && cd django-docker
python3 -m venv venv && source venv/bin/activate
pip install django gunicorn

django-admin startproject config .
python manage.py startapp api

# requirements.txt
cat > requirements.txt << 'EOF'
django==5.0.4
gunicorn==21.2.0
psycopg2-binary==2.9.9
EOF

# Write the Dockerfile from these requirements:
# 1. Use python:3.12-slim as base
# 2. Create a non-root user named 'appuser'
# 3. Set PYTHONUNBUFFERED=1 and PYTHONDONTWRITEBYTECODE=1
# 4. Copy requirements.txt BEFORE copying application code
# 5. Install with --no-cache-dir
# 6. Copy application code
# 7. Switch to non-root user
# 8. Expose port 8000
# 9. Add HEALTHCHECK
# 10. CMD runs gunicorn with 4 workers
