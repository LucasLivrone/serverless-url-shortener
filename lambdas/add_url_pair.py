import json
import boto3
from boto3.dynamodb.conditions import Key
import re

dynamodb = boto3.resource('dynamodb')


def lambda_handler(event, context):
    """
    Flow:
        1. Check if the keyword is valid. If not valid, it will return an Error
        2. If valid, it will check if the full_url is valid. If not valid, it will return an Error
            * If it's valid, but already exists, it will return an Error
            * If it's valid and don't exist, the URL pair will be added into the DB.
    """
    response_body = json.loads(event['body'])
    keyword = response_body['keyword']
    full_url = response_body['full_url']

    table = dynamodb.Table('urls-db')

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

    else:
        url_pattern = (r"(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z]{2,}(\.[a-zA-Z]{2,})(\.[a-zA-Z]{2,"
                   r"})?\/[a-zA-Z0-9]{2,}|((https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z]{2,}(\.[a-zA-Z]{"
                   r"2,})(\.[a-zA-Z]{2,})?)|(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z0-9]{2,"
                   r"}\.[a-zA-Z0-9]{2,}\.[a-zA-Z0-9]{2,}(\.[a-zA-Z0-9]{2,})?")

        valid_url = re.match(url_pattern, full_url)

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
                        h2 {{
                            color: orange;
                        }}
                    </style>
                </head>
                <body>
                    <h2>The keyword "{keyword}" is already in use!</h2>
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
                        h2 {{
                            color: green;
                        }}
                    </style>
                </head>
                <body>
                    <h2>New URL pair [ {keyword} ==> {full_url} ] has been added!</h2>
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
                    h2 {{
                        color: red;
                    }}
                </style>
            </head>
            <body>
                <h2>The URL "{full_url}" is not valid!</h2>
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
