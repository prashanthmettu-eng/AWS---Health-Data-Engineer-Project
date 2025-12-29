"""
check_glue_job_status_stub.py

Simulate checking Glue job status. Usage:
  python src\lambda\check_glue_job_status_stub.py <jobRunId>

Behavior:
 - If jobRunId's hex suffix parsed as int is even -> returns SUCCEEDED
 - If odd -> returns RUNNING (so you can see the state machine re-wait loop)
 - This is a simple deterministic simulation for local testing.
Outputs JSON like: {"jobRunId": "...", "status": "RUNNING"}
"""
import json
import sys

def main():
    if len(sys.argv) < 2:
        print(json.dumps({"error":"missing jobRunId"}))
        sys.exit(1)
    jobRunId = sys.argv[1]
    # extract last hex-ish part to decide parity
    parts = jobRunId.split("-")
    suffix = parts[-1] if len(parts) > 0 else jobRunId
    # sum char codes to get deterministic parity
    s = sum(ord(c) for c in suffix)
    status = "SUCCEEDED" if (s % 2 == 0) else "RUNNING"
    out = {"jobRunId": jobRunId, "status": status}
    print(json.dumps(out))

if __name__ == "__main__":
    main()
