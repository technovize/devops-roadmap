#!/usr/bin/env bash
set -euo pipefail

# Install Vault
brew install vault

# Start a development server (not for production)
vault server -dev

# Authenticate
export VAULT_ADDR="https://vault.myapp.com"
vault login -method=oidc

# Store a secret
vault kv put secret/myapp/production \
  db_password="securepassword" \
  api_key="sk_live_abc123"

# Read a secret
vault kv get secret/myapp/production
vault kv get -field=db_password secret/myapp/production

# Dynamic database credentials — Vault creates a temporary DB user on demand
vault read database/creds/myapp-production-role

# The credential is automatically revoked after the lease duration expires
