# dim_time_job.py
# Gold: Time Dimension

from pyspark.sql import SparkSession
from pyspark.sql.functions import (
    col,
    dayofmonth,
    month,
    year,
    quarter,
    date_format,
    dayofweek,
    when,
    monotonically_increasing_id
)

spark = SparkSession.builder.appName("dim_time_job").getOrCreate()

# ---------- CONFIG ----------
START_DATE = "2010-01-01"
END_DATE   = "2035-12-31"

GOLD_DIM_TIME_PATH = "s3://health-aws-data-engineer-project-code-d805f87f/gold/dim_time/"

# ---------- GENERATE DATE RANGE ----------
df = (
    spark
    .sql(f"""
        SELECT explode(
            sequence(
                to_date('{START_DATE}'),
                to_date('{END_DATE}'),
                interval 1 day
            )
        ) AS date
    """)
)

# ---------- TRANSFORM ----------
dim_time = (
    df
    .withColumn("date_key", monotonically_increasing_id())
    .withColumn("day", dayofmonth(col("date")))
    .withColumn("month", month(col("date")))
    .withColumn("month_name", date_format(col("date"), "MMMM"))
    .withColumn("quarter", quarter(col("date")))
    .withColumn("year", year(col("date")))
    .withColumn("day_of_week", date_format(col("date"), "EEEE"))
    .withColumn(
        "is_weekend",
        when(dayofweek(col("date")).isin([1, 7]), True).otherwise(False)
    )
)

# ---------- WRITE ----------
(
    dim_time
    .write
    .mode("overwrite")
    .parquet(GOLD_DIM_TIME_PATH)
)

spark.stop()
