#!/usr/bin/env python3
"""
deploy.py — Automated deployment script for Technovize apps
Usage: python3 deploy.py --env staging --version 1.2.3 --dry-run
"""
import argparse
import subprocess
import sys

def parse_args():
    parser = argparse.ArgumentParser(description="Deploy an application.")
    parser.add_argument("--env", required=True, choices=["staging", "production"],
                        help="Deployment environment")
    parser.add_argument("--version", required=True,
                        help="Docker image version tag to deploy")
    parser.add_argument("--dry-run", action="store_true",
                        help="Print commands without executing them")
    return parser.parse_args()

def run_command(cmd, dry_run=False):
    print(f"$ {cmd}")
    if not dry_run:
        result = subprocess.run(cmd, shell=True, check=True, text=True)
        return result.returncode
    return 0

def main():
    args = parse_args()

    print(f"Deploying version {args.version} to {args.env}...")

    run_command(f"docker pull my-registry/my-app:{args.version}", args.dry_run)
    run_command(f"kubectl set image deployment/my-app app=my-registry/my-app:{args.version} -n {args.env}", args.dry_run)
    run_command(f"kubectl rollout status deployment/my-app -n {args.env}", args.dry_run)

    print("Deployment complete.")

if __name__ == "__main__":
    main()
