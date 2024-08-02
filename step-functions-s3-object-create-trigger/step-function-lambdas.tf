resource "aws_iam_role" "lambda_role_determine_processing_file_type" {
  name = "lambda-role-determine-processing-file-type"

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

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment_determine_processing_file_type" {
  role       = aws_iam_role.lambda_role_determine_processing_file_type.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip_determine_processing_file_type" {
  type        = "zip"
  source_file = "${path.module}/lambdas/determine-processing-file-type/index.py"
  output_path = "${path.module}/lambdas/determine-processing-file-type/index.zip"
}

resource "aws_lambda_function" "lambda_determine_processing_file_type" {
  filename         = data.archive_file.lambda_zip_determine_processing_file_type.output_path
  function_name    = "lambda_determine_processing_file_type"
  role             = aws_iam_role.lambda_role_determine_processing_file_type.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip_determine_processing_file_type.output_path)

  # environment {
  #   variables = {
  #     SOURCE_DOCUMENT_S3_BUCKET = aws_s3_bucket.source_document_bucket.bucket
  #   }
  # }
}

output "lambda_function_determine_processing_file_type_arn" {
  value = aws_lambda_function.lambda_determine_processing_file_type.arn
}















resource "aws_iam_role" "lambda_role_extract_using_textract" {
  name = "lambda-role-extract-using-textract"

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
  handler          = "index.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip_extract_using_textract.output_path)

  environment {
    variables = {
      ENV_VAR = "value"
    }
  }
}

output "lambda_function_extract_using_textract_arn" {
  value = aws_lambda_function.lambda_extract_using_textract.arn
}















resource "aws_iam_role" "lambda_role_extract_using_bedrock" {
  name = "lambda-role-extract-using-bedrock"

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

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment_extract_using_bedrock" {
  role       = aws_iam_role.lambda_role_extract_using_bedrock.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip_extract_using_bedrock" {
  type        = "zip"
  source_file = "${path.module}/lambdas/extract-using-bedrock/index.py"
  output_path = "${path.module}/lambdas/extract-using-bedrock/index.zip"
}

resource "aws_lambda_function" "lambda_extract_using_bedrock" {
  filename         = data.archive_file.lambda_zip_extract_using_bedrock.output_path
  function_name    = "lambda_extract_using_bedrock"
  role             = aws_iam_role.lambda_role_extract_using_bedrock.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip_extract_using_bedrock.output_path)

  environment {
    variables = {
      ENV_VAR = "value"
    }
  }
}

output "lambda_function_extract_using_bedrock_arn" {
  value = aws_lambda_function.lambda_extract_using_bedrock.arn
}














resource "aws_iam_role" "lambda_role_extract_tables_from_excel" {
  name = "lambda-role-extract-tables-from-excel"

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

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment_extract_tables_from_excel" {
  role       = aws_iam_role.lambda_role_extract_tables_from_excel.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip_extract_tables_from_excel" {
  type        = "zip"
  source_file = "${path.module}/lambdas/extract-tables-from-excel/index.py"
  output_path = "${path.module}/lambdas/extract-tables-from-excel/index.zip"
}

resource "aws_lambda_function" "lambda_extract_tables_from_excel" {
  filename         = data.archive_file.lambda_zip_extract_tables_from_excel.output_path
  function_name    = "lambda_extract_tables_from_excel"
  role             = aws_iam_role.lambda_role_extract_tables_from_excel.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip_extract_tables_from_excel.output_path)

  environment {
    variables = {
      ENV_VAR = "value"
    }
  }
}

output "lambda_function_extract_tables_from_excel_arn" {
  value = aws_lambda_function.lambda_extract_tables_from_excel.arn
}










resource "aws_iam_role" "lambda_role_process_tables_using_bedrock" {
  name = "lambda-role-process-tables-using-bedrock"

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

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment_process_tables_using_bedrock" {
  role       = aws_iam_role.lambda_role_process_tables_using_bedrock.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip_process_tables_using_bedrock" {
  type        = "zip"
  source_file = "${path.module}/lambdas/process-tables-using-bedrock/index.py"
  output_path = "${path.module}/lambdas/process-tables-using-bedrock/index.zip"
}

resource "aws_lambda_function" "lambda_process_tables_using_bedrock" {
  filename         = data.archive_file.lambda_zip_process_tables_using_bedrock.output_path
  function_name    = "lambda_process_tables_using_bedrock"
  role             = aws_iam_role.lambda_role_process_tables_using_bedrock.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip_process_tables_using_bedrock.output_path)

  environment {
    variables = {
      ENV_VAR = "value"
    }
  }
}

output "lambda_function_process_tables_using_bedrock_arn" {
  value = aws_lambda_function.lambda_process_tables_using_bedrock.arn
}













resource "aws_iam_role" "lambda_role_gather_document_details" {
  name = "lambda-role-gather-document-details"

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

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment_gather_document_details" {
  role       = aws_iam_role.lambda_role_gather_document_details.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip_gather_document_details" {
  type        = "zip"
  source_file = "${path.module}/lambdas/gather-document-details/index.py"
  output_path = "${path.module}/lambdas/gather-document-details/index.zip"
}

resource "aws_lambda_function" "lambda_gather_document_details" {
  filename         = data.archive_file.lambda_zip_gather_document_details.output_path
  function_name    = "lambda_gather_document_details"
  role             = aws_iam_role.lambda_role_gather_document_details.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip_gather_document_details.output_path)

  environment {
    variables = {
      ENV_VAR = "value"
    }
  }
}

output "lambda_function_gather_document_details_arn" {
  value = aws_lambda_function.lambda_gather_document_details.arn
}









resource "aws_iam_role" "lambda_role_merge_document_extractions" {
  name = "lambda-role-merge-document-extractions"

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

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment_merge_document_extractions" {
  role       = aws_iam_role.lambda_role_merge_document_extractions.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip_merge_document_extractions" {
  type        = "zip"
  source_file = "${path.module}/lambdas/merge-document-extractions/index.py"
  output_path = "${path.module}/lambdas/merge-document-extractions/index.zip"
}

resource "aws_lambda_function" "lambda_merge_document_extractions" {
  filename         = data.archive_file.lambda_zip_merge_document_extractions.output_path
  function_name    = "lambda_merge_document_extractions"
  role             = aws_iam_role.lambda_role_merge_document_extractions.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip_merge_document_extractions.output_path)

  environment {
    variables = {
      ENV_VAR = "value"
    }
  }
}

output "lambda_function_merge_document_extractions_arn" {
  value = aws_lambda_function.lambda_merge_document_extractions.arn
}
