
# Upload Silver ETL script to S3 so Glue can access it
resource "aws_s3_object" "bronze_to_silver_patients_script" {
  bucket = data.aws_s3_bucket.code_bucket.bucket  
  key    = "glue/bronze_to_silver/patients_job.py"
  source = "${path.module}/../../src/glue_jobs/bronze_to_silver/patients_job.py"

  # Ensures Terraform detects script changes
  etag = filemd5("${path.module}/../../src/glue_jobs/bronze_to_silver/patients_job.py")
}
# Glue Job for Bronze -> Silver ETL
resource "aws_glue_job" "bronze_to_silver_patients" {
  name     = "bronze-to-silver-patients-job"
  role_arn = aws_iam_role.glue_service_role.arn

  glue_version = "4.0"
  worker_type       = "G.1X"
  number_of_workers = 2

  execution_property {
    max_concurrent_runs = 3
  }

  command {
    name            = "glueetl"
    script_location = "s3://${data.aws_s3_bucket.code_bucket.bucket}/glue/bronze_to_silver/patients_job.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"        = "s3://${data.aws_s3_bucket.code_bucket.bucket}/temp/"
    "--enable-metrics" = "true"
    "--job-language"   = "python"
  }


  tags = {
    Project     = "health-aws-data-engineer-project"
    Environment = "dev"
  }
}

