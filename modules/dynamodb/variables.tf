variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "environment" {
  description = "Environment (dev/staging/prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "lambda_role_id" {
  description = "IAM role ID for Lambda functions"
  type        = string
}

# Optional: Add variables for table configuration
variable "enable_point_in_time_recovery" {
  description = "Enable point-in-time recovery for DynamoDB table"
  type        = bool
  default     = false
}

variable "enable_server_side_encryption" {
  description = "Enable server-side encryption for DynamoDB table"
  type        = bool
  default     = true
}