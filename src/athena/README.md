# Athena DDL Reference

These SQL files are **documentation only**.

Actual Athena tables are created via:
- Glue Jobs → Parquet
- Glue Crawlers → Data Catalog
- Athena → Query layer

DDL files are generated using:
SHOW CREATE TABLE healthcare_gold.<table_name>
