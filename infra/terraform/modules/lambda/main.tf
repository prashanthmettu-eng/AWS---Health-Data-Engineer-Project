/*
  Lambda module
  - Packages a single Python file into a ZIP
  - Deploys it as an AWS Lambda
  - Automatically updates Lambda code when .py file changes
*/

resource "random_id" "suffix" {
  byte_length = 3
}

locals {
  lambda_zip_name = "${var.function_name}-${random_id.suffix.hex}.zip"
  lambda_zip_path = "${path.module}/build/${local.lambda_zip_name}"
}

# Package the Lambda source file into a zip
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = var.source_file
  output_path = local.lambda_zip_path
}

resource "aws_lambda_function" "lambda" {
  function_name = "${var.function_name}-${random_id.suffix.hex}"
  role          = var.role_arn
  handler       = var.handler
  runtime       = "python3.9"

  # Lambda deployment package
  filename         = data.archive_file.lambda_zip.output_path

  # 🔑 CRITICAL:
  # Forces Lambda to update when Python file changes
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = var.environment_variables
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
