# Use S3 backend for storing the State file and State lock
terraform {
  backend "s3" {}
}