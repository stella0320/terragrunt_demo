import os
import boto3

_TABLE_NAME = os.environ["DYNAMODB_TABLE_NAME"]

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(_TABLE_NAME)


def put_item(item: dict):
    table.put_item(Item=item)


def query_by_pk(pk: str):
    response = table.query(
        KeyConditionExpression="pk = :pk",
        ExpressionAttributeValues={
            ":pk": pk
        }
    )
    return response.get("Items", [])


def delete_item(pk: str, sk: str):
    table.delete_item(
        Key={
            "pk": pk,
            "sk": sk
        }
    )
