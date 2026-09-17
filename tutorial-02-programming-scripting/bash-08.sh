#!/usr/bin/env bash
set -euo pipefail

# Initialize a new repository
git init

# Clone an existing repository
git clone https://github.com/your-org/devops-scripts.git

# Check the status of your working directory
git status

# Stage changes for commit
git add deploy.py
git add .  # Stage all changes

# Commit with a meaningful message
git commit -m "feat: add production deployment script with dry-run support"

# Push to the remote repository
git push origin main

# Pull the latest changes
git pull origin main
