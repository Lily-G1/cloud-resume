resource "aws_s3_bucket" "logs_bucket" {
  bucket        = "logs.www.${var.domain_name}"
  force_destroy = true

  tags = {
    project     = var.project_name
    environment = var.environment
  }
}

resource "aws_s3_bucket_ownership_controls" "logs_bucket_ownership" {
  bucket = aws_s3_bucket.logs_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "logs_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.logs_bucket_ownership]
  bucket = aws_s3_bucket.logs_bucket.id
  acl    = "private"
}