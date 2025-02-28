import json
import requests


OTP_API_BASE_URL = "http://otp-core-service/otp/routers/default/plan"

def lambda_handler(event, context):
    try:
        
        body = json.loads(event['body'])
        origin = body['origin']
        destination = body['destination']
        time = body.get('time', 'now')  

        
        params = {
            'fromPlace': origin,
            'toPlace': destination,
            'time': time,
            'mode': 'TRANSIT,WALK',
            'arriveBy': False  # Assume a departure time request; 
        }

        
        response = requests.get(OTP_API_BASE_URL, params=params)
        
        
        if response.status_code == 200:
            trip_plan = response.json()
            return {
                'statusCode': 200,
                'body': json.dumps({'trip_plan': trip_plan})
            }
        else:
            
            return {
                'statusCode': 500,
                'body': json.dumps({'error': 'Error generating trip plan', 'details': response.text})
            }

    except Exception as e:
        
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Internal server error', 'details': str(e)})
        }
