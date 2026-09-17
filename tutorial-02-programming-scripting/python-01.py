import os
import shutil
from pathlib import Path

# Create a directory
Path("/tmp/deployment").mkdir(parents=True, exist_ok=True)

# List files in a directory
for file in Path("/var/log/app").glob("*.log"):
    print(f"Found log file: {file}")

# Read a file
with open("config.yaml", "r") as f:
    content = f.read()

# Write a file
with open("deployment_report.txt", "w") as f:
    f.write(f"Deployment completed at {os.popen('date').read().strip()}\n")
