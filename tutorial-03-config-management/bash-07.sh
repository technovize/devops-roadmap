#!/usr/bin/env bash
set -euo pipefail

# Check: can you SSH manually?
ssh -i ~/.ssh/key.pem ubuntu@SERVER_IP

# Fix: Specify correct SSH key in inventory
web1 ansible_host=1.2.3.4 \
     ansible_user=ubuntu \
     ansible_ssh_private_key_file=~/.ssh/key.pem

# Fix: Disable host key checking for new hosts
export ANSIBLE_HOST_KEY_CHECKING=False
# Or in ansible.cfg:
echo "[defaults]
host_key_checking = False" > ansible.cfg
