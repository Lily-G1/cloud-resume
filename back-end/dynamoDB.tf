# Create dynamoDB table
resource "aws_dynamodb_table" "CRC-DB" {
  name           = "cloud-resume-challenge-DB"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  } 

  tags = {
    Name        = "dynamodb-table"
    Environment = var.aws_environment
  }
}


# Create table items
resource "aws_dynamodb_table_item" "CRC-DB-items" {
  table_name = aws_dynamodb_table.CRC-DB.name
  hash_key   = aws_dynamodb_table.CRC-DB.hash_key

  item = <<ITEM
{
  "id": {"S": "001"},
  "views_count": {"N": "1"}
}
ITEM
}