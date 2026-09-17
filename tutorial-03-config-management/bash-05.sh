#!/usr/bin/env bash
set -euo pipefail

# Test connectivity
ansible all -m ping

# Dry run first
ansible-playbook playbooks/setup_server.yml --check

# Apply
ansible-playbook playbooks/setup_server.yml

# Apply with verbose output for debugging
ansible-playbook playbooks/setup_server.yml -vvv
