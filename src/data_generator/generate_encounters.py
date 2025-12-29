"""
generate_encounters.py

Purpose:
- Generate realistic healthcare encounter data
- Each encounter links to an existing patient
- Output used as Bronze-layer raw data

Output:
- data/sample_raw/encounters.csv
"""

import csv
import uuid
import random
from datetime import datetime, timedelta
from pathlib import Path

# ---------- Config ----------
OUTPUT_PATH = Path("data/sample_raw/encounters.csv")
PATIENTS_PATH = Path("data/sample_raw/patients.csv")

DIAGNOSIS_CODES = [
    "E11.9",  # Type 2 diabetes
    "I10",    # Hypertension
    "J18.9",  # Pneumonia
    "N39.0",  # UTI
    "K21.9",  # GERD
]

# ---------- Helpers ----------
def random_date(start_year=2022, end_year=2025):
    start = datetime(start_year, 1, 1)
    end = datetime(end_year, 12, 31)
    delta = end - start
    return start + timedelta(days=random.randint(0, delta.days))

# ---------- Main ----------
def main():
    if not PATIENTS_PATH.exists():
        raise FileNotFoundError("patients.csv not found. Generate patients first.")

    # Read patient IDs
    with open(PATIENTS_PATH, newline="") as f:
        reader = csv.DictReader(f)
        patient_ids = [row["patient_id"] for row in reader]

    encounters = []

    for patient_id in patient_ids:
        num_encounters = random.randint(1, 5)

        for _ in range(num_encounters):
            admit_date = random_date()
            stay_days = random.randint(1, 14)
            discharge_date = admit_date + timedelta(days=stay_days)

            encounters.append({
                "encounter_id": str(uuid.uuid4()),
                "patient_id": patient_id,
                "provider_id": str(uuid.uuid4()),
                "diagnosis_code": random.choice(DIAGNOSIS_CODES),
                "admit_date": admit_date.date().isoformat(),
                "discharge_date": discharge_date.date().isoformat(),
                "total_cost": round(random.uniform(500, 15000), 2),
            })

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)

    with open(OUTPUT_PATH, "w", newline="") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=encounters[0].keys()
        )
        writer.writeheader()
        writer.writerows(encounters)

    print(f"Generated {len(encounters)} encounters → {OUTPUT_PATH}")

if __name__ == "__main__":
    main()
