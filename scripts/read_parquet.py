import pyarrow.parquet as pq
import pandas as pd
p = r"data/silver/patients/ingest_year=2025/ingest_month=12/patients_clean.parquet"
try:
    table = pq.read_table(p)
    df = table.to_pandas()
    print("=== first 3 rows ===")
    print(df.head(3).to_csv(index=False))
except Exception as e:
    print("Error reading parquet:", e)
