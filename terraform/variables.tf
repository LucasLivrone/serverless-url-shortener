variable "aws_region" {
  description = "AWS region where the resources are going the be provisioned."
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Domain name for the Hosted Zone created by Route 53"
  type        = string
}

variable "subdomain" {
  description = "Subdomain of the Hosted Zone that will point to the CloudFront domain"
  type        = string
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

variable "tf_state_backend_bucket" {
  description = "The name of the S3 bucket where the Terraform state files will be stored"
  type        = string
}

variable "tf_state_backend_key" {
  description = "The key (object key) in the S3 bucket where the Terraform state file is stored"
  type        = string
}

variable "tf_state_lock" {
  description = "DynamoDB table to use for state locking"
  type        = string
}
