import boto3  # pip install boto3

# Create an S3 client
s3 = boto3.client(
    "s3",
    region_name="us-east-1"
    # Credentials are read from environment variables or ~/.aws/credentials
)

# List all buckets
response = s3.list_buckets()
for bucket in response["Buckets"]:
    print(f"Bucket: {bucket['Name']} | Created: {bucket['CreationDate']}")

# Upload a file
s3.upload_file(
    Filename="deployment_report.txt",
    Bucket="my-devops-artifacts",
    Key="reports/2026/deployment_report.txt"
)
print("Report uploaded to S3.")
