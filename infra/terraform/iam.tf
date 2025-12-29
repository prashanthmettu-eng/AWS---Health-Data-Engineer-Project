/*
  infra/terraform/iam.tf

  Minimal IAM roles and inline policies for:
  - Glue service role (Glue jobs)
  - Lambda execution role (start/check Glue jobs, publish SNS)

  NOTE: These policies are intentionally readable and slightly permissive for a dev environment.
  For production, restrict actions to specific ARNs (bucket, topics, job names).
*/

data "aws_iam_policy_document" "glue_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "glue_service_role" {
  name               = "${var.project_name}-glue-role"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

data "aws_iam_policy_document" "glue_policy" {
  statement {
    sid    = "S3Access"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:DeleteObject"
    ]
    resources = [
      aws_s3_bucket.code_bucket.arn,
      "${aws_s3_bucket.code_bucket.arn}/*"
    ]
  }

  statement {
    sid    = "GlueCatalogAndJobs"
    effect = "Allow"
    actions = [
      "glue:GetJob",
      "glue:GetJobRun",
      "glue:StartJobRun",
      "glue:GetTable",
      "glue:GetDatabase",
      "glue:CreatePartition",
      "glue:GetPartitions"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "CloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    sid    = "GlueCatalogAccess"
    effect = "Allow"
    actions = [
      "glue:CreateDatabase",
      "glue:GetDatabase",
      "glue:UpdateDatabase",
      "glue:CreateTable",
      "glue:GetTable",
      "glue:UpdateTable",
      "glue:DeleteTable",
      "glue:BatchCreatePartition",
      "glue:CreatePartition",
      "glue:GetPartition",
      "glue:GetPartitions",
      "glue:BatchGetPartition",
      "glue:UpdatePartition"
    ]
    resources = ["*"]
  }

}

resource "aws_iam_role_policy" "glue_service_policy_attach" {
  name   = "${var.project_name}-glue-inline-policy"
  role   = aws_iam_role.glue_service_role.id
  policy = data.aws_iam_policy_document.glue_policy.json
}

# ---------------------------
# Lambda execution role
# ---------------------------

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name               = "${var.project_name}-lambda-exec-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Allow Lambda to start and monitor Glue jobs
resource "aws_iam_role_policy" "lambda_glue_permissions" {
  name = "lambda-glue-start-policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "glue:StartJobRun",
          "glue:GetJobRun",
          "glue:GetJobRuns"
        ]
        Resource = "*"
      }
    ]
  })
}


data "aws_iam_policy_document" "lambda_policy" {
  statement {
    sid    = "LambdaS3Read"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.code_bucket.arn,
      "${aws_s3_bucket.code_bucket.arn}/*"
    ]
  }

  statement {
    sid    = "LambdaGlueStart"
    effect = "Allow"
    actions = [
      "glue:StartJobRun",
      "glue:GetJobRun",
      "glue:GetJobRuns"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "LambdaSNSPublish"
    effect = "Allow"
    actions = [
      "sns:Publish"
    ]
    resources = [
      aws_sns_topic.pipeline_success.arn,
      aws_sns_topic.pipeline_failure.arn
    ]
  }

  statement {
    sid    = "LambdaCloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role_policy" "lambda_inline_policy_attach" {
  name   = "${var.project_name}-lambda-inline-policy"
  role   = aws_iam_role.lambda_exec_role.id
  policy = data.aws_iam_policy_document.lambda_policy.json
}

# ---------------------------
# Step Functions execution role
# ---------------------------

data "aws_iam_policy_document" "stepfunctions_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "stepfunctions_role" {
  name               = "${var.project_name}-stepfunctions-role"
  assume_role_policy = data.aws_iam_policy_document.stepfunctions_assume_role.json

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

data "aws_iam_policy_document" "stepfunctions_policy" {
  # Invoke Lambdas
  statement {
    sid = "AllowInvokeLambda"
    actions = [
      "lambda:InvokeFunction",
      "lambda:InvokeAsync"
    ]
    resources = ["*"]
  }

  # Publish SNS notifications
  statement {
    sid = "AllowSNSPublish"
    actions = [
      "sns:Publish"
    ]
    resources = [
      aws_sns_topic.pipeline_success.arn,
      aws_sns_topic.pipeline_failure.arn
    ]
  }

  # REQUIRED for Step Functions logging
  statement {
    sid = "AllowCloudWatchLogs"
    actions = [
      "logs:CreateLogDelivery",
      "logs:GetLogDelivery",
      "logs:UpdateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutResourcePolicy",
      "logs:DescribeResourcePolicies",
      "logs:DescribeLogGroups"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "stepfunctions_inline_policy" {
  name   = "${var.project_name}-stepfunctions-policy"
  role   = aws_iam_role.stepfunctions_role.id
  policy = data.aws_iam_policy_document.stepfunctions_policy.json
}

# ---------------------------
# EventBridge to Step Functions role
# --------------------------- 
resource "aws_iam_role" "eventbridge_stepfunctions_role" {
  name = "${var.project_name}-eventbridge-sfn-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "eventbridge_stepfunctions_policy" {
  role = aws_iam_role.eventbridge_stepfunctions_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "states:StartExecution"
        Resource = aws_sfn_state_machine.health_pipeline.arn
      }
    ]
  })
}

############################################
# GitHub OIDC Provider
############################################
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

############################################
# IAM Role for GitHub Actions (Terraform CI/CD)
############################################
resource "aws_iam_role" "github_actions_terraform" {
  name = "${var.project_name}-github-actions-terraform-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:prashanthmettu-eng/AWS---Health-Data-Engineer-Project:*"
          }
        }
      }
    ]
  })

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

############################################
# Terraform Permissions Policy
############################################
resource "aws_iam_policy" "terraform_ci_policy" {
  name = "${var.project_name}-terraform-ci-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # -------------------------
      # Terraform backend (S3)
      # -------------------------
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketPolicy",
          "s3:GetBucketVersioning",
          "s3:GetEncryptionConfiguration",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::health-aws-data-engineer-project-terraform-state",
          "arn:aws:s3:::health-aws-data-engineer-project-terraform-state/*"
        ]
      },

      # -------------------------
      # Terraform state locking (DynamoDB)
      # -------------------------
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable",
          "dynamodb:DescribeContinuousBackups"
        ]
        Resource = "arn:aws:dynamodb:us-east-1:259242132172:table/health-aws-data-engineer-project-terraform-locks"
      },

      # -------------------------
      # Glue, Lambda, Step Functions, EventBridge
      # -------------------------
      {
        Effect = "Allow"
        Action = [
          "glue:*",
          "lambda:*",
          "states:*",
          "events:*",
          "logs:*",
          "sns:*",
          "cloudwatch:*",
          "iam:PassRole"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_attach" {
  role       = aws_iam_role.github_actions_terraform.name
  policy_arn = aws_iam_policy.terraform_ci_policy.arn
}
