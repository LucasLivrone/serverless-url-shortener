resource "aws_apigatewayv2_api" "api_gw" {
  name          = "url-shortener-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "api_gw_stage" {
  api_id      = aws_apigatewayv2_api.api_gw.id
  name        = "url-shortener"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.main_api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_cloudwatch_log_group" "main_api_gw" {
  name              = "/aws/api-gw/${aws_apigatewayv2_api.api_gw.name}"
  retention_in_days = 30
}

resource "aws_apigatewayv2_integration" "api_gw_integration" {
  count            = length(aws_lambda_function.lambda_functions)
  api_id           = aws_apigatewayv2_api.api_gw.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.lambda_functions[count.index].invoke_arn
}

resource "aws_apigatewayv2_route" "api_gw_route" {
  count     = length(var.lambda_functions)
  api_id    = aws_apigatewayv2_api.api_gw.id
  route_key = var.lambda_functions[count.index].route_key
  target    = "integrations/${aws_apigatewayv2_integration.api_gw_integration[count.index].id}"
}

resource "aws_lambda_permission" "lambda_permission" {
  count         = length(aws_lambda_function.lambda_functions)
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.lambda_functions[count.index].function_name
  source_arn    = "${aws_apigatewayv2_api.api_gw.execution_arn}/*/*"
}
