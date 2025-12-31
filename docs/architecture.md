AWS-Health-Data-Engineer-Project/
│
├── .github/                               # CI/CD with GitHub Actions
│   └── workflows/
│       └── terraform.yml                 # Terraform plan/apply via OIDC
│
├── infra/
│   └── terraform/                        # Infrastructure as Code
│       ├── backend.tf                   # S3 + DynamoDB remote state
│       ├── provider.tf                  # AWS provider
│       ├── variables.tf
│       ├── outputs.tf
│       ├── iam.tf                       # IAM roles & policies
│       ├── s3.tf                        # Code bucket + state bucket
│       ├── glue.tf                     # Glue jobs (Bronze/Silver/Gold)
│       ├── lambda.tf                   # Lambda functions
│       ├── stepfunctions.tf             # State Machine orchestration
│       ├── eventbridge.tf               # Scheduled execution
│       ├── sns.tf                       # Notifications
│       ├── logging.tf                   # CloudWatch logs
│       └── modules/
│           └── lambda/                  # Reusable Lambda module
│               ├── main.tf
│               ├── variables.tf
│               └── outputs.tf
│
├── src/
│   ├── data_generator/                  # Synthetic healthcare data
│   │   ├── generate_patients.py
│   │   ├── generate_encounters.py
│   │   └── generate_medications.py
│   │
│   ├── glue_jobs/
│   │   ├── bronze_to_silver/             # Raw → Cleaned
│   │   │   ├── patients_job.py
│   │   │   ├── encounters_job.py
│   │   │   └── medications_job.py
│   │   │
│   │   └── silver_to_gold/               # Cleaned → Star Schema
│   │       ├── dim_patient_job.py
│   │       ├── dim_time_job.py
│   │       ├── dim_medication_job.py
│   │       ├── dim_provider_job.py
│   │       ├── dim_diagnosis_job.py
│   │       ├── fact_encounter_job.py
│   │       └── fact_medication_admin_job.py
│   │
│   ├── lambda/                           # Orchestration Lambdas
│   │   ├── start_glue_job.py             # Start Glue job
│   │   ├── check_glue_job_status.py      # Poll Glue job
│   │   ├── sns_notify_success.py         # Success notification
│   │   └── sns_notify_failure.py         # Failure notification
│   │
│   ├── stepfunctions/
│   │   └── state_machine_def.template.json
│   │
│   └── athena/
│       └── reference/                    # Analytics / SQL layer
│           ├── create_database.sql
│           ├── dim_patient.sql
│           ├── dim_time.sql
│           ├── dim_medication.sql
│           ├── dim_provider.sql
│           ├── fact_encounter.sql
│           └── fact_medication_admin.sql
│
├── data/                                 # Local development samples only
│   └── sample_raw/
│       ├── patients.csv
│       ├── encounters.csv
│       └── medications.csv
│
├── scripts/
│   └── read_parquet_fix.py               # Local Parquet validation
│
├── docs/
│   ├── code_structure.md                 # Repo structure explanation
│   └── architecture.md                  # High-level architecture
│
├── README.md                             # Project overview
└── .gitignore



