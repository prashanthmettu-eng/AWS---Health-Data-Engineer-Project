resource "aws_cloudwatch_event_rule" "health_pipeline_schedule" {
  name        = "${var.project_name}-pipeline-schedule"
  description = "Once in 3 months trigger for healthcare data pipeline"

  schedule_expression = "cron(0/5 * * * ? *)" 
  # schedule_expression = "cron(0 1 * * ? *)"
  # schedule_expression = "cron(0 1 1 */3 ? *)"
  
  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_cloudwatch_event_target" "health_pipeline_target" {
  rule      = aws_cloudwatch_event_rule.health_pipeline_schedule.name
  target_id = "health-pipeline-stepfunctions"

  arn      = aws_sfn_state_machine.health_pipeline.arn
  role_arn = aws_iam_role.eventbridge_stepfunctions_role.arn

  input = jsonencode({})
}
