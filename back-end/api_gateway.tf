resource "aws_api_gateway_rest_api" "CRC-api" {
  name        = "cloud-resume-challenge-API"
  description = "Public facing Rest API"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "CRC-api-resource" {
  rest_api_id = aws_api_gateway_rest_api.CRC-api.id
  parent_id   = aws_api_gateway_rest_api.CRC-api.root_resource_id
  path_part   = "crc"
}

# ---------------------------------------------------------------
# check
# Create Options method to enable CORS
resource "aws_api_gateway_method" "options_method" {
    rest_api_id   = aws_api_gateway_rest_api.CRC-api.id
    resource_id   = aws_api_gateway_resource.CRC-api-resource.id
    http_method   = "OPTIONS"
    authorization = "NONE"
}

# check
resource "aws_api_gateway_method_response" "options_200" {
    rest_api_id   = aws_api_gateway_rest_api.CRC-api.id
    resource_id   = aws_api_gateway_resource.CRC-api-resource.id
    http_method   = aws_api_gateway_method.options_method.http_method
    status_code   = "200"
    # here:
    response_models = {
        "application/json" = "Empty"
    }
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin" = true
    }
    # depends_on = [aws_api_gateway_method.options_method]
}

# check
resource "aws_api_gateway_integration" "options_integration" {
    rest_api_id   = aws_api_gateway_rest_api.CRC-api.id
    resource_id   = aws_api_gateway_resource.CRC-api-resource.id
    http_method   = aws_api_gateway_method.options_method.http_method
    integration_http_method = "OPTIONS"
    type          = "MOCK"
    request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
    # depends_on = [aws_api_gateway_method.options_method]
}

# check
resource "aws_api_gateway_integration_response" "options_integration_response" {
    rest_api_id   = aws_api_gateway_rest_api.CRC-api.id
    resource_id   = aws_api_gateway_resource.CRC-api-resource.id
    http_method   = aws_api_gateway_method.options_method.http_method
    status_code   = aws_api_gateway_method_response.options_200.status_code
    # Authorization,:
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'",
        "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,POST,PUT'",
        "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    # depends_on = [aws_api_gateway_method_response.options_200]
    depends_on = [
    aws_api_gateway_method.options_method,
    aws_api_gateway_integration.options_integration
  ]
}

# --------------------------------------------------------------
#check
resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.CRC-api.id
  resource_id   = aws_api_gateway_resource.CRC-api-resource.id
  # CHANGED HERE:
  http_method   = "GET"
  authorization = "NONE"
}

# check
resource "aws_api_gateway_method_response" "get_method_response_200" {
    rest_api_id   = aws_api_gateway_rest_api.CRC-api.id
    resource_id   = aws_api_gateway_resource.CRC-api-resource.id
    http_method   = aws_api_gateway_method.get_method.http_method
    status_code   = "200"

    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin"  = true
    }
    
    # response_models = {
    #     "application/json" = "Empty",
    # }
    # depends_on = [aws_api_gateway_method.get_method, aws_api_gateway_integration.api-lambda-integration]
}

# check
resource "aws_api_gateway_integration" "api-lambda-integration" {
  rest_api_id = aws_api_gateway_rest_api.CRC-api.id
  resource_id = aws_api_gateway_resource.CRC-api-resource.id
  http_method = aws_api_gateway_method.get_method.http_method
  # i just changed from GET:
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.CRC-lambda.invoke_arn
  
  # depends_on  = [aws_api_gateway_method.get_method, aws_api_gateway_method.options_method, aws_lambda_function.CRC-lambda]
}

# check
resource "aws_api_gateway_integration_response" "get_integration_response" {
    rest_api_id   = aws_api_gateway_rest_api.CRC-api.id
    resource_id   = aws_api_gateway_resource.CRC-api-resource.id
    http_method   = aws_api_gateway_method.get_method.http_method
    status_code   = aws_api_gateway_method_response.get_method_response_200.status_code
    # here:Authorization,
    response_parameters = {
       "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'",
       "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
       "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    # here:
    response_templates = {
      "application/json" = ""
    }
    depends_on = [aws_api_gateway_integration.api-lambda-integration, aws_api_gateway_method.get_method]
}

# check
resource "aws_api_gateway_deployment" "CRC-api-deploy" {
  rest_api_id = aws_api_gateway_rest_api.CRC-api.id
  stage_name  = "dev"

  depends_on = [
    aws_api_gateway_integration.api-lambda-integration,
    aws_api_gateway_integration.options_integration
  ]
  # lifecycle {
  #   create_before_destroy = true
  # }
}


