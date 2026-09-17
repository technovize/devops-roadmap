# Generate realistic load for demo purposes
pip install locust

# locustfile.py
cat > locustfile.py << 'EOF'
from locust import HttpUser, task, between

class AppUser(HttpUser):
    wait_time = between(0.5, 2)

    @task(3)
    def view_home(self):
        self.client.get("/")

    @task(2)
    def api_health(self):
        self.client.get("/health")

    @task(1)
    def api_orders(self):
        self.client.post("/api/orders", json={"amount": 49.99})
EOF

# Run load test for 5 minutes
locust --headless -u 10 -r 2 -t 5m --host=https://staging.myapp.com

# This generates realistic Grafana graphs for portfolio screenshots
