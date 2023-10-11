# Create the ACM certificate for the custom domain and subdomain
resource "aws_acm_certificate" "acm_certificate" {
  depends_on                = [aws_route53_zone.hosted_zone]
  domain_name               = var.domain_name
  subject_alternative_names = ["${var.subdomain}.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true # Allows for certificate replacement without downtime
  }
}

# Track the ACM validation status before proceeding with other resources
resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn = aws_acm_certificate.acm_certificate.arn
}

/*
The aws_acm_certificate_validation resource is used to track the validation status and ensure that
validation is successful before proceeding with other resource creation or updates
that depend on the certificate being validated.
*/