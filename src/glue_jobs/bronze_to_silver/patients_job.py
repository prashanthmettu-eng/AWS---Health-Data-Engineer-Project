"""
Glue Job: Bronze → Silver (Patients)

Purpose:
- Read raw patient CSV data from S3 Bronze
- Perform basic cleaning and typing
- Write Parquet output to S3 Silver

This job is designed to run ONLY in AWS Glue.
"""

from pyspark.sql import SparkSession, functions as F, types as T


def main():
    spark = SparkSession.builder.appName("bronze_to_silver_patients").getOrCreate()

    # =========================
    # S3 Paths (Bronze → Silver)
    # =========================
    BRONZE_PATH = "s3://health-aws-data-engineer-project-code-d805f87f/bronze/patients/patients.csv"
    SILVER_PATH = "s3://health-aws-data-engineer-project-code-d805f87f/silver/patients/"

    print(f"Reading Bronze data from: {BRONZE_PATH}")
    print(f"Writing Silver data to: {SILVER_PATH}")

    # =========================
    # Read CSV from Bronze
    # =========================
    df = (
        spark.read
        .option("header", True)
        .csv(BRONZE_PATH)
    )

    # =========================
    # Basic Cleaning & Typing
    # =========================
    df_clean = (
        df
        .withColumn("patient_id", F.col("patient_id"))
        .withColumn("first_name", F.trim(F.col("first_name")))
        .withColumn("last_name", F.trim(F.col("last_name")))
        .withColumn("dob", F.to_date(F.col("dob"), "yyyy-MM-dd"))
        .withColumn("gender", F.col("gender"))
        .withColumn("zip", F.col("zip").cast(T.StringType()))
        .withColumn("ingested_at", F.current_timestamp())
    )

    # =========================
    # Write Silver Parquet
    # =========================
    (
        df_clean
        .write
        .mode("overwrite")
        .parquet(SILVER_PATH)
    )

    print("✅ Bronze → Silver job completed successfully")

    spark.stop()


if __name__ == "__main__":
    main()
