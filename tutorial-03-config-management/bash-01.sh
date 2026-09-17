#!/usr/bin/env bash
set -euo pipefail

# On Ubuntu/Debian
sudo apt update && sudo apt install -y ansible

# On macOS with Homebrew
brew install ansible

# With pip (any platform)
pip install ansible

# Verify installation
ansible --version
