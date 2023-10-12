# Use S3 backend for storing the State file and State lock
terraform {
  backend "s3" {
    bucket         = var.tf_state_backend_bucket
    key            = var.tf_state_backend_key
    region         = var.aws_region
    encrypt        = true
    dynamodb_table = var.tf_state_lock
  }
}