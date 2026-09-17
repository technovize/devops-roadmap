import re
from collections import Counter
from pathlib import Path

LOG_DIR = Path("/var/log/myapp")
ERROR_PATTERN = re.compile(r"(ERROR|CRITICAL)\s+(.+)")

error_counts = Counter()

for log_file in LOG_DIR.glob("*.log"):
    with open(log_file) as f:
        for line in f:
            match = ERROR_PATTERN.search(line)
            if match:
                error_counts[match.group(2)[:80]] += 1  # Truncate long messages

print(f"Top errors in the last 24 hours:")
for message, count in error_counts.most_common(10):
    print(f"  [{count:4d}x] {message}")
