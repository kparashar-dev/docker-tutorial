# Lambda Authorizer Function
resource "aws_lambda_function" "authorizer" {
  filename         = data.archive_file.authorizer_zip.output_path
  source_code_hash = data.archive_file.authorizer_zip.output_base64sha256
  function_name    = "api-authorizer-${var.environment}"
  role            = aws_iam_role.lambda_role.arn
  handler         = "authorizer.handler"
  runtime         = "nodejs20.x"

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }

  tags = {
    Environment = var.environment
    Managed_by  = "terraform"
  }
}

# Create ZIP file for Authorizer Lambda
data "archive_file" "authorizer_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/authorizer.js"
  output_path = "${path.module}/authorizer.zip"
}

# API Gateway Authorizer
resource "aws_api_gateway_authorizer" "lambda_authorizer" {
  name                             = "lambda-authorizer-${var.environment}"
  rest_api_id                      = aws_api_gateway_rest_api.rest_api.id
  authorizer_uri                   = aws_lambda_function.authorizer.invoke_arn
  authorizer_credentials           = aws_iam_role.authorizer_invocation.arn
  type                            = "REQUEST"
  authorizer_result_ttl_in_seconds = 300

  identity_source = "method.request.header.Authorization"
}

# IAM Role for API Gateway to invoke Lambda Authorizer
resource "aws_iam_role" "authorizer_invocation" {
  name = "api-gateway-auth-invocation-${var.environment}"

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

  tags = {
    Environment = var.environment
    Managed_by  = "terraform"
  }
}

# IAM Policy for API Gateway to invoke Lambda Authorizer
resource "aws_iam_role_policy" "authorizer_invocation" {
  name = "api-gateway-auth-invocation-${var.environment}"
  role = aws_iam_role.authorizer_invocation.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "lambda:InvokeFunction"
        Resource = aws_lambda_function.authorizer.arn
      }
    ]
  })
}

# Lambda permission for API Gateway to invoke Authorizer
resource "aws_lambda_permission" "authorizer" {
  statement_id  = "AllowAPIGatewayInvokeAuthorizer"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.authorizer.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*"
}