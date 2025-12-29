import pyarrow.parquet as pq
import pandas as pd
import pyarrow as pa
p = r"data/silver/patients/ingest_year=2025/ingest_month=12/patients_clean.parquet"

print("Reading schema with pyarrow...")
try:
    pf = pq.ParquetFile(p)
    print(pf.schema)
    print("\nRow groups and columns types:")
    for i in range(pf.num_row_groups):
        rg = pf.read_row_group(i)
        print(f" RowGroup {i}:")
        for name, col in zip(rg.column_names, rg.columns):
            print("   ", name, "->", col.type)
except Exception as e:
    print("pyarrow schema inspect error (expected if merge fails):", e)

print("\nNow trying pandas.read_parquet (more forgiving)...")
try:
    df = pd.read_parquet(p, engine="pyarrow")
    print("\nDataFrame dtypes:")
    print(df.dtypes)
    # coerce ingest_year to int (if exists)
    if "ingest_year" in df.columns:
        df["ingest_year"] = pd.to_numeric(df["ingest_year"], errors="coerce").astype("Int64")
    if "ingest_month" in df.columns:
        df["ingest_month"] = pd.to_numeric(df["ingest_month"], errors="coerce").astype("Int64")
    print("\n=== first 3 rows ===")
    print(df.head(3).to_csv(index=False))
except Exception as e:
    print("Failed to read with pandas.read_parquet:", e)
    print("As a fallback, we will attempt to read each row-group separately with pyarrow and concat into pandas.")
    try:
        pf = pq.ParquetFile(p)
        parts = []
        for i in range(pf.num_row_groups):
            tbl = pf.read_row_group(i).to_pandas()
            parts.append(tbl)
        df2 = pd.concat(parts, ignore_index=True)
        print("\nConcatenated pandas DataFrame dtypes:")
        print(df2.dtypes)
        print("\n=== first 3 rows from concatenated df ===")
        print(df2.head(3).to_csv(index=False))
    except Exception as e2:
        print("Fallback also failed:", e2)
