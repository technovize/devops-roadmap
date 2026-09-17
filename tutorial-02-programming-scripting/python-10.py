import boto3
import csv
from datetime import datetime, timezone

ec2 = boto3.client("ec2", region_name="us-east-1")

response = ec2.describe_instances(
    Filters=[{"Name": "instance-state-name", "Values": ["running"]}]
)

instances = []
for reservation in response["Reservations"]:
    for instance in reservation["Instances"]:
        name = next(
            (tag["Value"] for tag in instance.get("Tags", []) if tag["Key"] == "Name"),
            "Unnamed"
        )
        instances.append({
            "Name": name,
            "InstanceId": instance["InstanceId"],
            "InstanceType": instance["InstanceType"],
            "LaunchTime": instance["LaunchTime"].strftime("%Y-%m-%d %H:%M:%S"),
            "PrivateIP": instance.get("PrivateIpAddress", "N/A"),
        })

# Write to CSV
with open("ec2_inventory.csv", "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=instances[0].keys())
    writer.writeheader()
    writer.writerows(instances)

print(f"Exported {len(instances)} running instances to ec2_inventory.csv")
