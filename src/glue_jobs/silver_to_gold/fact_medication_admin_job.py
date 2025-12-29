"""
fact_medication_admin.py

Purpose:
- Build the GOLD fact table for medication administrations
- Links Silver medications data to:
    - dim_medication
    - dim_patient
    - fact_encounter
    - dim_time

Grain:
- One row per medication administration event

Output:
- S3 Gold path: gold/fact_medication_admin/
"""

from pyspark.sql import SparkSession
from pyspark.sql.functions import (
    col,
    trim,
    lower,
    to_date,
    lit
)

# --------------------------------------------------
# Spark session
# --------------------------------------------------
spark = (
    SparkSession.builder
    .appName("gold_fact_medication_admin")
    .getOrCreate()
)

# --------------------------------------------------
# S3 paths (CHANGE BUCKET NAME ONLY IF REQUIRED)
# --------------------------------------------------
BUCKET = "health-aws-data-engineer-project-code-d805f87f"

SILVER_MEDICATIONS = f"s3://{BUCKET}/silver/medications/"
GOLD_DIM_MEDICATION = f"s3://{BUCKET}/gold/dim_medication/"
GOLD_DIM_PATIENT = f"s3://{BUCKET}/gold/dim_patient/"
GOLD_FACT_ENCOUNTER = f"s3://{BUCKET}/gold/fact_encounter/"
GOLD_DIM_TIME = f"s3://{BUCKET}/gold/dim_time/"
GOLD_FACT_MED_ADMIN = f"s3://{BUCKET}/gold/fact_medication_admin/"

# --------------------------------------------------
# Read source tables
# --------------------------------------------------

# Silver medications
med_clean = (
    spark.read.parquet(SILVER_MEDICATIONS)
    .withColumn("med_name_norm", trim(lower(col("med_name"))))
    .withColumn("route_norm", trim(lower(col("route"))))
    .withColumn("admin_date", to_date(col("admin_timestamp")))
    .alias("med")
)

# Gold dimensions / facts
dm  = spark.read.parquet(GOLD_DIM_MEDICATION).alias("dm")
pat = spark.read.parquet(GOLD_DIM_PATIENT).alias("pat")
enc = spark.read.parquet(GOLD_FACT_ENCOUNTER).alias("enc")
t   = spark.read.parquet(GOLD_DIM_TIME).alias("t")

# --------------------------------------------------
# Build fact_medication_admin
# --------------------------------------------------
fact_med_admin = (
    med_clean.alias("med")
    # Medication dimension
    .join(
        dm.alias("dm"),
        (col("med.med_name_norm") == col("dm.med_name")) &
        (col("med.route_norm") == col("dm.route")),
        "left"
    )
    # Patient dimension
    .join(
        pat.alias("pat"),
        col("med.patient_id") == col("pat.patient_id"),
        "left"
    )
    # Encounter fact
    .join(
        enc.alias("enc"),
        col("med.encounter_id") == col("enc.encounter_id"),
        "left"
    )
    # Time dimension
    .join(
        t.alias("t"),
        col("med.admin_date") == col("t.date"),
        "left"
    )
    # Final projection (FACT columns only)
    .select(
        col("med.medication_admin_id"),
        col("enc.encounter_id"),
        col("pat.patient_key"),
        col("dm.medication_key").alias("med_key"),
        col("t.date_key").alias("admin_date_key"),
        col("med.dose"),
        col("med.route"),
        lit(1).alias("admin_count")
    )
)

# --------------------------------------------------
# Write Gold fact table
# --------------------------------------------------
(
    fact_med_admin
    .write
    .mode("overwrite")
    .parquet(GOLD_FACT_MED_ADMIN)
)

spark.stop()
