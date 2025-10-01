output "table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.items.arn
}

output "table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.items.name
}

output "table_stream_arn" {
  description = "ARN of the DynamoDB table's stream (if enabled)"
  value       = aws_dynamodb_table.items.stream_arn
}