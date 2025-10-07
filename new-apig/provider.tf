terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "var.region" # Change this to your desired region
  alias  = "new_apig" # Alias for the new API Gateway provider
  
}