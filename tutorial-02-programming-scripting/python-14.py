#!/usr/bin/env python3
import argparse
import csv
import boto3
from datetime import datetime, timezone

def parse_args():
    parser = argparse.ArgumentParser(description="EC2 Inventory Report")
    parser.add_argument("--region", default="us-east-1", help="AWS region")
    parser.add_argument("--output", default="ec2_inventory.csv", help="Output CSV path")
    parser.add_argument("--state", default="running",
                        choices=["running","stopped","all"], help="Instance state filter")
    return parser.parse_args()

def get_instances(region, state="running"):
    ec2 = boto3.client("ec2", region_name=region)
    filters = [] if state == "all" else \
              [{"Name": "instance-state-name", "Values": [state]}]
    response = ec2.describe_instances(Filters=filters)
    instances = []
    for reservation in response["Reservations"]:
        for inst in reservation["Instances"]:
            name = next(
                (t["Value"] for t in inst.get("Tags", []) if t["Key"] == "Name"),
                "Unnamed"
            )
            age_days = (datetime.now(timezone.utc) - inst["LaunchTime"]).days
            instances.append({
                "Name":         name,
                "InstanceId":   inst["InstanceId"],
                "InstanceType": inst["InstanceType"],
                "State":        inst["State"]["Name"],
                "PrivateIP":    inst.get("PrivateIpAddress", "N/A"),
                "PublicIP":     inst.get("PublicIpAddress", "N/A"),
                "LaunchTime":   inst["LaunchTime"].strftime("%Y-%m-%d %H:%M:%S"),
                "AgeDays":      age_days,
            })
    return instances

def export_csv(instances, output_path):
    if not instances:
        print("No instances found.")
        return
    with open(output_path, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=instances[0].keys())
        writer.writeheader()
        writer.writerows(instances)

def main():
    args = parse_args()
    instances = get_instances(args.region, args.state)
    export_csv(instances, args.output)
    print(f"\nEC2 Inventory — {args.region}")
    print(f"{'='*50}")
    print(f"Total instances: {len(instances)}")
    for inst in instances:
        print(f"  [{inst['State'].upper():8}] {inst['Name']:20} {inst['InstanceType']:15} {inst['PrivateIP']}")
    print(f"\nReport saved to: {args.output}")

if __name__ == "__main__":
    main()
