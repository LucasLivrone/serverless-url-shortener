# Create an S3 bucket
resource "aws_s3_bucket" "static_website" {
  bucket        = "serverless-url-shortener" # Bucket name must be unique
  force_destroy = true                       # This setting will allow Terraform to destroy the bucket even if it's not empty.

  tags = {
    Name = "serverless-url-shortener"
  }
}

# Specify website properties for the S3 Bucket
resource "aws_s3_bucket_website_configuration" "web_configuration" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.static_website.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Set bucket ownership controls to "BucketOwnerPreferred"
resource "aws_s3_bucket_ownership_controls" "bucket_ownership_controls" {
  bucket = aws_s3_bucket.static_website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Configure public access settings for the S3 bucket
resource "aws_s3_bucket_public_access_block" "bucket_public_access" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Set the ACL for the S3 bucket to allow public read access to objects
resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket_ownership_controls,
    aws_s3_bucket_public_access_block.bucket_public_access,
  ]

  bucket = aws_s3_bucket.static_website.id
  acl    = "public-read"
}

# Define a bucket policy that allows the get the objects from the S3 bucket
resource "aws_s3_bucket_policy" "bucket-policy" {
  depends_on = [
    aws_s3_bucket.static_website,
    aws_s3_bucket_acl.bucket_acl
  ]

  bucket = aws_s3_bucket.static_website.id

  policy = jsonencode(
    {
      "Id" : "Policy",
      "Statement" : [
        {
          "Action" : [
            "s3:GetObject"
          ],
          "Effect" : "Allow",
          "Resource" : "arn:aws:s3:::${aws_s3_bucket.static_website.bucket}/*",
          "Principal" : {
            "AWS" : [
              "*"
            ]
          }
        }
      ]
  })
}
