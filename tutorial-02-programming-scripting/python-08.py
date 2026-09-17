import requests
import json
from datetime import datetime

SERVICES = {
    "API": "https://api.yourapp.com/health",
    "Auth": "https://auth.yourapp.com/health",
    "Dashboard": "https://dashboard.yourapp.com/health",
}

results = []
for name, url in SERVICES.items():
    try:
        r = requests.get(url, timeout=5)
        results.append({
            "service": name,
            "status": "UP" if r.status_code == 200 else "DEGRADED",
            "response_time_ms": round(r.elapsed.total_seconds() * 1000),
            "status_code": r.status_code
        })
    except requests.exceptions.RequestException:
        results.append({"service": name, "status": "DOWN", "response_time_ms": None, "status_code": None})

print(json.dumps(results, indent=2))
