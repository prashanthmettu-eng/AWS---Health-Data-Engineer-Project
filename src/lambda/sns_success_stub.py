"""
sns_success_stub.py

Simulate publishing a success notification to SNS.
Usage:
  python src\lambda\sns_success_stub.py --topic arn:aws:sns:REGION:ACCOUNT:topic --message "Pipeline succeeded" --subject "Success"
Outputs JSON to stdout for testing.
"""
import json
import argparse
import time

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--topic", required=False, default="arn:aws:sns:REGION:ACCOUNT:health-pipeline-success")
    parser.add_argument("--message", required=False, default="Pipeline succeeded")
    parser.add_argument("--subject", required=False, default="Health ETL Pipeline Success")
    args = parser.parse_args()

    # simulate latency
    time.sleep(0.2)

    # simulated SNS publish response
    response = {
        "TopicArn": args.topic,
        "MessageId": f"msg-{int(time.time())}",
        "Subject": args.subject,
        "Message": args.message
    }
    print(json.dumps(response))
    
if __name__ == "__main__":
    main()
