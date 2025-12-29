#!/usr/bin/env python3
"""
generate_patients.py
generate_patients.py
Simple synthetic patient CSV generator for the Bronze layer.
Creates data/sample_raw/patients.csv with ~50 rows.
"""
import csv, uuid, random, datetime, os

# Output folder relative to this file: ../../data/sample_raw
out_dir = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", "..", "data", "sample_raw"))
os.makedirs(out_dir, exist_ok=True)
out_path = os.path.join(out_dir, "patients.csv")

fieldnames = ["patient_id", "first_name", "last_name", "dob", "gender", "zip"]
names = [("John","Doe"),("Jane","Smith"),("Alice","Wong"),("Bob","Patel"),("Carlos","Garcia"),("Fatima","Khan")]

with open(out_path, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    for i in range(1, 51):
        fn, ln = random.choice(names)
        dob = (datetime.date.today() - datetime.timedelta(days=random.randint(18*365,90*365))).isoformat()
        writer.writerow({
            "patient_id": str(uuid.uuid4()),
            "first_name": fn,
            "last_name": ln,
            "dob": dob,
            "gender": random.choice(["M","F","Other"]),
            "zip": f"{random.randint(10000,99999)}"
        })

print(f"Generated sample patients CSV at: {out_path}")
