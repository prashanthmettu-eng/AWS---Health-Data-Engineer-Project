"""
encounters_job.py
Bronze → Silver transformation for encounters
"""

from pyspark.sql import SparkSession, functions as F

# ---------- Spark ----------
spark = SparkSession.builder.appName("bronze_to_silver_encounters").getOrCreate()

# ---------- Paths ----------
SOURCE_PATH = "s3://health-aws-data-engineer-project-code-d805f87f/bronze/encounters/"
TARGET_PATH = "s3://health-aws-data-engineer-project-code-d805f87f/silver/encounters/"

# ---------- Read ----------
df = (
    spark.read
    .option("header", True)
    .csv(SOURCE_PATH)
)

# ---------- Clean & Transform ----------
df_clean = (
    df
    .withColumn("admit_date", F.to_date("admit_date"))
    .withColumn("discharge_date", F.to_date("discharge_date"))
    .withColumn("total_cost", F.col("total_cost").cast("double"))
    .withColumn(
        "length_of_stay",
        F.datediff(F.col("discharge_date"), F.col("admit_date"))
    )
    .withColumn("ingested_at", F.current_timestamp())
    .filter(F.col("length_of_stay") >= 0)
)

# ---------- Partitioning ----------
df_final = (
    df_clean
    .withColumn("ingest_year", F.year("ingested_at"))
    .withColumn("ingest_month", F.month("ingested_at"))
)

# ---------- Write ----------
(
    df_final
    .write
    .mode("overwrite")
    .partitionBy("ingest_year", "ingest_month")
    .parquet(TARGET_PATH)
)

spark.stop()
