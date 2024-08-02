import json

def lambda_handler(event, context):
    event["processing_notes"].append('Processed Tables using Bedrock')

    return event

