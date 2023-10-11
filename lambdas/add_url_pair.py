import json
import boto3
from boto3.dynamodb.conditions import Key
import re

dynamodb = boto3.resource('dynamodb')


def lambda_handler(event, context):
    """
    First it will check if the full_url is valid.
    Then it will check if the keyword is in use. If not, the URL pair will be added into the DB.
    """
    response_body = json.loads(event['body'])
    keyword = response_body['keyword']
    full_url = response_body['full_url']

    table = dynamodb.Table('urls-db')

    pattern = "^(https?|http):\/\/[0-9A-Za-z.]+\\.[0-9A-Za-z.]+\\.[a-z]+$"
    valid_url = re.match(pattern, full_url)

    if valid_url:

        query = table.query(KeyConditionExpression=Key('keyword').eq(keyword))

        if query['Count'] != 0:
            html = f"""
            <!DOCTYPE html>
            <html>
            <head>
                <title>ERROR</title>
                <style>
                    body {{
                        font-family: 'Font Name', sans-serif;
                    }}
                    h1 {{
                        color: orange;
                    }}
                </style>
            </head>
            <body>
                <h1>The keyword "{keyword}" is already in use!</h1>
            </body>
            </html>
            """
        else:
            table.put_item(
                Item={
                    'keyword': keyword,
                    'full_url': full_url
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
                    h1 {{
                        color: green;
                    }}
                </style>
            </head>
            <body>
                <h1>New URL pair [ {keyword} ==> {full_url} ] has been added!</h1>
            </body>
            </html>
            """
    else:
        html = f"""
        <!DOCTYPE html>
        <html>
        <head>
            <title>ERROR</title>
            <style>
                body {{
                    font-family: 'Font Name', sans-serif;
                }}
                h1 {{
                    color: red;
                }}
            </style>
        </head>
        <body>
            <h1>The URL "{full_url}" is not valid!</h1>
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
