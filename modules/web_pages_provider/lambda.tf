data "aws_iam_policy_document" "logging" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    actions = [
      "dynamodb:GetItem",
    ]
    resources = [var.dynamodb.arn]
  }
}

data "aws_iam_policy_document" "edge_lambda" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "edge_lambda" {
  name = "CustomWebPagesProvider"

  assume_role_policy = data.aws_iam_policy_document.edge_lambda.json
  inline_policy {
    name   = "logging"
    policy = data.aws_iam_policy_document.logging.json
  }
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/edge_lambda/lambda_function.py"
  output_path = "build/lambda.zip"
}

resource "aws_lambda_function" "edge_lambda" {
  filename      = "build/lambda.zip"
  function_name = "DomainSwitcher"
  handler       = "lambda_function.lambda_handler"
  publish       = true
  role          = aws_iam_role.edge_lambda.arn

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.8"

  provider = aws.edge_lambda
}
