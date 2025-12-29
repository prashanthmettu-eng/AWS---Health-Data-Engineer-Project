from pyspark.sql import SparkSession
from pyspark.sql.functions import col, trim, upper, monotonically_increasing_id, when

spark = SparkSession.builder.appName("dim_diagnosis").getOrCreate()

# -------- CONFIG --------
SILVER_ENCOUNTERS_PATH = "s3://health-aws-data-engineer-project-code-d805f87f/silver/encounters/"
GOLD_DIM_DIAGNOSIS_PATH = "s3://health-aws-data-engineer-project-code-d805f87f/gold/dim_diagnosis/"

# -------- READ --------
df = spark.read.parquet(SILVER_ENCOUNTERS_PATH)

# -------- TRANSFORM --------
dim_diagnosis = (
    df
    .select(trim(upper(col("diagnosis_code"))).alias("diagnosis_code"))
    .dropna()
    .dropDuplicates()
    .withColumn(
        "diagnosis_category",
        when(col("diagnosis_code").startswith("I"), "Cardiology")
        .when(col("diagnosis_code").startswith("E"), "Endocrinology")
        .when(col("diagnosis_code").startswith("J"), "Respiratory")
        .otherwise("General")
    )
    .withColumn("diagnosis_key", monotonically_increasing_id())
)

# -------- WRITE --------
(
    dim_diagnosis
    .write
    .mode("overwrite")
    .parquet(GOLD_DIM_DIAGNOSIS_PATH)
)

spark.stop()
