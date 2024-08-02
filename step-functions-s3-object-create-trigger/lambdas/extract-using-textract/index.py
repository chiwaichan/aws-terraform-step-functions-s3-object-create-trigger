import json

def lambda_handler(event, context):
    event["sub_processing_notes"] = ['Extracted using Textract']

    return event

