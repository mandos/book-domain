import json
import random
import boto3


def lambda_handler(event, context):
    request = event['Records'][0]['cf']['request']

    #print(request)
    # Harcoded values
    dynamodb = boto3.resource('dynamodb', region_name='eu-west-1')
    domains = ["foo1.boo.pl", "foo2.boo.pl", "moo.net"]

    table = dynamodb.Table('domains')
    # Instead of random domain, I should take it from request
    response = table.get_item(
        Key={
            'fqdn': random.choice(domains)
        }
    )
    folder = response['Item']
    request['origin']['s3']['path'] = '/' + folder['folder']
    #print(request)

    return request
