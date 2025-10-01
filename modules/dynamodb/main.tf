# Module for DynamoDB table creation
# This module creates a DynamoDB table for storing items

resource "aws_dynamodb_table" "items" {
  name           = "${var.project_name}-items-${var.environment}"
  billing_mode   = "PAY_PER_REQUEST"  # Or "PROVISIONED" for production workloads
  hash_key       = "id"
  
  # Add sort key if needed for your access patterns
  # range_key      = "created_at"

  attribute {
    name = "id"
    type = "S"
  }

  # Enable point-in-time recovery for production
  point_in_time_recovery {
    enabled = var.environment == "prod" ? true : false
  }

  # Enable server-side encryption
  server_side_encryption {
    enabled = true
  }

  # Add tags for better resource management
  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }

  # Add TTL if needed
  # ttl {
  #   attribute_name = "expiry_time"
  #   enabled        = true
  # }
}

# Optional: Add Global Secondary Indexes if needed
# resource "aws_dynamodb_table_global_secondary_index" "example" {
#   table_name            = aws_dynamodb_table.items.name
#   name                  = "GSI1"
#   hash_key             = "gsi_hash_key"
#   projection_type      = "ALL"
# }

# IAM role for Lambda to access DynamoDB
resource "aws_iam_role_policy" "dynamodb_access" {
  name = "${var.project_name}-dynamodb-access"
  role = var.lambda_role_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          aws_dynamodb_table.items.arn,
          "${aws_dynamodb_table.items.arn}/index/*"
        ]
      }
    ]
  })
}