# IAM role for AWS Lambda
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam-for-lambda"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# Attach AWS Lambda basic execution policy to IAM role
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# IAM policy allowing DynamoDB access for Lambda
resource "aws_iam_role_policy" "dynamodb_lambda_policy" {
  name = "dynamodb-lambda-policy"
  role = aws_iam_role.iam_for_lambda.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["dynamodb:*"],
        "Resource" : aws_dynamodb_table.urls_db.arn
      }
    ]
  })
}