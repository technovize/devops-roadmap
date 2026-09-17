#!/usr/bin/env bash
set -euo pipefail

# Install pre-commit
pip install pre-commit

# Create .pre-commit-config.yaml
cat > .pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/zricethezav/gitleaks
    rev: v8.18.2
    hooks:
      - id: gitleaks

  - repo: https://github.com/PyCQA/bandit
    rev: 1.7.7
    hooks:
      - id: bandit
        args: ['-ll', '-r', 'app/']

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: detect-private-key
      - id: check-yaml
      - id: no-commit-to-branch
        args: ['--branch', 'main']
EOF

# Install hooks
pre-commit install

# Test: try to commit a fake secret
echo 'AWS_SECRET_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"' >> test_secret.py
git add test_secret.py
git commit -m "test secret detection"
# Expected: gitleaks hook should BLOCK this commit

# Clean up
git checkout test_secret.py
git reset HEAD test_secret.py

# Run manually against all files
pre-commit run --all-files
