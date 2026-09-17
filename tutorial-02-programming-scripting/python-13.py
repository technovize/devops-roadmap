#!/usr/bin/env python3
"""
ec2_inventory.py
Requirements:
- Accept --region and --output arguments
- List all running EC2 instances
- Export: Name, InstanceId, InstanceType, PrivateIP, PublicIP, LaunchTime, State
- Save as CSV to --output path
- Print a summary to stdout
"""
import argparse
import csv
import boto3
from datetime import datetime

def parse_args():
    # TODO: implement argument parsing
    pass

def get_instances(region):
    # TODO: implement EC2 instance listing with boto3
    pass

def export_csv(instances, output_path):
    # TODO: implement CSV export
    pass

def main():
    args = parse_args()
    instances = get_instances(args.region)
    export_csv(instances, args.output)
    print(f"Exported {len(instances)} instances to {args.output}")

if __name__ == "__main__":
    main()
