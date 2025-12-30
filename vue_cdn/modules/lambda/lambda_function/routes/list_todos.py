import json
from db.dynamodb import query_by_pk


def list_todos(event):
    params = event.get("queryStringParameters") or {}
    user_id = params.get("userId")

    if not user_id:
        return {
            "statusCode": 400,
            "body": "userId is required"
        }

    pk = f"USER#{user_id}"
    items = query_by_pk(pk)

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(items)
    }

