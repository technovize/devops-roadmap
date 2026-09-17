#!/usr/bin/env bash
set -euo pipefail

# Common cause: PATH differences in CI environment
# Fix: Use full paths or explicitly set PATH
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

# Common cause: Script not executable
chmod +x deploy.sh

# Common cause: Windows line endings (CRLF) on a Linux system
# Fix:
sed -i 's/\r$//' deploy.sh
# Or: dos2unix deploy.sh
