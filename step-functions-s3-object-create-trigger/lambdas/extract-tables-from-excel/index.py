import boto3
import io

def lambda_handler(event, context):
    # Initialize the S3 client
    s3_client = boto3.client('s3')
    
    # Define the bucket name
    output_bucket_name = 'output-document-bucket-name-here'
    
    # Define the file names and their content
    files = {
        'file1.csv': 'This is the content of the first text file.\nIt has multiple lines.\nLine 3 of file 1.',
        'file2.csv': 'This is the content of the second text file.\nAnother line of content.\nLine 3 of file 2.'
    }
    
    keys = []
    # Loop through each file and upload it to S3
    for file_name, content in files.items():
        # Create an in-memory output file
        output = io.StringIO()
        output.write(content)
        key = f'{event["source-document"]}/excel-csv/{file_name}'
        # Upload the file to S3
        s3_client.put_object(
            Bucket=output_bucket_name,
            Key=key,
            Body=output.getvalue()
        )

        keys.append(key)
    
    event["excel-csv"] = keys

    return event
