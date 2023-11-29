import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('cloud-resume-challenge-DB')

def lambda_handler(event, context):
    response = table.get_item(Key={
        'id':'001'
    })
    views = response['Item']['views_count']
    views = views + 1
    print(views)
    response = table.put_item(Item={
        'id':'001',
        'views_count': views
    })
    return views
