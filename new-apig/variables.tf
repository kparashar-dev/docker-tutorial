variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}

variable "stages" {
  description = "Stages to deploy the API"
  type        = map(object({
    name        = string
    description = string
  }))
  default = {
    dev = {
      name        = "dev"
      description = "Development Stage"
    }
    qa = {
      name        = "qa"
      description = "QA Stage"
    }
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}