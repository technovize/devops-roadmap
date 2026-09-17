#!/usr/bin/env bash
set -euo pipefail

ansible all -i inventory/hosts.ini -m ping
