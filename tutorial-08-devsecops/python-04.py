# vulnerable_app.py — this file contains intentional vulnerabilities
# Exercise: find and fix ALL security issues

import subprocess
import yaml
import random
import sqlite3
import requests
from flask import Flask, request

app = Flask(__name__)
SECRET_KEY = "hardcoded-secret-key-12345"        # Issue 1
DB_PASSWORD = "admin123"                           # Issue 2

@app.route('/execute')
def execute_command():
    cmd = request.args.get('cmd')
    result = subprocess.check_output(cmd, shell=True)  # Issue 3
    return result

@app.route('/users')
def get_user():
    user_id = request.args.get('id')
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    # Issue 4: SQL injection
    cursor.execute(f"SELECT * FROM users WHERE id = {user_id}")
    return str(cursor.fetchall())

@app.route('/config')
def load_config():
    with open('config.yaml') as f:
        config = yaml.load(f)          # Issue 5
    return str(config)

@app.route('/token')
def generate_token():
    token = random.randint(100000, 999999)  # Issue 6
    return str(token)

@app.route('/data')
def fetch_data():
    url = request.args.get('url')
    resp = requests.get(url, verify=False)  # Issue 7
    return resp.text
