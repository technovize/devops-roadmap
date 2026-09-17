import boto3
import json
from functools import lru_cache

@lru_cache(maxsize=None)
def get_secret(secret_name: str, region: str = "us-east-1") -> dict:
    """
    Retrieve a secret from AWS Secrets Manager.
    Cached after first retrieval — restart the app to pick up rotated secrets.
    """
    client = boto3.client("secretsmanager", region_name=region)

    try:
        response = client.get_secret_value(SecretId=secret_name)
        secret = response.get("SecretString") or \
                 base64.b64decode(response["SecretBinary"]).decode("utf-8")
        return json.loads(secret)

    except client.exceptions.ResourceNotFoundException:
        raise ValueError(f"Secret '{secret_name}' not found in Secrets Manager.")
    except client.exceptions.AccessDeniedException:
        raise PermissionError(f"Access denied to secret '{secret_name}'.")


# Usage in application code
db_secret = get_secret("myapp/production/database")

DATABASE_URL = (
    f"postgres://{db_secret['username']}:{db_secret['password']}"
    f"@{db_secret['host']}:{db_secret['port']}/{db_secret['dbname']}"
)
