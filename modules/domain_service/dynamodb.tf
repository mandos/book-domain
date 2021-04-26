resource "aws_dynamodb_table" "this" {
  name             = "domains"
  hash_key         = "fqdn"
  billing_mode     = "PAY_PER_REQUEST"

  attribute {
    name = "fqdn"
    type = "S"
  }
}
