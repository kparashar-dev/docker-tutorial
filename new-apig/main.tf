resource "aws_apigatewayv2_api" "HTTP_API" {
  name          = "${var.environment}-http-api"
  description   = "HTTP API with Lambda Authorizer"   
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
    api_id           = aws_apigatewayv2_api.HTTP_API.id
    integration_type = "AWS_PROXY"
    integration_uri  = aws_lambda_function.my_lambda.arn
    integration_method = "POST"
    payload_format_version = "2.0"
}

#define api route
resource "aws_apigatewayv2_route" "api_route" {
    api_id    = aws_apigatewayv2_api.HTTP_API.id
    route_key = "GET /"
    target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

#deploy the api with dev stage
resource "aws_apigatewayv2_stage" "dev_stage" {
    api_id      = aws_apigatewayv2_api.HTTP_API.id
    name        = "dev"
    auto_deploy = true
}   




#grant permission to api gateway to invoke lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.HTTP_API.execution_arn}/*/*"
}

#IAM ROLE FOr lambdaexecution
resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.environment}-lambda-exec-role"

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

resource "aws_iam_role_policy_attachment" "lambda_basic_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  
}
# Lambda function
resource "aws_lambda_function" "my_lambda" {
  filename         = lambda.zip
  function_name    = "${var.environment}-my-lambda"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "index.handler"
  runtime          = "nodejs20.x"
  source_code_hash = filebase64sha256("lambda.zip")
}