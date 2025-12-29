"""
local_orchestrator.py

Simulate Step Functions locally:
  1) start_glue_job_stub -> returns jobRunId
  2) run local ETL job (glue_jobs/bronze_to_silver/job.py)
  3) check_glue_job_status_stub <jobRunId> -> returns status
  4) publish SNS success/failure stub

Run:
  python src/scripts/local_orchestrator.py
"""
import subprocess
import json
import shlex
import sys
import os

ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", ".."))

def run_cmd(cmd):
    # run a command and return parsed JSON if possible, else raw output
    if isinstance(cmd, list):
        p = subprocess.run(cmd, capture_output=True, text=True)
    else:
        p = subprocess.run(shlex.split(cmd), capture_output=True, text=True)
    out = p.stdout.strip()
    err = p.stderr.strip()
    if p.returncode != 0:
        print(f"Command failed: {cmd}")
        print("STDERR:", err)
        raise SystemExit(1)
    try:
        return json.loads(out)
    except Exception:
        return out

def main():
    print("1) Starting Glue job (stub)...")
    start = run_cmd(["python", os.path.join(ROOT, "src","lambda","start_glue_job_stub.py")])
    print("start response:", start)
    jobRunId = start.get("jobRunId")
    if not jobRunId:
        print("No jobRunId returned, aborting.")
        sys.exit(1)

    print("\n2) Running local ETL job (bronze -> silver)...")
    etl_cmd = ["python", os.path.join(ROOT, "src","glue_jobs","bronze_to_silver","job.py")]
    etl_out = run_cmd(etl_cmd)
    print("ETL output (truncated):")
    if isinstance(etl_out, dict):
        print(json.dumps(etl_out, indent=2))
    else:
        # print first 1000 chars to avoid huge output
        print(str(etl_out)[:1000])

    print("\n3) Checking job status (stub)...")
    status = run_cmd(["python", os.path.join(ROOT,"src","lambda","check_glue_job_status_stub.py"), jobRunId])
    print("status response:", status)
    job_status = status.get("status","UNKNOWN")

    if job_status == "SUCCEEDED":
        print("\n4) Publishing success notification (stub)...")
        msg = f"Bronze->Silver job {jobRunId} succeeded"
        pub = run_cmd(["python", os.path.join(ROOT,"src","lambda","sns_success_stub.py"), "--message", msg, "--subject", "ETL Success"])
        print("publish response:", pub)
    else:
        print("\n4) Publishing failure notification (stub)...")
        msg = f"Bronze->Silver job {jobRunId} failed or is not succeeded: {job_status}"
        pub = run_cmd(["python", os.path.join(ROOT,"src","lambda","sns_failure_stub.py"), "--message", msg, "--subject", "ETL Failure"])
        print("publish response:", pub)

    print("\nLocal orchestration complete.")
    print("Final job status:", job_status)

if __name__ == '__main__':
    main()
