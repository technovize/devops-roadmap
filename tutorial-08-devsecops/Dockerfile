# Dockerfile — Security-hardened multi-stage build

# -- Stage 1: Builder --------------------------------------------------------
FROM python:3.12-slim AS builder

WORKDIR /build

# Install only what's needed — no build tools in final image
RUN pip install --upgrade pip==24.0

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# -- Stage 2: Production -----------------------------------------------------
# Use distroless — no shell, no package manager, minimal attack surface
FROM gcr.io/distroless/python3-debian12 AS production

# Never run as root
USER nonroot:nonroot

WORKDIR /app

# Copy only the installed packages from builder
COPY --from=builder --chown=nonroot:nonroot /install/lib /usr/local/lib

# Copy application code
COPY --chown=nonroot:nonroot app/ .

# No SHELL means no shell injection. No curl means no data exfiltration.
# No apt means no package installation inside the container.

EXPOSE 8000

# Use exec form (not shell form) to ensure signals are properly received
CMD ["python", "-m", "gunicorn", "config.wsgi:application",
     "--bind", "0.0.0.0:8000", "--workers", "4"]
