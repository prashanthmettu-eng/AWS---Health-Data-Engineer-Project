"""
start_glue_job_stub.py

Simulate starting a Glue job. Usage:
  python src\lambda\start_glue_job_stub.py

Outputs JSON with a fake jobRunId, e.g.:
{"jobRunId": "job-1702284123-42"}
"""
import json
import time
import uuid

def main():
    # create a deterministic-ish jobRunId using timestamp + uuid4 short
    ts = int(time.time())
    short = uuid.uuid4().hex[:6]
    job_run_id = f"job-{ts}-{short}"
    out = {"jobRunId": job_run_id}
    print(json.dumps(out))

if __name__ == "__main__":
    main()
