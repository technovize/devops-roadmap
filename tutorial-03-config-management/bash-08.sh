#!/usr/bin/env bash
set -euo pipefail

# Check: Are you using the correct vault password?
ansible-vault view secrets.yml --ask-vault-pass

# Check: Is the vault password file correct?
cat .vault_pass

# Fix: Re-encrypt with the correct password
ansible-vault rekey secrets.yml \
  --vault-password-file old-pass.txt \
  --new-vault-password-file new-pass.txt
