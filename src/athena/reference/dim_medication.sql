-- AUTO-GENERATED FROM GLUE CATALOG
-- Source: SHOW CREATE TABLE healthcare_gold.dim_medication
-- Do NOT edit manually

CREATE EXTERNAL TABLE `healthcare_gold.dim_medication`(
  `medication_key` bigint, 
  `med_name` string, 
  `route` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION
  's3://health-aws-data-engineer-project-code-d805f87f/gold/dim_medication/'
TBLPROPERTIES (
  'CRAWL_RUN_ID'='7b6341a7-fa73-4b54-b26d-f39bd8972331', 
  'CrawlerSchemaDeserializerVersion'='1.0', 
  'CrawlerSchemaSerializerVersion'='1.0', 
  'UPDATED_BY_CRAWLER'='healthcare-gold-crawler', 
  'averageRecordSize'='20', 
  'classification'='parquet', 
  'compressionType'='none', 
  'objectCount'='1', 
  'recordCount'='21', 
  'sizeKey'='1260', 
  'typeOfData'='file')