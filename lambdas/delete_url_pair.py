import json
import boto3
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource('dynamodb')


def lambda_handler(event, context):
    """
    First it will check if the keyword is in use.
    If it exists, the URL pair will be deleted from the DB.
    """
    response_body = json.loads(event['body'])
    keyword = response_body['keyword']

    table = dynamodb.Table('urls-db')

    query = table.query(KeyConditionExpression=Key('keyword').eq(keyword))
    if query['Count'] == 0:
        response_body = f"Short URL [ {keyword} ] is not in use.\n"
    else:
        table.delete_item(
            Key={
                "keyword": keyword
            }
        )
        response_body = f"Short URL [ {keyword} ] pair has been deleted.\n"

    return {
        'statusCode': 200,
        'headers': {'Content-Type': 'application/json'},
        'body': response_body
    }
