# Variables for Lambda module
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

variable "auth_token" {
  description = "Demo auth token for Lambda authorizer"
  type        = string
  sensitive   = true
}