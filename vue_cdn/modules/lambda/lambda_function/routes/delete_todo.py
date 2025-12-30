from db.dynamodb import delete_item


def delete_todo(event):
    path_params = event.get("pathParameters") or {}

    user_id = path_params.get("userId")
    message_id = path_params.get("messageId")

    if not user_id or not message_id:
        return {
            "statusCode": 400,
            "body": "userId and messageId are required"
        }

    delete_item(
        pk=f"USER#{user_id}",
        sk=f"MSG#{message_id}"
    )

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": "{}"
    }
