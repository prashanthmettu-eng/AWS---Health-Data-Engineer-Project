# dim_patient_job.py
# Silver → Gold: Patient Dimension

from pyspark.sql import SparkSession
from pyspark.sql.functions import (
    col,
    current_date,
    year,
    datediff,
    monotonically_increasing_id
)

spark = SparkSession.builder.appName("dim_patient_job").getOrCreate()

# ---------- INPUT ----------
SILVER_PATIENTS_PATH = "s3://health-aws-data-engineer-project-code-d805f87f/silver/patients/"

# ---------- OUTPUT ----------
GOLD_DIM_PATIENT_PATH = "s3://health-aws-data-engineer-project-code-d805f87f/gold/dim_patient/"

# ---------- READ ----------
df = spark.read.parquet(SILVER_PATIENTS_PATH)

# ---------- TRANSFORM ----------
dim_patient = (
    df
    .select(
        col("patient_id"),
        col("gender"),
        col("dob"),
        col("zip"),
        year(current_date()) - year(col("dob")).alias("age")
    )
    .dropDuplicates(["patient_id"])
    .withColumn("patient_key", monotonically_increasing_id())
)

# ---------- WRITE ----------
(
    dim_patient
    .write
    .mode("overwrite")
    .parquet(GOLD_DIM_PATIENT_PATH)
)

spark.stop()
