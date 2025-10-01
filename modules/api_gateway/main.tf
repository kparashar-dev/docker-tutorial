# API Gateway Module
# This module creates the API Gateway with Lambda Authorizer integration

# Create the API Gateway
resource "aws_api_gateway_rest_api" "main" {
  name = "${var.project_name}-api"
  description = "API Gateway with Lambda Authorizer"

  # Enable CORS
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Create API Gateway Authorizer
resource "aws_api_gateway_authorizer" "lambda_authorizer" {
  name                   = "lambda-authorizer"
  rest_api_id            = aws_api_gateway_rest_api.main.id
  authorizer_uri         = var.authorizer_invoke_arn
  authorizer_credentials = aws_iam_role.invocation_role.arn
  type                   = "TOKEN"
  identity_source        = "method.request.header.Authorization"
}

# Create API resource and method
resource "aws_api_gateway_resource" "example" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "example"
}

# HTTP GET method
resource "aws_api_gateway_method" "example_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.example.id
  http_method   = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.lambda_authorizer.id

  # Add request parameters if needed
  request_parameters = {
    "method.request.header.Authorization" = true
  }
}

# Integration with Lambda
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.example.id
  http_method = aws_api_gateway_method.example_get.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = var.lambda_invoke_arn
}

# Enable CORS
resource "aws_api_gateway_method" "options" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.example.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.example.id
  http_method = aws_api_gateway_method.options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# Deployment and Stage
resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_integration.options
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = var.stage_name
}

# IAM role for API Gateway to invoke Lambda
resource "aws_iam_role" "invocation_role" {
  name = "${var.project_name}-apigateway-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

# Permission for API Gateway to invoke Lambda
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

# Outputs
output "api_url" {
  value = "${aws_api_gateway_stage.example.invoke_url}/example"
}

output "rest_api_id" {
  value = aws_api_gateway_rest_api.main.id
}