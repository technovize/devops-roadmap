# (no) B307: eval() used — arbitrary code execution risk
result = eval(user_input)

# (yes) Fix: Use ast.literal_eval for safe evaluation of literals only
import ast
result = ast.literal_eval(user_input)


# (no) B608: Hardcoded SQL — SQL injection risk
query = f"SELECT * FROM users WHERE email = '{email}'"
cursor.execute(query)

# (yes) Fix: Use parameterized queries
query = "SELECT * FROM users WHERE email = %s"
cursor.execute(query, (email,))


# (no) B311: random used for security — predictable values
import random
token = random.randint(100000, 999999)

# (yes) Fix: Use secrets module for cryptographically secure random values
import secrets
token = secrets.randbelow(900000) + 100000


# (no) B506: yaml.load without Loader — arbitrary code execution
import yaml
data = yaml.load(file)

# (yes) Fix: Use safe_load
data = yaml.safe_load(file)


# (no) B501: SSL certificate verification disabled
import requests
response = requests.get(url, verify=False)

# (yes) Fix: Always verify SSL certificates
response = requests.get(url, verify=True)


# (no) B105: Hardcoded password
password = "supersecret123"

# (yes) Fix: Read from environment variable
import os
password = os.environ["DB_PASSWORD"]
