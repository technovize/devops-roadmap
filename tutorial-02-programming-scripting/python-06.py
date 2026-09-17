import boto3

ec2 = boto3.client("ec2", region_name="us-east-1")

def stop_instances_by_tag(tag_key, tag_value):
    """Stop all EC2 instances with a specific tag."""
    response = ec2.describe_instances(
        Filters=[
            {"Name": f"tag:{tag_key}", "Values": [tag_value]},
            {"Name": "instance-state-name", "Values": ["running"]}
        ]
    )

    instance_ids = []
    for reservation in response["Reservations"]:
        for instance in reservation["Instances"]:
            instance_ids.append(instance["InstanceId"])

    if instance_ids:
        ec2.stop_instances(InstanceIds=instance_ids)
        print(f"Stopping instances: {instance_ids}")
    else:
        print("No running instances found with that tag.")

# Stop all dev instances at end of workday
stop_instances_by_tag("Environment", "development")
