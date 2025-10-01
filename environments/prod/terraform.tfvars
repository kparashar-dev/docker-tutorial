# Environment-specific variables for production environment

environment = "prod"
project_name = "api-gateway-poc"
aws_region = "us-west-2"

# API Gateway Configuration
api_gateway_stage_name = "prod"
enable_api_gateway_logging = true
enable_api_gateway_metrics = true

# Lambda Configuration
lambda_runtime = "nodejs14.x"
lambda_timeout = 30
lambda_memory_size = 256

# JWT Configuration
jwt_secret = "your-prod-secret-key"  # In production, use AWS Secrets Manager

# Domain Configuration
domain_name = "api.example.com"
certificate_arn = "arn:aws:acm:us-west-2:123456789012:certificate/def456"

# WAF Configuration
enable_waf = true
waf_rule_rate_limit = 2000

# Monitoring Configuration
enable_xray_tracing = true
alarm_evaluation_periods = 2
alarm_threshold = 90