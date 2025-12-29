CREATE EXTERNAL TABLE `healthcare_gold.fact_medication_admin`(
  `medication_admin_id` string, 
  `encounter_id` string, 
  `patient_key` bigint, 
  `med_key` bigint, 
  `admin_date_key` bigint, 
  `dose` string, 
  `route` string, 
  `admin_count` int)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION
  's3://health-aws-data-engineer-project-code-d805f87f/gold/fact_medication_admin/'
TBLPROPERTIES (
  'CRAWL_RUN_ID'='0a31c8c1-0451-430d-8710-fdcf04e3645d', 
  'CrawlerSchemaDeserializerVersion'='1.0', 
  'CrawlerSchemaSerializerVersion'='1.0', 
  'UPDATED_BY_CRAWLER'='healthcare-gold-crawler', 
  'averageRecordSize'='73', 
  'classification'='parquet', 
  'compressionType'='none', 
  'objectCount'='1', 
  'recordCount'='312', 
  'sizeKey'='22824', 
  'typeOfData'='file')