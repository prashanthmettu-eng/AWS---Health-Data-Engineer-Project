"""
check_glue_job_status.py

Checks AWS Glue job run status.
"""

import boto3

glue = boto3.client("glue")

def lambda_handler(event, context):
    """
    Expected input:
    {
      "jobName": "glue-job-name",
      "jobRunId": "jr_xxx"
    }
    """

    job_name = event["jobName"]     # ✅ FIXED
    job_run_id = event["jobRunId"]

    response = glue.get_job_run(
        JobName=job_name,
        RunId=job_run_id,
        PredecessorsIncluded=False
    )

    status = response["JobRun"]["JobRunState"]

    return {
        "job_name": job_name,
        "jobRunId": job_run_id,
        "status": status
    }
