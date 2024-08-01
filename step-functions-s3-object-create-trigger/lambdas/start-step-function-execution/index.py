import os
import json
import boto3

def lambda_handler(event, context):
    # Retrieve the Step Function ARN from environment variables
    state_machine_arn = os.getenv('STEP_FUNCTION_ARN')
    if not state_machine_arn:
        raise ValueError("STEP_FUNCTION_ARN environment variable is not set")

    # Create a Step Functions client
    client = boto3.client('stepfunctions')

    # Start the execution of the Step Function
    try:
        response = client.start_execution(
            stateMachineArn=state_machine_arn,
            input=json.dumps(event)  # Pass the Lambda event as input to the Step Function
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
