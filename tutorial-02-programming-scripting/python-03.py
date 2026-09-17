import requests  # pip install requests

# Call a health check endpoint
def check_health(url):
    try:
        response = requests.get(url, timeout=5)
        if response.status_code == 200:
            print(f"(correct) {url} is healthy")
            return True
        else:
            print(f"(incorrect) {url} returned {response.status_code}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"(incorrect) {url} is unreachable: {e}")
        return False

services = [
    "http://api.myapp.com/health",
    "http://auth.myapp.com/health",
    "http://worker.myapp.com/health",
]

results = [check_health(url) for url in services]

if not all(results):
    print("Some services are unhealthy. Aborting deployment.")
    exit(1)

print("All services healthy. Proceeding with deployment.")
