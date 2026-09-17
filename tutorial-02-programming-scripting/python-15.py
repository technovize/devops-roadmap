#!/usr/bin/env python3
"""
log_analyzer.py — parse logs and alert on high error rates
Usage: python3 log_analyzer.py --log-file app.log --threshold 10 --webhook WEBHOOK_URL
"""
import argparse
import re
import json
import urllib.request
from collections import Counter
from pathlib import Path

ERROR_PATTERN = re.compile(r'(\d{4}-\d{2}-\d{2}T\S+)\s+(ERROR|CRITICAL)\s+(.+)')

def parse_logs(log_file: str) -> list:
    errors = []
    with open(log_file) as f:
        for line in f:
            match = ERROR_PATTERN.search(line)
            if match:
                errors.append({
                    "timestamp": match.group(1),
                    "level":     match.group(2),
                    "message":   match.group(3)[:100]
                })
    return errors

def send_slack_alert(webhook_url: str, error_count: int, top_errors: list):
    payload = {
        "text": f":rotating_light: *High Error Rate Detected*",
        "attachments": [{
            "color": "danger",
            "fields": [
                {"title": "Total Errors", "value": str(error_count), "short": True},
                {"title": "Top Error", "value": top_errors[0][0] if top_errors else "N/A", "short": False}
            ]
        }]
    }
    data = json.dumps(payload).encode()
    req = urllib.request.Request(webhook_url, data=data,
                                  headers={"Content-Type": "application/json"})
    urllib.request.urlopen(req)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--log-file",  required=True)
    parser.add_argument("--threshold", type=int, default=10)
    parser.add_argument("--webhook",   default="")
    args = parser.parse_args()

    errors = parse_logs(args.log_file)
    counter = Counter(e["message"] for e in errors)
    top_errors = counter.most_common(5)

    print(f"Total errors: {len(errors)}")
    for msg, count in top_errors:
        print(f"  [{count:4d}x] {msg}")

    if len(errors) >= args.threshold and args.webhook:
        send_slack_alert(args.webhook, len(errors), top_errors)
        print(f"Alert sent to Slack (threshold: {args.threshold})")

if __name__ == "__main__":
    main()
