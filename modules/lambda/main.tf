# Lambda Function Module
# This module creates the Lambda functions for both the authorizer and the main API handler

# Lambda role for execution permissions
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role"

  # Trust relationship policy for Lambda service
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Authorizer Function
resource "aws_lambda_function" "authorizer" {
  filename         = var.authorizer_zip_path
  function_name    = "${var.project_name}-authorizer"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "nodejs14.x"
  
  environment {
    variables = {
      AUTH_TOKEN = var.auth_token # Demo purposes only - in production, use AWS Secrets Manager
    }
  }
}

# Main API Lambda Function
resource "aws_lambda_function" "api_handler" {
  filename         = var.api_handler_zip_path
  function_name    = "${var.project_name}-api-handler"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "nodejs14.x"
}

# Outputs to be used by other modules
output "authorizer_function_arn" {
  value = aws_lambda_function.authorizer.arn
}

output "api_handler_function_arn" {
  value = aws_lambda_function.api_handler.arn
}

output "api_handler_function_name" {
  value = aws_lambda_function.api_handler.function_name
}