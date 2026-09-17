#!/usr/bin/env bash
set -euo pipefail

# Install the CLI tool
brew install kubeseal

# Create a Kubernetes Secret manifest
kubectl create secret generic my-app-secrets \
  --from-literal=db_password=securepassword \
  --dry-run=client -o yaml > secret.yaml

# Encrypt it with the cluster's public key
kubeseal --format yaml < secret.yaml > sealed-secret.yaml

# Now sealed-secret.yaml is safe to commit to Git
git add sealed-secret.yaml
git commit -m "Add encrypted production database secret"

# Apply to the cluster — the controller decrypts and creates the real Secret
kubectl apply -f sealed-secret.yaml
