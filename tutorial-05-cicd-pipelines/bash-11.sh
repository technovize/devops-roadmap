#!/usr/bin/env bash
set -euo pipefail

Steps in the GitHub UI:
1. Go to your repository -> Settings -> Branches
2. Click "Add rule" under "Branch protection rules"
3. Branch name pattern: main
4. Enable:
   (yes) Require a pull request before merging
   (yes) Require approvals: 1
   (yes) Require status checks to pass before merging
      -> Add status check: "test" (the job name from your workflow)
   (yes) Require branches to be up to date before merging
   (yes) Do not allow bypassing the above settings
5. Click "Save changes"

Verify: Try to push directly to main
git checkout main
echo "test" >> README.md
git add . && git commit -m "test direct push"
git push origin main
# Expected: "remote: error: GH006: Protected branch update failed"
