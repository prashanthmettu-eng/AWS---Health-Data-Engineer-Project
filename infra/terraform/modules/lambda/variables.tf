variable "function_name" {
  description = "Name prefix of the Lambda function"
  type        = string
}

variable "source_file" {
  description = "Path to the lambda .py file to package"
  type        = string
}

variable "handler" {
  description = "Lambda handler, e.g. file.lambda_handler"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN for the Lambda function"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "environment" {
  description = "Environment tag"
  type        = string
}

