# ARN for dynamoDB table
output "ddb_table_arn" {
  value       = aws_dynamodb_table.CRC-DB.arn
#   depends_on  = []
}

# ARN for lambda function
output "lambda_function_arn" {
  value = aws_lambda_function.CRC-lambda.arn
}

# API Gateway's Invoke URL
output "api_url" {
  value = aws_api_gateway_deployment.CRC-api-deploy.invoke_url
}

output "api-gw_arn" {
  value       = aws_api_gateway_rest_api.CRC-api.execution_arn
}
