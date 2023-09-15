variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "lambda_functions" {
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