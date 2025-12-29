resource "aws_s3_bucket" "code_bucket" {
  bucket = "${var.project_name}-code-${random_id.bucket_suffix.hex}"
  acl    = "private"

  tags = {
    Name        = "${var.project_name}-code"
    Environment = var.environment
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}