import json

def lambda_handler(event, context):
    event["processing_notes"].append(f'Gathered document details.')

    return event

