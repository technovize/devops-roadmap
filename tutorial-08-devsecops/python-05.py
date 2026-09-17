import subprocess
import yaml
import secrets
import sqlite3
import requests
import os
from flask import Flask, request
from shlex import quote

app = Flask(__name__)
SECRET_KEY = os.environ["SECRET_KEY"]           # Fix 1: env var
DB_PASSWORD = os.environ["DB_PASSWORD"]         # Fix 2: env var

ALLOWED_COMMANDS = {"ls", "pwd", "whoami"}      # Fix 3: whitelist

@app.route('/execute')
def execute_command():
    cmd = request.args.get('cmd', '')
    if cmd not in ALLOWED_COMMANDS:
        return "Command not allowed", 403
    result = subprocess.check_output([cmd], shell=False)  # Fix 3: no shell
    return result

@app.route('/users')
def get_user():
    user_id = request.args.get('id')
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))  # Fix 4
    return str(cursor.fetchall())

@app.route('/config')
def load_config():
    with open('config.yaml') as f:
        config = yaml.safe_load(f)          # Fix 5: safe_load
    return str(config)

@app.route('/token')
def generate_token():
    token = secrets.randbelow(900000) + 100000  # Fix 6: secrets module
    return str(token)

@app.route('/data')
def fetch_data():
    url = request.args.get('url', '')
    resp = requests.get(url, verify=True)   # Fix 7: verify SSL
    return resp.text
