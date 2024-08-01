provider "aws" {
  region = "ap-southeast-2"
}

# S3 Bucket
resource "aws_s3_bucket" "source_document_bucket" {
  bucket = "source-document-bucket-name-here"
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role_start_step_function_execution" {
  name = "lambda-s3-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

# IAM Policy for Lambda Role
resource "aws_iam_role_policy" "lambda_policy_step_function_execution" {
  name   = "lambda_policy_step_function_execution"
  role   = aws_iam_role.lambda_role_start_step_function_execution.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": "s3:*",
        "Resource": [
          aws_s3_bucket.source_document_bucket.arn,
          "${aws_s3_bucket.source_document_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Lambda Function
resource "aws_lambda_function" "lambda_start_step_function_execution" {
  function_name = "lambda_start_step_function_execution"
  role          = aws_iam_role.lambda_role_start_step_function_execution.arn
  handler       = "index.handler"
  runtime       = "python3.8"
  filename      = "lambdas/do-nothing-function.zip"  # Path to your Lambda deployment package

  environment {
    variables = {
      STEP_FUNCTIONS_ARN = aws_sfn_state_machine.document_processing_state_machine.arn
      ANOTHER_VARIABLE   = "value"
    }
  }
}

# S3 Bucket Notification
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.source_document_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_start_step_function_execution.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}

# Lambda Permission to allow S3 to invoke Lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3InvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_start_step_function_execution.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.source_document_bucket.arn
}
