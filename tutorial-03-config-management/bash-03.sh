#!/usr/bin/env bash
set -euo pipefail

ansible-playbook -i inventory/hosts.ini playbooks/setup_webserver.yml

# Dry run (check mode) — shows what would change without making changes
ansible-playbook -i inventory/hosts.ini playbooks/setup_webserver.yml --check

# Run only on a specific subset of hosts
ansible-playbook -i inventory/hosts.ini playbooks/setup_webserver.yml --limit web-01.myapp.com
