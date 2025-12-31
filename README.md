# AWS Health Data Engineer Project

End-to-end **serverless data engineering pipeline on AWS** using
S3, Glue, Step Functions, Lambda, EventBridge, Athena, Terraform, and GitHub Actions.

This project demonstrates **production-grade infrastructure**, automated CI/CD,
secure IAM with OIDC, and a medallion (Bronze → Silver → Gold) data architecture.

---

## 🏗 Architecture Overview

![Architecture Diagram](docs/architecture.png)

**Flow**
1. Raw healthcare CSV data lands in **S3 (Bronze)**
2. **AWS Glue** transforms Bronze → Silver (cleaned parquet)
3. **AWS Glue** transforms Silver → Gold (dim & fact tables)
4. **AWS Step Functions** orchestrates the pipeline
5. **AWS Lambda** starts Glue jobs and monitors status
6. **Amazon SNS** sends success/failure notifications
7. **Amazon EventBridge** schedules pipeline execution
8. **Amazon Athena** queries Gold datasets
9. **Terraform + GitHub Actions** manage infra & CI/CD

---

## 🧱 Medallion Architecture

| Layer  | Purpose |
|------|--------|
| Bronze | Raw CSV ingestion |
| Silver | Cleaned, partitioned parquet |
| Gold | Analytics-ready fact & dimension tables |

---

## 🚀 CI/CD & Automation

- **GitHub Actions** triggers on push to `main`
- Uses **OIDC (no static AWS keys)**
- Runs:
  - `terraform init`
  - `terraform plan`
  - `terraform apply`
- Terraform state stored securely in **S3 + DynamoDB lock**

---

## 🔐 Security Highlights

- GitHub → AWS authentication via **OIDC**
- Least-privilege IAM roles
- Terraform remote backend with locking
- No credentials stored in GitHub

---

## 📁 Repository Structure

See [docs/code_structure.md](docs/code_structure.md)

---

## 🧪 Local Development

```bash
cd infra/terraform
terraform init
terraform plan
