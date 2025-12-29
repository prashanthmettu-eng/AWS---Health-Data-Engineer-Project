output "lambda_arn" {
  value       = aws_lambda_function.lambda.arn
  description = "ARN of the deployed lambda"
}

output "function_name" {
  value       = aws_lambda_function.lambda.function_name
  description = "Name of the deployed lambda"
}
