# Example: Using the Anthropic API to review Terraform plans for security issues
# (this is the kind of AI-native DevOps tool being built today)

import anthropic
import json
import subprocess

def ai_review_terraform_plan(plan_file: str) -> dict:
    """
    Submit a Terraform plan to Claude for security and best-practice review.
    Returns structured findings with severity and remediation suggestions.
    """
    with open(plan_file) as f:
        plan_json = f.read()

    client = anthropic.Anthropic()

    response = client.messages.create(
        model="claude-sonnet-4-6",
        max_tokens=2048,
        messages=[{
            "role": "user",
            "content": f"""Review this Terraform plan for security issues,
            misconfigurations, and DevOps best practice violations.

            Return a JSON object with this structure:
            {{
              "risk_level": "low|medium|high|critical",
              "findings": [
                {{
                  "severity": "low|medium|high|critical",
                  "resource": "resource address",
                  "issue": "description of the problem",
                  "remediation": "how to fix it",
                  "cwe": "optional CWE reference"
                }}
              ],
              "summary": "one paragraph summary"
            }}

            Terraform Plan:
            {plan_json[:8000]}"""  # Truncate for token limits
        }]
    )

    return json.loads(response.content[0].text)


# Use in CI/CD pipeline
if __name__ == "__main__":
    subprocess.run(["terraform", "plan", "-out=tfplan"], check=True)
    subprocess.run(["terraform", "show", "-json", "tfplan"], check=True,
                   stdout=open("tfplan.json", "w"))

    findings = ai_review_terraform_plan("tfplan.json")

    print(f"Risk Level: {findings['risk_level'].upper()}")
    print(f"Summary: {findings['summary']}")

    for finding in findings['findings']:
        print(f"\n[{finding['severity'].upper()}] {finding['resource']}")
        print(f"  Issue: {finding['issue']}")
        print(f"  Fix: {finding['remediation']}")

    # Fail CI/CD on critical findings
    critical = [f for f in findings['findings'] if f['severity'] == 'critical']
    if critical:
        print(f"\n(no) {len(critical)} critical findings — blocking deployment")
        exit(1)
