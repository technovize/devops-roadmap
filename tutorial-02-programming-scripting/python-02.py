import json
import yaml  # pip install pyyaml

# Parse a JSON API response
with open("deployment_status.json") as f:
    data = json.load(f)

print(f"Status: {data['status']}")
print(f"Version: {data['version']}")

# Parse a YAML config file
with open("config.yaml") as f:
    config = yaml.safe_load(f)

print(f"Database host: {config['database']['host']}")
print(f"Redis port: {config['redis']['port']}")

# Generate YAML output
output = {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {"name": "my-app", "namespace": "production"}
}
print(yaml.dump(output, default_flow_style=False))
