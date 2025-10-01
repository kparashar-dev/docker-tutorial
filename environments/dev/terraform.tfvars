# Environment-specific variables for dev environment

environment = "dev"
project_name = "api-gateway-poc"
aws_region = "us-west-2"

# API Gateway Configuration
api_gateway_stage_name = "dev"
enable_api_gateway_logging = true
enable_api_gateway_metrics = true

# Lambda Configuration
lambda_runtime = "nodejs14.x"
lambda_timeout = 30
lambda_memory_size = 128

# JWT Configuration
jwt_secret = "your-dev-secret-key"  # In production, use AWS Secrets Manager

# Domain Configuration
domain_name = "api-dev.example.com"
certificate_arn = "arn:aws:acm:us-west-2:123456789012:certificate/abc123"

# Monitoring Configuration
enable_xray_tracing = true