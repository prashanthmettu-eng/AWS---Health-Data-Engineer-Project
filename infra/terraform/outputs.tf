output "s3_code_bucket" {
  value = data.aws_s3_bucket.code_bucket.bucket
}

output "sns_success_arn" {
  description = "SNS topic ARN for pipeline success"
  value       = aws_sns_topic.pipeline_success.arn
}

output "sns_failure_arn" {
  description = "SNS topic ARN for pipeline failure"
  value       = aws_sns_topic.pipeline_failure.arn
}
