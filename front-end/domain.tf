# Create hosted zone
resource "aws_route53_zone" "my_zone" {
  name = var.domain_name
}

locals {
  record_types = toset(["A", "AAAA"])
}

# Create record
resource "aws_route53_record" "bare_record" {
  zone_id  = aws_route53_zone.my_zone.zone_id
  name     = var.domain_name
  for_each = local.record_types
  type     = each.value

  alias {
    name                   = aws_cloudfront_distribution.web_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.web_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

# Create record
resource "aws_route53_record" "www_record" {
  zone_id  = aws_route53_zone.my_zone.zone_id
  name     = "www.${var.domain_name}"
  for_each = local.record_types
  type     = each.value

  alias {
    name                   = aws_cloudfront_distribution.web_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.web_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

# Display NS records
output "name_servers" {
  value       = aws_route53_zone.my_zone.name_servers
  description = "records of domain name servers"
}