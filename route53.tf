# Create a Route 53 hosted zone
resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

/*
# Create an A record for the root domain
resource "aws_route53_record" "root_domain" {
  zone_id = aws_route53_zone.my_domain.zone_id
  name    = "@"  # Set the name to "@" for the apex/root of the domain
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.cloudfront_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
# The A record for the root domain is typically used if you want users to access your website using the bare domain (e.g., "lucaslivrone.tech") without any subdomain.
*/


# Create a CNAME record for the subdomain
resource "aws_route53_record" "serverless_subdomain" {
  name    = var.subdomain
  zone_id = aws_route53_zone.hosted_zone.zone_id
  type    = "CNAME"
  ttl     = 300
  records = [aws_cloudfront_distribution.cloudfront_distribution.domain_name]
}

# Create DNS records for ACM certificate validation for each domain_validation_options
resource "aws_route53_record" "acm_certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = aws_route53_zone.hosted_zone.zone_id
}
