import json

def lambda_handler(events, context):
    result = events[0]

    # Iterate over the rest of the array
    for event in events:
        if "textract-csv" in event:
            result['textract-csv'] = event["textract-csv"] 
        if "bedrock-csv" in event:
            result['bedrock-csv'] = event["bedrock-csv"] 
            
        for sub_processing_note in event["sub_processing_notes"]:
            result["processing_notes"].append(sub_processing_note)

    del result['sub_processing_notes']

    return result

