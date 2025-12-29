"""
start_glue_job.py

Starts an AWS Glue job.
Invoked by AWS Step Functions.
"""

import boto3

glue = boto3.client("glue")

def lambda_handler(event, context):
    """
    Expected input:
    {
      "jobName": "glue-job-name"
    }
    """

    job_name = event["jobName"]   # ✅ FIXED

    response = glue.start_job_run(
        JobName=job_name
    )

    return {
        "job_name": job_name,
        "jobRunId": response["JobRunId"]
    }
