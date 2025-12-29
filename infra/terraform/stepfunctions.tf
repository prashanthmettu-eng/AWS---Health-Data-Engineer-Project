###############################################################
# Step Functions State Machine
###############################################################

resource "aws_sfn_state_machine" "health_pipeline" {
  name     = "${var.project_name}-state-machine"
  role_arn = aws_iam_role.stepfunctions_role.arn

  definition = templatefile("${path.module}/../../src/stepfunctions/state_machine_def.template.json",
    {
      lambda_start_arn   = module.lambda_start_glue_job.lambda_arn
      lambda_check_arn   = module.lambda_check_glue_status.lambda_arn
      lambda_success_arn = module.lambda_notify_success.lambda_arn
      lambda_failure_arn = module.lambda_notify_failure.lambda_arn
    }
  )

  # ADDED THIS BLOCK
  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.stepfunctions_logs.arn}:*"
    include_execution_data = true
    level                  = "ALL"
  }

  # ADDED THIS BLOCK
  tracing_configuration {
    enabled = true
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_cloudwatch_log_group" "stepfunctions_logs" {
  name              = "/aws/stepfunctions/health-pipeline"
  retention_in_days = 14

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

