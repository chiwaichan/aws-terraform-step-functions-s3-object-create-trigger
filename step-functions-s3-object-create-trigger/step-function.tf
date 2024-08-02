resource "aws_iam_role" "step_functions_role" {
  name = "step_functions_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "states.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_policy" "step_functions_policy" {
  name = "step_functions_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = [
          "lambda:InvokeFunction",
        ],
        Effect   = "Allow",
        Resource = "*",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "step_functions_policy_attachment" {
  role       = aws_iam_role.step_functions_role.name
  policy_arn = aws_iam_policy.step_functions_policy.arn
}

data "aws_iam_policy_document" "step_functions_policy" {
  statement {
    actions = ["lambda:InvokeFunction"]

    resources = ["*"]

    effect = "Allow"
  }
}

resource "aws_sfn_state_machine" "document_processing_state_machine" {
  name     = "document-processing-state-machine"
  role_arn = aws_iam_role.step_functions_role.arn
  definition = jsonencode(
    
    
    {
  "StartAt": "Determine Processing File Type",
  "States": {
    "Determine Processing File Type": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.lambda_determine_processing_file_type.arn}",
      "Next": "Determine Next Step File Type Choice"
    },
    "Determine Next Step File Type Choice": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.next_step_file_type",
          "StringEquals": "EXCEL",
          "Next": "Extract Tables from Excel"
        },
        {
          "Variable": "$.next_step_file_type",
          "StringEquals": "PDF",
          "Next": "Gather Document Details"
        }
      ],
      "Default": "Gather Document Details"
    },
    "Extract Tables from Excel": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.lambda_extract_tables_from_excel.arn}",
      "Next": "Extract Document using Bedrock"
    },
    "Gather Document Details": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.lambda_extract_using_textract.arn}",
      "Next": "Extract Document using Textract"
    },
    "Extract Document using Textract": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.lambda_extract_using_textract.arn}",
      "Next": "Extract Document using Bedrock"
    },
    "Extract Document using Bedrock": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.lambda_extract_using_bedrock.arn}",
      "ResultPath": "$.recommended_type",
      "Next": "Request Human Approval"
    },
    "Request Human Approval": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sqs:sendMessage.waitForTaskToken",
      "Parameters": {
        "QueueUrl": "https://sqs.ap-southeast-2.amazonaws.com/177522612043/StepFunctionsSample-HelloLambda-13b053f3-12-RequestHumanApprovalSqs-2qNTsZIqmdrp",
        "MessageBody": {
          "Input.$": "$",
          "TaskToken.$": "$$.Task.Token"
        }
      },
      "ResultPath": null,
      "Next": "Buy or Sell?"
    },
    "Buy or Sell?": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.recommended_type",
          "StringEquals": "buy",
          "Next": "Buy Stock"
        },
        {
          "Variable": "$.recommended_type",
          "StringEquals": "sell",
          "Next": "Sell Stock"
        }
      ]
    },
    "Buy Stock": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:ap-southeast-2:177522612043:function:StepFunctionsSample-HelloLambda-13b-BuyStockLambda-EW7XjLysUqaz",
      "Next": "Report Result"
    },
    "Sell Stock": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:ap-southeast-2:177522612043:function:StepFunctionsSample-HelloLambda-13-SellStockLambda-6vJsjH8oioBR",
      "Next": "Report Result"
    },
    "Report Result": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "TopicArn": "arn:aws:sns:ap-southeast-2:177522612043:StepFunctionsSample-HelloLambda-13b053f3-12a8-41a6-aafc-1c4626d419a4-ReportResultSnsTopic-cCmbP4y6wZER",
        "Message": {
          "Input.$": "$"
        }
      },
      "End": true
    }
  }
}





)
}
