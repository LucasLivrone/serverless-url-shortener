variable "aws_region" {
  description = "AWS region where the resources are going the be provisioned."
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the Hosted Zone created by Route 53"
}

variable "subdomain" {
  type        = string
  description = "Subdomain of the Hosted Zone that will point to the CloudFront domain"
}

variable "lambda_functions" {
  description = "Details of the required Lambda functions and their expected API Gateway route"

  type = list(object({
    name        = string
    description = string
    route_key   = string
  }))

  default = [
    {
      name        = "add_url_pair"
      description = "Adds a new URL pair into the database"
      route_key   = "POST /add-url-pair"
    },
    {
      name        = "delete_url_pair"
      description = "Deletes a specified URL pair from the database"
      route_key   = "POST /delete-url-pair"
    },
    {
      name        = "redirect"
      description = "Redirects to the Full URL from a keyword"
      route_key   = "GET /{keyword}"
    }
  ]
}