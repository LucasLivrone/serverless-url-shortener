variable "aws_region" {
  description = "AWS region where the resources are going the be provisioned."
  type        = string
  default     = "us-east-1"
}

variable "tf_state_backend_bucket" {
  description = "The name of the S3 bucket where the Terraform state files will be stored"
  type        = string
}

variable "tf_state_lock" {
  description = "DynamoDB table to use for state locking"
  type        = string
}
