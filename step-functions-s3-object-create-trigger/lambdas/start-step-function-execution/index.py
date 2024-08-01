import os
import json
import boto3

def lambda_handler(event, context):
    # Get bucket name and object key from the event
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    object_key = event['Records'][0]['s3']['object']['key']

    # Retrieve the Step Function ARN from environment variables
    state_machine_arn = os.getenv('STEP_FUNCTION_ARN')
    if not state_machine_arn:
        raise ValueError("STEP_FUNCTION_ARN environment variable is not set")

    # Create a Step Functions client
    client = boto3.client('stepfunctions')

    step_function_input = {
        "source-document": object_key,
    }

    # Start the execution of the Step Function
    try:
        response = client.start_execution(
            stateMachineArn=state_machine_arn,
            input=json.dumps(step_function_input)  # Pass the Lambda event as input to the Step Function
        )
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Step Function started successfully',
                'executionArn': response['executionArn']
            })
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Error starting Step Function',
                'error': str(e)
            })
        }
