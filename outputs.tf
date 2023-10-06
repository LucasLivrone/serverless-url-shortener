output "cloudfront_domain_name" {
  value       = "https://${aws_cloudfront_distribution.cloudfront_distribution.domain_name}"
  description = "URL of the serverless-url-shortener application."
}