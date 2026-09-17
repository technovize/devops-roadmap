pip install awsebcli

mkdir paas-demo && cd paas-demo

cat > application.py << 'EOF'
from flask import Flask
application = Flask(__name__)

@application.route('/')
def hello():
    return '<h1>PaaS Demo</h1><p>No OS management required!</p>'
EOF

echo "flask==3.0.0" > requirements.txt

eb init paas-demo --platform python-3.11 --region us-east-1
eb create paas-demo-env
eb open

# Clean up
eb terminate paas-demo-env
