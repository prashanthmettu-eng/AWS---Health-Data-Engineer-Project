terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    archive = {
      source = "hashicorp/archive"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "aws" {
  region = var.aws_region
}




# IAM role placeholder for Glue / Lambda (fill policies later)
# resource "aws_iam_role" "glue_service_role" {
#   name = "${var.project_name}-glue-role"
#   assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json
# }

# (Optional) You can add more resources here: stepfunctions, glue jobs, lambda functions, rds, etc.

