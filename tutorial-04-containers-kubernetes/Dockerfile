# -- Stage: Base -----------------------------------------
# Use an official slim image — not 'latest', always pin a version
FROM python:3.12-slim

# Set working directory inside the container
WORKDIR /app

# -- Stage: Dependencies ---------------------------------
# Copy requirements FIRST — Docker caches this layer
# If requirements.txt hasn't changed, this layer is reused (fast rebuilds)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# -- Stage: Application ---------------------------------
# Copy application code (changes frequently — put it last)
COPY . .

# Create a non-root user for security
RUN useradd --create-home --shell /bin/bash appuser
USER appuser

# Document which port the app uses (informational — doesn't publish it)
EXPOSE 8000

# Health check — Docker will run this to verify the container is healthy
HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# The command to run when the container starts
CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
