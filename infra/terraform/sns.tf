# SNS topics for pipeline notifications

resource "aws_sns_topic" "pipeline_success" {
  name = "${var.project_name}-pipeline-success"
}

resource "aws_sns_topic" "pipeline_failure" {
  name = "${var.project_name}-pipeline-failure"
}