# Variables for API Gateway module
variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "authorizer_invoke_arn" {
  description = "ARN for invoking the Lambda authorizer"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "ARN for invoking the main Lambda function"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the main Lambda function"
  type        = string
}

variable "stage_name" {
  description = "Name of the API Gateway stage"
  type        = string
  default     = "dev"
}