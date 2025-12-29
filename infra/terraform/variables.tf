variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
  default     = "health-aws-data-engineer-project"
}

variable "environment" {
  description = "Environment tag (dev/test/prod)"
  type        = string
  default     = "dev"
}
