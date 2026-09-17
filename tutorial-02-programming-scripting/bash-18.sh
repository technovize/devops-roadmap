#!/usr/bin/env bash
set -euo pipefail

# If you accidentally staged a secret
git reset HEAD .env          # Unstage the file
echo ".env" >> .gitignore   # Add to gitignore
git rm --cached .env         # Remove from tracking if already tracked

# If already committed (ROTATE THE CREDENTIAL IMMEDIATELY)
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch .env' \
  --prune-empty --tag-name-filter cat -- --all
git push origin --force --all
# Note: This rewrites history. All collaborators must re-clone.
