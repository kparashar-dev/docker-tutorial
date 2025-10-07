# IAM Role for API Gateway CloudWatch Logging
resource "aws_iam_role" "apigateway_cloudwatch" {
  name = "api-gateway-cloudwatch-${var.environment}"

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

# IAM Policy for API Gateway CloudWatch Logging
resource "aws_iam_role_policy" "apigateway_cloudwatch" {
  name = "api-gateway-cloudwatch-${var.environment}"
  role = aws_iam_role.apigateway_cloudwatch.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# API Gateway Account Settings
resource "aws_api_gateway_account" "this" {
  cloudwatch_role_arn = aws_iam_role.apigateway_cloudwatch.arn
}