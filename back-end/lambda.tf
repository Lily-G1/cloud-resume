data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "index.py"
  output_path = "index.zip"
}

# Create lambda function's role
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Create policy to give lambda function access to dynamoDB table
resource "aws_iam_policy" "dynamodb_access_policy" {
  name        = "dynamodb_access_policy"
  description = "policy for accessing dynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
        ],
        Effect   = "Allow",
        Resource = aws_dynamodb_table.CRC-DB.arn,
      }
    ]
  })
  depends_on = [aws_dynamodb_table.CRC-DB]
}

# Attach policy to lambda's role. I just tried this:
resource "aws_iam_role_policy_attachment" "lambda_basic_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Attach policy to lambda's role
resource "aws_iam_role_policy_attachment" "lambda_db_policy_attachment" {
  policy_arn = aws_iam_policy.dynamodb_access_policy.arn
  role       = aws_iam_role.lambda_role.name
}

# # Zip lambda code
# data "archive_file" "zip_python_code" {
# type        = "zip"
# source_dir  = "lambda_function"
# output_path = "lambda_function/crc-python.zip"
# }

# Create lambda function with role
resource "aws_lambda_function" "CRC-lambda" {
  function_name = "cloud-resume-challenge-function"
  filename      = "index.zip"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.lambda_handler"
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
#   source_code_hash = filebase64sha256("lambda_function.zip")
  runtime = "python3.11"
  # depends_on = [aws_dynamodb_table.CRC-DB]
}

# Give permission to access/invoke lambda function
resource "aws_lambda_permission" "api-gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.CRC-lambda.function_name
  principal     = "apigateway.amazonaws.com"
  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.CRC-api.execution_arn}/*/GET/crc"

  # source_arn = "${aws_api_gateway_rest_api.CRC-api.execution_arn}/*/*"
}