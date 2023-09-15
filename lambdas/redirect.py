import boto3
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource('dynamodb')


def lambda_handler(event, context):
    """
    Redirects to the Full URL from a Short URL.
    If keyword is not in use, it will redirect to an error site stating that.
    """
    keyword = event['pathParameters']['keyword']

    table = dynamodb.Table('urls-db')

    query = table.query(KeyConditionExpression=Key('keyword').eq(keyword))

    if query['Count'] != 0:
        full_url = query['Items'][0]['full_url']
        return {
            'statusCode': 302,
            'headers': {
                'Content-Type': 'text/html',
                'Location': full_url
            }
        }
    else:
        html = f"""
        <!DOCTYPE html>
        <html>
        <head>
            <title>ERROR</title>
        </head>
        <body>
            <h1>The keyword "{keyword}" is not in use!</h1>
        </body>
        </html>
        """
        return {
                'statusCode': 404,
                'headers': {
                    'Content-Type': 'text/html'
                },
                'body': html
        }


