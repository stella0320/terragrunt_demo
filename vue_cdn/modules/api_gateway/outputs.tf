output "invoke_url" {
  value = aws_apigatewayv2_api.this.api_endpoint
}
output "api_gateway_id" {
  value = aws_apigatewayv2_api.this.id
}
output "api_gateway_arn" {
  value = aws_apigatewayv2_api.this.arn
}

output "api_gateway_stage_name" {
  value = aws_apigatewayv2_stage.this.name
}
