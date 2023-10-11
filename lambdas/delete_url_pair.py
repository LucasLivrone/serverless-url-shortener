import re
import json
import boto3
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource('dynamodb')


def lambda_handler(event, context):
    """
    Flow:
        1. Check if the keyword is valid. If not valid, it will return an Error.
        2. If valid, it will check if it exists in the DB.
            * If it exists, the URL pair with that keyword will be deleted from the DB
            * If it doesn't exist, it will return an error.
    """
    response_body = json.loads(event['body'])
    keyword = response_body['keyword']

    keyword_pattern = r"^[a-z]+$"

    valid_keyword = re.match(keyword_pattern, keyword)

    if not valid_keyword:
        html = f"""
            <!DOCTYPE html>
            <html>
            <head>
                <title>ERROR</title>
                <style>
                    body {{
                        font-family: 'Font Name', sans-serif;
                    }}
                    h2 {{
                        color: red;
                    }}
                </style>
            </head>
            <body>
                <h2>The keyword "{keyword}" is not valid!</h2>
            </body>
            </html>
            """

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'text/html'
            },
            'body': html
        }

    else:

        table = dynamodb.Table('urls-db')

        query = table.query(KeyConditionExpression=Key('keyword').eq(keyword))
        if query['Count'] == 0:
            html = f"""
            <!DOCTYPE html>
            <html>
            <head>
                <title>ERROR</title>
                <style>
                    body {{
                        font-family: 'Font Name', sans-serif;
                    }}
                    h2 {{
                        color: red;
                    }}
                </style>
            </head>
            <body>
                <h2>The keyword "{keyword}" is already not in use!</h2>
            </body>
            </html>
            """
        else:
            table.delete_item(
                Key={
                    "keyword": keyword
                }
            )
            html = f"""
            <!DOCTYPE html>
            <html>
            <head>
                <title>Success</title>
                <style>
                    body {{
                        font-family: 'Font Name', sans-serif;
                    }}
                    h2 {{
                        color: green;
                    }}
                </style>
            </head>
            <body>
                <h2>URL pair with keyword [ {keyword} ] has been deleted!</h2>
            </body>
            </html>
            """

    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'text/html'
        },
        'body': html
    }
