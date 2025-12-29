terraform {
  backend "s3" {
    bucket         = "health-aws-data-engineer-project-terraform-state"
    key            = "terraform/health-pipeline.tfstate"
    region         = "us-east-1"
    dynamodb_table = "health-aws-data-engineer-project-terraform-locks"
    encrypt        = true
  }
}
