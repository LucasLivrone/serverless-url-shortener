resource "aws_dynamodb_table" "urls_db" {
  name         = "urls-db"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "keyword"

  attribute {
    name = "keyword"
    type = "S"
  }

  tags = {
    Name = "urls-db"
  }
}