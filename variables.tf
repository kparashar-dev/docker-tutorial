variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment (dev/staging/prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "authorizer_zip_path" {
  description = "Path to the Lambda authorizer ZIP file"
  type        = string
}

variable "api_handler_zip_path" {
  description = "Path to the API handler Lambda ZIP file"
  type        = string
}

variable "jwt_secret" {
  description = "Secret for JWT token validation"
  type        = string
  sensitive   = true
}