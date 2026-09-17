#!/usr/bin/env bash
set -euo pipefail

# Create and switch to a new branch
git checkout -b feature/add-backup-script

# Work on your changes...

# Push the branch to the remote
git push origin feature/add-backup-script

# After code review, merge via pull request (on GitHub/GitLab)
# Then clean up locally
git checkout main
git pull origin main
git branch -d feature/add-backup-script
