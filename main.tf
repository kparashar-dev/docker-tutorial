# Main Terraform configuration file
# This file orchestrates the modules to create a complete API Gateway with Lambda Authorizer setup

provider "aws" {
  region = "us-west-2" # Change this to your desired region
}

# Project-wide variables
locals {
  project_name    = "demo-api"
  stage_name      = "dev"
  auth_token      = "your-secret-token" # In production, use AWS Secrets Manager
}

# Lambda Module
module "lambda" {
  source = "./modules/lambda"
  
  project_name       = local.project_name
  authorizer_zip_path = "./lambda/authorizer.zip"  # Create this ZIP file with your Lambda code
  api_handler_zip_path = "./lambda/api_handler.zip"  # Create this ZIP file with your Lambda code
  auth_token         = local.auth_token
}

# API Gateway Module
module "api_gateway" {
  source = "./modules/api_gateway"
  
  project_name          = local.project_name
  authorizer_invoke_arn = module.lambda.authorizer_function_arn
  lambda_invoke_arn     = module.lambda.api_handler_function_arn
  lambda_function_name  = module.lambda.api_handler_function_name
  stage_name           = local.stage_name
}

# Output the API URL
output "api_url" {
  value = module.api_gateway.api_url
  description = "API Gateway endpoint URL"
}