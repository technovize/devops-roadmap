#!/usr/bin/env bash
set -euo pipefail

# Install Ansible
pip install ansible

# Create a simple inventory file
cat > inventory.ini << 'EOF'
[webservers]
web1 ansible_host=YOUR_SERVER_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/key.pem

[local]
localhost ansible_connection=local
EOF

# Test connectivity
ansible all -i inventory.ini -m ping

# Run ad-hoc commands
ansible webservers -i inventory.ini -m command -a "uname -a"
ansible webservers -i inventory.ini -m command -a "df -h"
ansible webservers -i inventory.ini -b -m apt -a "name=nginx state=present update_cache=yes"
ansible webservers -i inventory.ini -b -m service -a "name=nginx state=started enabled=yes"

# Gather facts about managed hosts
ansible webservers -i inventory.ini -m setup | grep -E "ansible_os|ansible_mem|ansible_processor_count"

# Check if a file exists
ansible webservers -i inventory.ini -m stat -a "path=/etc/nginx/nginx.conf"
