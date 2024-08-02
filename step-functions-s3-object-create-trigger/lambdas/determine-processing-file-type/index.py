import json

def lambda_handler(event, context):
    # Log the input event
    print("Received event:", json.dumps(event))

    # You can add specific checks or logic based on the event data
    # For demonstration, let's assume we check for a specific key
    if 'key_to_check' in event:
        response_message = f"Received key_to_check: {event['key_to_check']}"
    else:
        response_message = "No key_to_check found in the event."

    return {
        'statusCode': 200,
        'body': json.dumps(response_message)
    }
