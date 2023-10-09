# CloudFront distribution for the API Gateway and S3 Static Website
resource "aws_cloudfront_distribution" "cloudfront_distribution" {

  enabled = true

  # List of alternate domain names (CNAMEs) to associate with the distribution
  aliases = ["${var.subdomain}.${var.domain_name}"]

  # Specify the SSL certificate ARN for the CNAMEs
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.acm_certificate_validation.certificate_arn
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # API Gateway
  origin {
    domain_name = "${aws_apigatewayv2_api.api_gw.id}.execute-api.${var.aws_region}.amazonaws.com"
    origin_id   = "api-gateway-origin"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "api-gateway-origin"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  # S3 Static Website
  origin {
    domain_name = aws_s3_bucket_website_configuration.web_configuration.website_endpoint
    origin_id   = "s3-origin"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  ordered_cache_behavior {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    path_pattern           = "/"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }


}

