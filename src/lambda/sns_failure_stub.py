"""
sns_failure_stub.py

Simulate publishing a failure notification to SNS.
Usage:
  python src\lambda\sns_failure_stub.py --topic arn:aws:sns:REGION:ACCOUNT:topic --message "Pipeline failed" --subject "Failure"
Outputs JSON to stdout for testing.
"""
import json
import argparse
import time

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--topic", required=False, default="arn:aws:sns:REGION:ACCOUNT:health-pipeline-failure")
    parser.add_argument("--message", required=False, default="Pipeline failed")
    parser.add_argument("--subject", required=False, default="Health ETL Pipeline Failure")
    args = parser.parse_args()

    # simulate latency
    time.sleep(0.2)

    response = {
        "TopicArn": args.topic,
        "MessageId": f"msg-{int(time.time())}",
        "Subject": args.subject,
        "Message": args.message
    }
    print(json.dumps(response))
    
if __name__ == "__main__":
    main()
