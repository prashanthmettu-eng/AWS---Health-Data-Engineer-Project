CREATE EXTERNAL TABLE `healthcare_gold.fact_encounter`(
  `encounter_id` string, 
  `patient_key` bigint, 
  `provider_key` bigint, 
  `admit_date_key` bigint, 
  `discharge_date_key` bigint, 
  `length_of_stay_days` int, 
  `length_of_stay_hours` double, 
  `total_cost` double, 
  `diagnosis_code` string, 
  `encounter_count` int)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION
  's3://health-aws-data-engineer-project-code-d805f87f/gold/fact_encounter/'
TBLPROPERTIES (
  'CRAWL_RUN_ID'='76e2ab60-2456-415e-a38f-eeb4a00481aa', 
  'CrawlerSchemaDeserializerVersion'='1.0', 
  'CrawlerSchemaSerializerVersion'='1.0', 
  'UPDATED_BY_CRAWLER'='healthcare-gold-crawler', 
  'averageRecordSize'='80', 
  'classification'='parquet', 
  'compressionType'='none', 
  'objectCount'='1', 
  'recordCount'='156', 
  'sizeKey'='13016', 
  'typeOfData'='file')