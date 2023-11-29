resource "aws_cloudfront_origin_access_control" "bucket_access_policy" {
  name                              = "allow_to_s3"
  description                       = "Allows access to S3 web bucket from CloudFront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
  depends_on = [aws_acm_certificate.certificate, aws_route53_record.certificate_validation, aws_acm_certificate_validation.certificate_validation]
}

resource "aws_cloudfront_distribution" "web_distribution" {
  depends_on = [aws_acm_certificate.certificate, aws_route53_record.certificate_validation, aws_acm_certificate_validation.certificate_validation, aws_cloudfront_origin_access_control.bucket_access_policy]

  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.bucket_access_policy.id
    origin_id                = aws_s3_bucket.website_bucket.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for website"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "logs.www.${var.domain_name}.s3.amazonaws.com"
  }

  aliases = [var.domain_name, "www.${var.domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.website_bucket.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # For this lab, we only deploy to minimal regions.
  # price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"

  }

  tags = {
    project     = var.project_name
    environment = var.environment
  }

}