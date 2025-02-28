import json
import boto3
import requests


s3_client = boto3.client('s3')
sns_client = boto3.client('sns')


bucket_name = 'otp-data-bucket'


OTP_API_DATA_URL = "http://otp-core-service/otp/routers/default/addData"

def lambda_handler(event, context):
    try:
        
        s3_event = event['Records'][0]['s3']
        file_name = s3_event['object']['key']
        file_size = s3_event['object']['size']

        print(f"Processing file: {file_name} (Size: {file_size} bytes)")

        
        file_content = s3_client.get_object(Bucket=bucket_name, Key=file_name)
        data = file_content['Body'].read()

        
        response = requests.post(OTP_API_DATA_URL, files={'file': data})
        
        
        if response.status_code == 200:
            sns_client.publish(
                TopicArn="arn:aws:sns:region:account-id:topic-name", 
                Message=f"Successfully ingested {file_name} into OpenTripPlanner"
            )
            return {
                'statusCode': 200,
                'body': json.dumps({'message': 'Data ingested successfully'})
            }
        else:
            
            return {
                'statusCode': 500,
                'body': json.dumps({'error': 'Error ingesting data', 'details': response.text})
            }
    
    except Exception as e:
        
        sns_client.publish(
            TopicArn="arn:aws:sns:region:account-id:topic-name", 
            Message=f"Error ingesting {file_name} into OpenTripPlanner: {str(e)}"
        )
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Internal server error', 'details': str(e)})
        }
