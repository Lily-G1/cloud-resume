resource "aws_s3_bucket" "website_bucket" {
  bucket = "www.${var.domain_name}"

  tags = {
    project     = var.project_name
    environment = var.environment
  }
}

resource "aws_s3_bucket_ownership_controls" "website_bucket_ownership" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# resource "aws_s3_bucket_website_configuration" "website_bucket_config" {
#   bucket = aws_s3_bucket.website_bucket.bucket

#   index_document {
#     suffix = "index.html"
#   }

#   error_document {
#     key = "error.html"
#   }

# }
locals {
  content_type_map = {
   "js" = "application/javascript"
   "html" = "text/html"
   "css"  = "text/css"
   "png"  = "image/png"
   "jpg"  = "image/jpeg"
  }
}

resource "aws_s3_object" "site" {
  bucket       = aws_s3_bucket.website_bucket.bucket
  for_each     = fileset("./site_files/", "**/*")
  key          = each.value
  source       = "./site_files/${each.value}"
  content_type = lookup(local.content_type_map, split(".", "${each.value}")[1], "text/html")
  # content_type = "text/html"
  etag         = filemd5("./site_files/${each.value}")
}

# resource "aws_s3_object" "site" {
#   bucket       = aws_s3_bucket.website_bucket.bucket
#   for_each     = fileset("./site_files/", "**")
#   key          = each.value
#   source       = "./site_files/${each.value}"
#   content_type = "text/html"
#   etag         = filemd5("./site_files/${each.value}")
# }

# resource "aws_s3_bucket_acl" "website_bucket_acl" {
#   depends_on = [aws_s3_bucket_ownership_controls.website_bucket_ownership]
#   bucket = aws_s3_bucket.website_bucket.id
#   acl    = "private"
# }

data "aws_iam_policy_document" "allow_access_from_cloud_front" {
  version = "2012-10-17"

  statement {
    sid = "PolicyForCloudFrontPrivateContent"
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.website_bucket.arn}/*",
    ]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.web_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_cloud_front" {
  bucket = aws_s3_bucket.website_bucket.bucket
  policy = data.aws_iam_policy_document.allow_access_from_cloud_front.json
}