#!/usr/bin/env bash
set -euo pipefail

# (no) NEVER: Hardcode in source code
DB_PASSWORD = "supersecret123"

# (no) NEVER: Commit to Git (even in private repos — repos get leaked, forked, shared)
echo "DB_PASSWORD=supersecret123" >> config.py
git add config.py && git commit -m "add config"

# (no) NEVER: Store in Docker images
ENV DB_PASSWORD=supersecret123

# (no) NEVER: Print in logs
print(f"Connecting with password: {DB_PASSWORD}")

# (no) NEVER: Pass as command-line arguments (visible in process list)
python app.py --db-password=supersecret123
