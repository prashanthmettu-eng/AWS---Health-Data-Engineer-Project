# Code Structure – AWS Health Data Engineer Project

This document explains the structure of the repository, the purpose of each major folder, and how different components work together in the pipeline.

---

## Root Level

AWS-Health-Data-Engineer-Project/
├── .github/
├── data/
├── docs/
├── infra/
├── src/
├── scripts/
├── README.md
└── .gitignore


---

## `.github/` – CI/CD (GitHub Actions)

.github/
└── workflows/
└── terraform.yml

**Purpose**
- Automates Terraform using GitHub Actions
- Uses OIDC to assume an AWS IAM role
- Runs `terraform init`, `plan`, and `apply` automatically on push to `main`

---

## `infra/terraform/` – Infrastructure as Code (Terraform)

infra/terraform/
├── backend.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── iam.tf
├── s3.tf
├── glue.tf
├── lambda.tf
├── stepfunctions.tf
├── eventbridge.tf
├── sns.tf
├── logging.tf
└── modules/
└── lambda/
├── main.tf
├── variables.tf
└── outputs.tf


### Key Files

- **backend.tf**
  - Configures Terraform remote state (S3 + DynamoDB locking)

- **provider.tf**
  - AWS provider configuration

- **iam.tf**
  - IAM roles and policies for:
    - Glue
    - Lambda
    - Step Functions
    - EventBridge
    - GitHub Actions (OIDC)

- **s3.tf**
  - Existing code bucket (Glue scripts)
  - Terraform state bucket

- **glue.tf**
  - Glue job definitions (bronze → silver, silver → gold)

- **lambda.tf**
  - Lambda functions used by Step Functions

- **stepfunctions.tf**
  - State Machine orchestration for the pipeline

- **eventbridge.tf**
  - Schedule-based trigger for Step Functions

- **modules/lambda/**
  - Reusable Terraform module for Lambda packaging and deployment

---

## `src/` – Application Logic



src/
├── glue_jobs/
│ ├── bronze_to_silver/
│ │ ├── patients_job.py
│ │ ├── encounters_job.py
│ │ └── medications_job.py
│ └── silver_to_gold/
│ ├── dim_patient_job.py
│ ├── dim_time_job.py
│ ├── dim_medication_job.py
│ ├── dim_provider_job.py
│ ├── dim_diagnosis_job.py
│ ├── fact_encounter_job.py
│ └── fact_medication_admin_job.py
│
├── lambda/
│ ├── start_glue_job.py
│ ├── check_glue_job_status.py
│ ├── sns_notify_success.py
│ └── sns_notify_failure.py
│
├── stepfunctions/
│ └── state_machine_def.template.json
│
├── athena/
│ └── reference/
│ ├── create_database.sql
│ ├── dim_patient.sql
│ ├── dim_time.sql
│ ├── dim_medication.sql
│ ├── dim_provider.sql
│ ├── fact_encounter.sql
│ └── fact_medication_admin.sql
│
└── data_generator/
├── generate_patients.py
├── generate_encounters.py
└── generate_medications.py


---

## Glue Jobs

### Bronze → Silver
- Cleans raw CSV data
- Writes partitioned Parquet files to S3

### Silver → Gold
- Builds:
  - Dimension tables (patient, time, medication, provider, diagnosis)
  - Fact tables (encounter, medication administration)

---

## Lambda Functions

**Purpose**
- Orchestrate Glue jobs via Step Functions

| Lambda | Responsibility |
|------|---------------|
| start_glue_job | Starts Glue job |
| check_glue_job_status | Polls Glue job status |
| sns_notify_success | Sends success notification |
| sns_notify_failure | Sends failure notification |

---

## Step Functions



src/stepfunctions/state_machine_def.template.json


**Pipeline Flow**
1. Bronze → Silver jobs (parallel)
2. Silver → Gold dimensions (sequential)
3. Silver → Gold facts (sequential)
4. Success or failure notification

---

## `data/` – Local Sample Data (Development Only)



data/
├── sample_raw/
│ ├── patients.csv
│ ├── encounters.csv
│ └── medications.csv
└── silver/
└── patients/
└── patients_clean.parquet


⚠️ Used only for local testing and development  
⚠️ Not used in production pipeline

---

## `scripts/`



scripts/
└── read_parquet_fix.py


Utility script to validate Parquet outputs locally.

---

## Summary

- **Terraform** manages all AWS infrastructure
- **GitHub Actions** handles CI/CD
- **Step Functions** orchestrate the pipeline
- **Glue** performs transformations
- **Lambda** coordinates execution and notifications
- **Athena SQL** enables analytics on Gold tables

This structure is production-grade, interview-ready, and scalable.

