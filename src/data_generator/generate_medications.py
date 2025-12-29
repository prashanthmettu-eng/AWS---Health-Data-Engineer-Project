"""
generate_medications.py

Purpose:
Generate realistic medication administration data
linked to encounters and patients.

Output:
data/sample_raw/medications.csv
"""

import csv
import uuid
import random
from datetime import timedelta
from pathlib import Path
import pandas as pd

# ----------------------------
# Paths
# ----------------------------
BASE_DIR = Path(__file__).resolve().parents[2]
DATA_DIR = BASE_DIR / "data" / "sample_raw"

ENCOUNTERS_FILE = DATA_DIR / "encounters.csv"
OUTPUT_FILE = DATA_DIR / "medications.csv"

# ----------------------------
# Sample reference data
# ----------------------------
MEDICATIONS = [
    ("Atorvastatin", "10 mg"),
    ("Metformin", "500 mg"),
    ("Lisinopril", "20 mg"),
    ("Amlodipine", "5 mg"),
    ("Amoxicillin", "500 mg"),
    ("Ibuprofen", "400 mg"),
    ("Insulin", "10 units"),
]

ROUTES = ["Oral", "IV", "Subcutaneous"]

# ----------------------------
# Load encounters
# ----------------------------
encounters_df = pd.read_csv(ENCOUNTERS_FILE, parse_dates=["admit_date", "discharge_date"])

records = []

for _, row in encounters_df.iterrows():
    num_meds = random.randint(1, 3)

    for _ in range(num_meds):
        med_name, dose = random.choice(MEDICATIONS)
        route = random.choice(ROUTES)

        # Timestamp between admit & discharge
        delta_minutes = random.randint(
            0,
            int((row["discharge_date"] - row["admit_date"]).total_seconds() / 60),
        )
        admin_time = row["admit_date"] + timedelta(minutes=delta_minutes)

        records.append({
            "medication_admin_id": str(uuid.uuid4()),
            "encounter_id": row["encounter_id"],
            "patient_id": row["patient_id"],
            "med_name": med_name,
            "dose": dose,
            "route": route,
            "admin_timestamp": admin_time.isoformat(),
        })

# ----------------------------
# Write CSV
# ----------------------------
OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)

with open(OUTPUT_FILE, mode="w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=records[0].keys())
    writer.writeheader()
    writer.writerows(records)

print(f"✅ medications.csv generated at: {OUTPUT_FILE}")
print(f"Rows written: {len(records)}")
