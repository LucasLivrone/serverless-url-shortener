# Use S3 backend for storing the State file and State lock
# Since variables cannot be used while defining this block, required details will be located at backend-config.tf
# Required startup command: terraform init -backend-config=backend-config.tf
terraform {
  backend "s3" {}
}