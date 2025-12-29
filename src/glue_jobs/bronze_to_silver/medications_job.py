"""
medications_job.py
Bronze → Silver transformation for medications
"""

from pyspark.sql import SparkSession
from pyspark.sql.functions import (
    col,
    current_timestamp,
    year,
    month
)

spark = SparkSession.builder.appName("bronze_to_silver_medications").getOrCreate()

# -----------------------
# S3 paths
# -----------------------
BRONZE_PATH = "s3://health-aws-data-engineer-project-code-d805f87f/bronze/medications/medications.csv"
SILVER_PATH = "s3://health-aws-data-engineer-project-code-d805f87f/silver/medications/"

# -----------------------
# Read Bronze
# -----------------------
df = spark.read.option("header", True).csv(BRONZE_PATH)

# -----------------------
# Clean & normalize
# -----------------------
df_clean = (
    df
    .withColumn("dose", col("dose").cast("string"))
    .withColumn("admin_time", col("admin_timestamp").cast("timestamp"))
    .withColumn("ingested_at", current_timestamp())
)

# -----------------------
# Partition columns
# -----------------------
df_final = (
    df_clean
    .withColumn("ingest_year", year(col("ingested_at")))
    .withColumn("ingest_month", month(col("ingested_at")))
)

# -----------------------
# Write Silver
# -----------------------
(
    df_final
    .write
    .mode("overwrite")
    .partitionBy("ingest_year", "ingest_month")
    .parquet(SILVER_PATH)
)

spark.stop()
