-- AUTO-GENERATED FROM GLUE CATALOG
-- Source: SHOW CREATE TABLE healthcare_gold.dim_provider
-- Do NOT edit manually

CREATE EXTERNAL TABLE `healthcare_gold.dim_provider`(
  `provider_id` string, 
  `provider_key` bigint)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION
  's3://health-aws-data-engineer-project-code-d805f87f/gold/dim_provider/'
TBLPROPERTIES (
  'CRAWL_RUN_ID'='834f1a85-1d44-4708-924b-b338f98c0881', 
  'CrawlerSchemaDeserializerVersion'='1.0', 
  'CrawlerSchemaSerializerVersion'='1.0', 
  'UPDATED_BY_CRAWLER'='healthcare-gold-crawler', 
  'averageRecordSize'='48', 
  'classification'='parquet', 
  'compressionType'='none', 
  'objectCount'='1', 
  'recordCount'='156', 
  'sizeKey'='7447', 
  'typeOfData'='file')