# API Gateway v2 (HTTP API)
resource "aws_apigatewayv2_api" "HTTP_API" {
  name          = "http-api-${var.environment}"
  protocol_type = "HTTP"
  description   = "HTTP API Gateway for Lambda integration"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_headers = ["*"]
  }

  tags = {
    Environment = var.environment
    Managed_by  = "terraform"
  }
}

# API Gateway Stages
resource "aws_apigatewayv2_stage" "default" {
  for_each = var.stages

  api_id      = aws_apigatewayv2_api.HTTP_API.id
  name        = each.value.name
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs[each.key].arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip            = "$context.identity.sourceIp"
      requestTime   = "$context.requestTime"
      httpMethod    = "$context.httpMethod"
      routeKey      = "$context.routeKey"
      status        = "$context.status"
      protocol      = "$context.protocol"
      responseTime  = "$context.responseLatency"
      responseLength = "$context.responseLength"
    })
  }

  tags = {
    Environment = each.value.name
    Stage      = each.value.name
    Managed_by = "terraform"
  }
}

# CloudWatch Log Groups for API Gateway
resource "aws_cloudwatch_log_group" "api_logs" {
  for_each = var.stages

  name              = "/aws/apigateway/${aws_apigatewayv2_api.HTTP_API.name}/${each.value.name}"
  retention_in_days = 7

  tags = {
    Environment = each.value.name
    Stage      = each.value.name
    Managed_by = "terraform"
  }
}

# Lambda Integration
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.HTTP_API.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.api_handler.invoke_arn
  payload_format_version = "2.0"
}

# Route
resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.HTTP_API.id
  route_key = "ANY /api/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Lambda permission for API Gateway
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.HTTP_API.execution_arn}/*/*"
}