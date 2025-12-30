import json
import uuid
from datetime import datetime, timezone
from db.dynamodb import put_item


def create_todo(event):
    body = json.loads(event.get("body", "{}"))

    user_id = body.get("userId")
    message = body.get("message")

    if not user_id or not message:
        return {
            "statusCode": 400,
            "body": "userId and message are required"
        }

    message_id = str(uuid.uuid4())

    item = {
        "pk": f"USER#{user_id}",
        "sk": f"MSG#{message_id}",
        "message": message,
        "done": False,
        "createdAt": datetime.now(timezone.utc).isoformat()
    }

    put_item(item)

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(item)
    }
