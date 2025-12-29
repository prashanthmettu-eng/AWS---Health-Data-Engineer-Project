"""
sns_notify_failure.py
Real Lambda handler for failure notifications.
"""

import json

def lambda_handler(event, context):
    message = f"Pipeline FAILED. Details: {json.dumps(event)}"

    return {
        "message": message,
        "status": "FAILURE"
    }
