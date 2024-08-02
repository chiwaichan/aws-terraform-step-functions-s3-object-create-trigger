import json

def lambda_handler(event, context):
    event["processing_notes"].append('Saved Processing Notes')

    return event

