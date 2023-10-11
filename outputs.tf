output "serverless-url-shortener" {
  value = "https://${aws_route53_record.serverless_subdomain.fqdn}"
  description = "URL of the serverless-url-shortener application"
}