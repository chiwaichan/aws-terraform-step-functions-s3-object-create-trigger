import json

def lambda_handler(event, context):
    event["processing_notes"].append(f'Gathered document details.')
    event["description"] = "A description"

    return event

