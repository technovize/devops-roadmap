#!/usr/bin/env bash
set -euo pipefail

git checkout $COMMIT_SHA
pip install -r requirements.txt     # Python
npm ci                              # Node.js (clean install from lockfile)
bundle install                      # Ruby
mvn dependency:resolve              # Java/Maven
