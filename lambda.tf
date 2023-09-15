data "archive_file" "lambda_functions_zip" {
  count       = length(var.lambda_functions)
  type        = "zip"
  source_file = "lambdas/${var.lambda_functions[count.index].name}.py"
  output_path = "${var.lambda_functions[count.index].name}.zip"
}

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