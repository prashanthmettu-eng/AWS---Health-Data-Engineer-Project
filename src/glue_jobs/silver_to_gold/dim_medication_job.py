from pyspark.sql import SparkSession
from pyspark.sql.functions import col, monotonically_increasing_id, trim, lower

spark = SparkSession.builder.appName("dim_medication").getOrCreate()

# -----------------------------
# Config
# -----------------------------
SILVER_PATH = "s3://health-aws-data-engineer-project-code-d805f87f/silver/medications/"
GOLD_PATH   = "s3://health-aws-data-engineer-project-code-d805f87f/gold/dim_medication/"

# -----------------------------
# Read Silver medications
# -----------------------------
df = spark.read.parquet(SILVER_PATH)

# -----------------------------
# Build medication dimension
# -----------------------------
dim_medication = (
    df.select(
        trim(lower(col("med_name"))).alias("med_name"),
        trim(lower(col("route"))).alias("route")
    )
    .dropDuplicates()
    .withColumn("medication_key", monotonically_increasing_id())
)

# -----------------------------
# Write Gold dimension
# -----------------------------
(
    dim_medication
    .select("medication_key", "med_name", "route")
    .write
    .mode("overwrite")
    .parquet(GOLD_PATH)
)

spark.stop()
