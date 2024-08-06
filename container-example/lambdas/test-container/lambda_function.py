import json
from rhubarb import DocAnalysis

import boto3
session = boto3.Session(region_name='ap-southeast-2')

def lambda_handler(event, context):
    # Your Lambda function code goes here

    da = DocAnalysis(file_path="s3://source-document-bucket-name-here/testfile.pdf", 
                    boto3_session=session)
    resp = da.run(message="What is this document about?")
    print(resp)


    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
