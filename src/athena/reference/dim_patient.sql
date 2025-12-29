-- AUTO-GENERATED FROM GLUE CATALOG
-- Source: SHOW CREATE TABLE healthcare_gold.dim_patient
-- Do NOT edit manually

CREATE EXTERNAL TABLE `healthcare_gold.dim_patient`(
  `patient_id` string, 
  `gender` string, 
  `dob` date, 
  `zip` string, 
  `(year(current_date()) - year(dob) as age)` int, 
  `patient_key` bigint)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION
  's3://health-aws-data-engineer-project-code-d805f87f/gold/dim_patient/'
TBLPROPERTIES (
  'CRAWL_RUN_ID'='7b6341a7-fa73-4b54-b26d-f39bd8972331', 
  'CrawlerSchemaDeserializerVersion'='1.0', 
  'CrawlerSchemaSerializerVersion'='1.0', 
  'UPDATED_BY_CRAWLER'='healthcare-gold-crawler', 
  'averageRecordSize'='69', 
  'classification'='parquet', 
  'compressionType'='none', 
  'objectCount'='1', 
  'recordCount'='50', 
  'sizeKey'='4869', 
  'typeOfData'='file')