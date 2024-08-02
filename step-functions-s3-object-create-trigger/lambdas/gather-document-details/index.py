import json

def lambda_handler(event, context):
    # This function does nothing
    return {
        'statusCode': 200,
        'body': json.dumps('This Lambda function does nothing.')
    }

