#!/usr/bin/env bash
set -euo pipefail

# Create the Helm chart skeleton
helm create django-app
cd django-app

# Explore the structure:
# Chart.yaml     — chart metadata
# values.yaml    — default configuration values
# templates/     — Kubernetes manifest templates

# Customize values.yaml
cat > values.yaml << 'EOF'
replicaCount: 2

image:
  repository: django-app
  tag: local
  pullPolicy: Never

service:
  type: ClusterIP
  port: 80
  targetPort: 8000

resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 256Mi

env:
  DEBUG: "False"
  DATABASE_URL: ""

autoscaling:
  enabled: false
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70
EOF

# Lint the chart
helm lint .

# Dry-run to see what manifests will be generated
helm install django-app . --dry-run --debug

# Install
helm install django-app . -n app --create-namespace

# Upgrade with custom values
helm upgrade django-app . -n app \
  --set replicaCount=4 \
  --set image.tag=v2

# Check release history
helm history django-app -n app

# Rollback to revision 1
helm rollback django-app 1 -n app

# Uninstall
helm uninstall django-app -n app
