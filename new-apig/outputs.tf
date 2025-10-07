output "http_api_urls" {
  description = "HTTP API Gateway Invoke URLs for all stages"
  value = {
    for stage_key, stage in aws_apigatewayv2_stage.default : stage_key => "${aws_apigatewayv2_api.HTTP_API.api_endpoint}/${stage.name}"
  }
}

output "rest_api_urls" {
  description = "REST API Gateway Invoke URLs for all stages"
  value = {
    for stage_key, stage in aws_api_gateway_stage.rest_api : stage_key => "${stage.invoke_url}/api"
  }
}