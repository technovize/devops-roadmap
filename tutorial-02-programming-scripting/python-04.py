import os
from dotenv import load_dotenv  # pip install python-dotenv

# Load .env file for local development
load_dotenv()

# Read environment variables with defaults
DB_HOST = os.environ.get("DB_HOST", "localhost")
DB_PORT = int(os.environ.get("DB_PORT", "5432"))
DB_PASSWORD = os.environ.get("DB_PASSWORD")  # No default — must be set

if not DB_PASSWORD:
    raise ValueError("DB_PASSWORD environment variable is required but not set.")

print(f"Connecting to database at {DB_HOST}:{DB_PORT}")
