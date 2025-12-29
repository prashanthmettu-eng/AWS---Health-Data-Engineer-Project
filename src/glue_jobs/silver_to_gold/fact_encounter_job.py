"""
fact_encounter.py

Purpose:
- Build the Gold-layer fact_encounter table using Silver encounters data
- Join encounters with dimension tables (patient, provider, diagnosis, time)
- Calculate encounter-level metrics such as length of stay and total cost

Grain:
- One row per patient encounter

Output:
- Parquet files written to S3 Gold layer for analytics via Athena
"""

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, datediff, lit

# --------------------------------------------------
# Spark
# --------------------------------------------------
spark = SparkSession.builder.appName("gold_fact_encounter").getOrCreate()

# --------------------------------------------------
# S3 paths
# --------------------------------------------------
BUCKET = "health-aws-data-engineer-project-code-d805f87f"

SILVER_ENCOUNTERS = f"s3://{BUCKET}/silver/encounters/"
DIM_PATIENT = f"s3://{BUCKET}/gold/dim_patient/"
DIM_PROVIDER = f"s3://{BUCKET}/gold/dim_provider/"
DIM_TIME = f"s3://{BUCKET}/gold/dim_time/"
DIM_DIAGNOSIS = f"s3://{BUCKET}/gold/dim_diagnosis/"
FACT_ENCOUNTER = f"s3://{BUCKET}/gold/fact_encounter/"

# --------------------------------------------------
# Read data
# --------------------------------------------------
enc = spark.read.parquet(SILVER_ENCOUNTERS).alias("enc")
pat = spark.read.parquet(DIM_PATIENT).alias("pat")
prov = spark.read.parquet(DIM_PROVIDER).alias("prov")
diag = spark.read.parquet(DIM_DIAGNOSIS).alias("diag")

# 🔑 Rename date column BEFORE aliasing
time = (
    spark.read.parquet(DIM_TIME)
    .withColumnRenamed("date", "calendar_date")
)

admit_time = time.alias("admit_time")
discharge_time = time.alias("discharge_time")

# --------------------------------------------------
# Build fact_encounter
# --------------------------------------------------
fact_encounter = (
    enc
    .join(pat, col("enc.patient_id") == col("pat.patient_id"), "left")
    .join(prov, col("enc.provider_id") == col("prov.provider_id"), "left")
    .join(
        admit_time,
        col("enc.admit_date") == col("admit_time.calendar_date"),
        "left"
    )
    .join(
        discharge_time,
        col("enc.discharge_date") == col("discharge_time.calendar_date"),
        "left"
    )
    .join(
        diag,
        col("enc.diagnosis_code") == col("diag.diagnosis_code"),
        "left"
    )
    .select(
        col("enc.encounter_id"),
        col("pat.patient_key"),
        col("prov.provider_key"),
        col("admit_time.date_key").alias("admit_date_key"),
        col("discharge_time.date_key").alias("discharge_date_key"),
        datediff(
            col("enc.discharge_date"),
            col("enc.admit_date")
        ).alias("length_of_stay_days"),
        (datediff(col("enc.discharge_date"), col("enc.admit_date")) * 24)
            .cast("double")
            .alias("length_of_stay_hours"),
        col("enc.total_cost").cast("double"),
        col("diag.diagnosis_code"),        
        lit(1).alias("encounter_count")
    )
)

# --------------------------------------------------
# Write
# --------------------------------------------------
(
    fact_encounter
    .write
    .mode("overwrite")
    .parquet(FACT_ENCOUNTER)
)

spark.stop()
