import json
import io
import boto3

def lambda_handler(event, context):
    # Initialize the S3 client
    s3_client = boto3.client('s3')
    
    # Define the bucket name
    output_bucket_name = 'output-document-bucket-name-here'
    
    # Create an in-memory output file
    output = io.StringIO()
    output.write(event["processing_notes"].join("\n"))
    key = f'{event["source-document"]}/processing-notes.txt'
    # Upload the file to S3
    s3_client.put_object(
        Bucket=output_bucket_name,
        Key=key,
        Body=output.getvalue()
    )




    event["processing_notes"].append('Saved Processing Notes')

    return event

