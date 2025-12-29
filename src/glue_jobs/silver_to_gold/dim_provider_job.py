from pyspark.sql import SparkSession
from pyspark.sql.functions import col, monotonically_increasing_id

spark = SparkSession.builder.appName("dim_provider").getOrCreate()

# ---------- PATHS ----------
SILVER_ENCOUNTERS_PATH = "s3://health-aws-data-engineer-project-code-d805f87f/silver/encounters/"
GOLD_DIM_PROVIDER_PATH = "s3://health-aws-data-engineer-project-code-d805f87f/gold/dim_provider/"

# ---------- READ ----------
encounters = spark.read.parquet(SILVER_ENCOUNTERS_PATH)

# ---------- TRANSFORM ----------
dim_provider = (
    encounters
    .select(col("provider_id"))
    .dropDuplicates(["provider_id"])
    .withColumn("provider_key", monotonically_increasing_id())
)

# ---------- WRITE ----------
(
    dim_provider
    .write
    .mode("overwrite")
    .parquet(GOLD_DIM_PROVIDER_PATH)
)

spark.stop()
