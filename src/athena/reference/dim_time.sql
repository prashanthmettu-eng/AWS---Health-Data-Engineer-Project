-- AUTO-GENERATED FROM GLUE CATALOG
-- Source: SHOW CREATE TABLE healthcare_gold.dim_time
-- Do NOT edit manually

CREATE EXTERNAL TABLE `healthcare_gold.dim_time`(
  `date` date, 
  `date_key` bigint, 
  `day` int, 
  `month` int, 
  `month_name` string, 
  `quarter` int, 
  `year` int, 
  `day_of_week` string, 
  `is_weekend` boolean)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION
  's3://health-aws-data-engineer-project-code-d805f87f/gold/dim_time/'
TBLPROPERTIES (
  'CRAWL_RUN_ID'='7b6341a7-fa73-4b54-b26d-f39bd8972331', 
  'CrawlerSchemaDeserializerVersion'='1.0', 
  'CrawlerSchemaSerializerVersion'='1.0', 
  'UPDATED_BY_CRAWLER'='healthcare-gold-crawler', 
  'averageRecordSize'='13', 
  'classification'='parquet', 
  'compressionType'='none', 
  'objectCount'='1', 
  'recordCount'='9496', 
  'sizeKey'='80220', 
  'typeOfData'='file')