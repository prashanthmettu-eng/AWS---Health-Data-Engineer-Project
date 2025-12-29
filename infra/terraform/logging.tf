resource "aws_cloudwatch_log_resource_policy" "stepfunctions_logs_policy" {
  policy_name = "${var.project_name}-stepfunctions-logs-policy"

  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowStepFunctionsToWriteLogs"
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.stepfunctions_logs.arn}:*"
      }
    ]
  })
}
