# Create ZIP archives for Lambda functions' source code
data "archive_file" "lambda_functions_zip" {
  count       = length(var.lambda_functions)
  type        = "zip"
  source_file = "lambdas/${var.lambda_functions[count.index].name}.py"
  output_path = "${var.lambda_functions[count.index].name}.zip"
}

# Define AWS Lambda functions using ZIP archives as source code
resource "aws_lambda_function" "lambda_functions" {
  count            = length(var.lambda_functions)
  filename         = data.archive_file.lambda_functions_zip[count.index].output_path
  source_code_hash = data.archive_file.lambda_functions_zip[count.index].output_base64sha256
  role             = aws_iam_role.iam_for_lambda.arn
  function_name    = var.lambda_functions[count.index].name
  handler          = "${var.lambda_functions[count.index].name}.lambda_handler"
  runtime          = "python3.11"

  tags = {
    Name        = var.lambda_functions[count.index].name
    Description = var.lambda_functions[count.index].description
  }
}


# Create ZIP file for the Lambda@Edge function
data "archive_file" "lambda_edge" {
  type        = "zip"
  source_dir  = "lambdas/"
  output_path = "lambda_edge.zip"
}

# Define Lambda@Edge function using ZIP archive as source code
resource "aws_lambda_function" "lambda_edge" {
  function_name    = "lambda_edge"
  filename         = data.archive_file.lambda_edge.output_path
  source_code_hash = data.archive_file.lambda_edge.output_base64sha256
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "lambda_edge.lambda_handler"
  runtime          = "python3.11"
  publish          = true

  tags = {
    Name        = "lambda_edge"
    Description = "Translates /foo to /url-shortener/foo"
  }
}