resource "aws_s3_object" "bronze_to_silver_encounters_script" {
  bucket = data.aws_s3_bucket.code_bucket.bucket
  key    = "glue/bronze_to_silver/encounters_job.py"
  source = "${path.module}/../../src/glue_jobs/bronze_to_silver/encounters_job.py"

  # Ensures Terraform detects script changes
  etag = filemd5("${path.module}/../../src/glue_jobs/bronze_to_silver/encounters_job.py")
}
resource "aws_glue_job" "bronze_to_silver_encounters" {
  name     = "bronze-to-silver-encounters-job"
  role_arn = aws_iam_role.glue_service_role.arn

  glue_version = "4.0"
  worker_type       = "G.1X"
  number_of_workers = 2

  execution_property {
    max_concurrent_runs = 3
  }

  command {
    name            = "glueetl"
    script_location = "s3://${data.aws_s3_bucket.code_bucket.id}/glue/bronze_to_silver/encounters_job.py"
    python_version  = "3"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_s3_object" "bronze_to_silver_medications_script" {
  bucket = data.aws_s3_bucket.code_bucket.bucket
  key    = "glue/bronze_to_silver/medications_job.py"
  source = "${path.module}/../../src/glue_jobs/bronze_to_silver/medications_job.py"

  # This forces Terraform to detect file changes
  etag = filemd5("${path.module}/../../src/glue_jobs/bronze_to_silver/medications_job.py")
}
resource "aws_glue_job" "bronze_to_silver_medications" {
  name     = "bronze-to-silver-medications-job"
  role_arn = aws_iam_role.glue_service_role.arn

  glue_version = "4.0"
  worker_type       = "G.1X"
  number_of_workers = 2

  execution_property {
    max_concurrent_runs = 3
  }

  command {
    name            = "glueetl"
    script_location = "s3://${data.aws_s3_bucket.code_bucket.bucket}/glue/bronze_to_silver/medications_job.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"        = "s3://${data.aws_s3_bucket.code_bucket.bucket}/temp/"
    "--enable-metrics" = "true"
    "--job-language"   = "python"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Upload Gold ETL script to S3 so Glue can access it
resource "aws_s3_object" "silver_to_gold_dim_patient_script" {
  bucket = data.aws_s3_bucket.code_bucket.bucket
  key    = "glue/silver_to_gold/dim_patient_job.py"
  source = "${path.module}/../../src/glue_jobs/silver_to_gold/dim_patient_job.py"

  etag = filemd5("${path.module}/../../src/glue_jobs/silver_to_gold/dim_patient_job.py")
}
# Glue Job for Silver -> Gold ETL
resource "aws_glue_job" "silver_to_gold_dim_patient" {
  name     = "silver-to-gold-dim-patient-job"
  role_arn = aws_iam_role.glue_service_role.arn

  glue_version = "4.0"
  worker_type       = "G.1X"
  number_of_workers = 2

  execution_property {
    max_concurrent_runs = 3
  }

  command {
    name            = "glueetl"
    script_location = "s3://${data.aws_s3_bucket.code_bucket.bucket}/glue/silver_to_gold/dim_patient_job.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"        = "s3://${data.aws_s3_bucket.code_bucket.bucket}/temp/"
    "--enable-metrics" = "true"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_s3_object" "silver_to_gold_dim_time_script" {
  bucket = data.aws_s3_bucket.code_bucket.bucket
  key    = "glue/silver_to_gold/dim_time_job.py"
  source = "${path.module}/../../src/glue_jobs/silver_to_gold/dim_time_job.py"

  etag = filemd5("${path.module}/../../src/glue_jobs/silver_to_gold/dim_time_job.py")
}
resource "aws_glue_job" "silver_to_gold_dim_time" {
  name     = "silver-to-gold-dim-time-job"
  role_arn = aws_iam_role.glue_service_role.arn

  glue_version = "4.0"
  worker_type       = "G.1X"
  number_of_workers = 2

  execution_property {
    max_concurrent_runs = 3
  }

  command {
    name            = "glueetl"
    script_location = "s3://${data.aws_s3_bucket.code_bucket.bucket}/glue/silver_to_gold/dim_time_job.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"        = "s3://${data.aws_s3_bucket.code_bucket.bucket}/temp/"
    "--enable-metrics" = "true"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_s3_object" "dim_medication_script" {
  bucket = data.aws_s3_bucket.code_bucket.bucket
  key    = "glue/silver_to_gold/dim_medication_job.py"
  source = "${path.module}/../../src/glue_jobs/silver_to_gold/dim_medication_job.py"

  etag = filemd5("${path.module}/../../src/glue_jobs/silver_to_gold/dim_medication_job.py")
}
resource "aws_glue_job" "dim_medication" {
  name     = "silver-to-gold-dim-medication-job"
  role_arn = aws_iam_role.glue_service_role.arn

  glue_version = "4.0"
  worker_type       = "G.1X"
  number_of_workers = 2

  execution_property {
    max_concurrent_runs = 3
  }

  command {
    name            = "glueetl"
    script_location = "s3://${data.aws_s3_bucket.code_bucket.bucket}/glue/silver_to_gold/dim_medication_job.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"        = "s3://${data.aws_s3_bucket.code_bucket.bucket}/temp/"
    "--enable-metrics" = "true"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_s3_object" "silver_to_gold_dim_provider_script" {
  bucket = data.aws_s3_bucket.code_bucket.bucket
  key    = "glue/silver_to_gold/dim_provider_job.py"
  source = "${path.module}/../../src/glue_jobs/silver_to_gold/dim_provider_job.py"
  etag   = filemd5("${path.module}/../../src/glue_jobs/silver_to_gold/dim_provider_job.py")
}
resource "aws_glue_job" "silver_to_gold_dim_provider" {
  name     = "silver-to-gold-dim-provider-job"
  role_arn = aws_iam_role.glue_service_role.arn

  glue_version = "4.0"
  worker_type       = "G.1X"
  number_of_workers = 2

  execution_property {
    max_concurrent_runs = 3
  }


  command {
    name            = "glueetl"
    script_location = "s3://${data.aws_s3_bucket.code_bucket.bucket}/glue/silver_to_gold/dim_provider_job.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"        = "s3://${data.aws_s3_bucket.code_bucket.bucket}/temp/"
    "--enable-metrics" = "true"
    "--job-language"   = "python"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_s3_object" "silver_to_gold_dim_diagnosis_script" {
  bucket = data.aws_s3_bucket.code_bucket.bucket
  key    = "glue/silver_to_gold/dim_diagnosis_job.py"
  source = "${path.module}/../../src/glue_jobs/silver_to_gold/dim_diagnosis_job.py"

  etag = filemd5("${path.module}/../../src/glue_jobs/silver_to_gold/dim_diagnosis_job.py")
}
resource "aws_glue_job" "silver_to_gold_dim_diagnosis" {
  name     = "silver-to-gold-dim-diagnosis-job"
  role_arn = aws_iam_role.glue_service_role.arn

  glue_version = "4.0"
  worker_type       = "G.1X"
  number_of_workers = 2

  execution_property {
    max_concurrent_runs = 3
  }

  command {
    name            = "glueetl"
    script_location = "s3://${data.aws_s3_bucket.code_bucket.bucket}/glue/silver_to_gold/dim_diagnosis_job.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"        = "s3://${data.aws_s3_bucket.code_bucket.bucket}/temp/"
    "--enable-metrics" = "true"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

############################################
# Upload Silver → Gold fact_encounter script
############################################

resource "aws_s3_object" "silver_to_gold_fact_encounter_script" {
  bucket = data.aws_s3_bucket.code_bucket.bucket
  key    = "glue/silver_to_gold/fact_encounter_job.py"

  source = "${path.module}/../../src/glue_jobs/silver_to_gold/fact_encounter_job.py"

  # IMPORTANT: ensures script updates trigger redeploy
  etag = filemd5("${path.module}/../../src/glue_jobs/silver_to_gold/fact_encounter_job.py")
}
############################################
# Glue Job: Silver → Gold fact_encounter
############################################

resource "aws_glue_job" "silver_to_gold_fact_encounter" {
  name     = "silver-to-gold-fact-encounter-job"
  role_arn = aws_iam_role.glue_service_role.arn

  glue_version = "4.0"
  worker_type       = "G.1X"
  number_of_workers = 2

  execution_property {
    max_concurrent_runs = 2
  }

  command {
    name            = "glueetl"
    script_location = "s3://${data.aws_s3_bucket.code_bucket.bucket}/glue/silver_to_gold/fact_encounter_job.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"        = "s3://${data.aws_s3_bucket.code_bucket.bucket}/temp/"
    "--enable-metrics" = "true"
    "--job-language"   = "python"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Layer       = "gold"
    Type        = "fact"
  }
}

resource "aws_s3_object" "silver_to_gold_fact_medication_admin_script" {
  bucket = data.aws_s3_bucket.code_bucket.bucket
  key    = "glue/silver_to_gold/fact_medication_admin_job.py"
  source = "${path.module}/../../src/glue_jobs/silver_to_gold/fact_medication_admin_job.py"

  etag = filemd5("${path.module}/../../src/glue_jobs/silver_to_gold/fact_medication_admin_job.py")
}
resource "aws_glue_job" "silver_to_gold_fact_medication_admin" {
  name     = "silver-to-gold-fact-medication-admin-job"
  role_arn = aws_iam_role.glue_service_role.arn

  glue_version = "4.0"
  worker_type       = "G.1X"
  number_of_workers = 2

  execution_property {
    max_concurrent_runs = 2
  }

  command {
    name            = "glueetl"
    script_location = "s3://${data.aws_s3_bucket.code_bucket.bucket}/glue/silver_to_gold/fact_medication_admin_job.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"        = "s3://${data.aws_s3_bucket.code_bucket.bucket}/temp/"
    "--job-language"   = "python"
    "--enable-metrics" = "true"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}







