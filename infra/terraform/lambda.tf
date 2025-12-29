###############################################################
# LAMBDA MODULE CALLS (start job, check status, sns notifiers)
###############################################################

module "lambda_start_glue_job" {
  source        = "./modules/lambda"
  function_name = "${var.project_name}-start-glue-job"
  source_file   = "${path.module}/../../src/lambda/start_glue_job.py"
  handler       = "start_glue_job.lambda_handler"
  role_arn      = aws_iam_role.lambda_exec_role.arn

  project_name = var.project_name
  environment  = var.environment
}

module "lambda_check_glue_status" {
  source        = "./modules/lambda"
  function_name = "${var.project_name}-check-glue-status"
  source_file   = "${path.module}/../../src/lambda/check_glue_job_status.py"
  handler       = "check_glue_job_status.lambda_handler"
  role_arn      = aws_iam_role.lambda_exec_role.arn

  project_name = var.project_name
  environment  = var.environment
}

module "lambda_notify_success" {
  source        = "./modules/lambda"
  function_name = "${var.project_name}-notify-success"
  source_file   = "${path.module}/../../src/lambda/sns_notify_success.py"
  handler       = "sns_notify_success.lambda_handler" # update later
  role_arn      = aws_iam_role.lambda_exec_role.arn

  project_name = var.project_name
  environment  = var.environment
}

module "lambda_notify_failure" {
  source        = "./modules/lambda"
  function_name = "${var.project_name}-notify-failure"
  source_file   = "${path.module}/../../src/lambda/sns_notify_failure.py"
  handler       = "sns_notify_failure.lambda_handler" # update later
  role_arn      = aws_iam_role.lambda_exec_role.arn

  project_name = var.project_name
  environment  = var.environment
}
