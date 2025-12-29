"""
sns_notify_success.py
Real Lambda handler for sending SNS success notifications.

Later:
  sns.publish(TopicArn=..., Message=..., Subject=...)
"""

import json

def lambda_handler(event, context):
    # In production, event will contain jobRunId or pipeline metadata
    message = f"Pipeline succeeded. Details: {json.dumps(event)}"

    return {
        "message": message,
        "status": "SUCCESS"
    }
