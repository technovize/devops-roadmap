#!/usr/bin/env bash
set -euo pipefail

# Install
pip install semgrep

# Run with the default security ruleset
semgrep --config=auto app/

# Run with specific rulesets
semgrep --config=p/python app/
semgrep --config=p/django app/
semgrep --config=p/secrets app/

# Run and output SARIF for GitHub Security tab
semgrep --config=auto --sarif --output=semgrep.sarif app/

# Run only rules with HIGH severity
semgrep --config=auto --severity=ERROR app/
