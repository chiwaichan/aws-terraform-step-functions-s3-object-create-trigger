resource "aws_iam_role" "lambda_role_extract_using_textract" {
  name = "lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment_extract_using_textract" {
  role       = aws_iam_role.lambda_role_extract_using_textract.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip_extract_using_textract" {
  type        = "zip"
  source_file = "${path.module}/lambdas/extract-using-textract/index.py"
  output_path = "${path.module}/lambdas/extract-using-textract/index.zip"
}

resource "aws_lambda_function" "lambda_extract_using_textract" {
  filename         = data.archive_file.lambda_zip_extract_using_textract.output_path
  function_name    = "lambda_extract_using_textract"
  role             = aws_iam_role.lambda_role_extract_using_textract.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip_extract_using_textract.output_path)

  environment {
    variables = {
      ENV_VAR = "value"
    }
  }
}

output "lambda_function_arn" {
  value = aws_lambda_function.lambda_extract_using_textract.arn
}
