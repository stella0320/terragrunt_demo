from routes.list_todos import list_todos
from routes.create_todo import create_todo
from routes.delete_todo import delete_todo


def handler(event, context):
    
    print("Received event:", event)
    headers = event.get("headers") or {}
    cdn_header = headers.get("x-from-cdn")
    if cdn_header != "jlkdjjfpsjap;odj":
        return {
            "statusCode": 405,
            "body": "Forbidden"
        }
    # HTTP API v2 正確取法
    http = event.get("requestContext", {}).get("http", {})

    method = http.get("method")
    path = http.get("path")
    stage = "/" + event["requestContext"]["stage"]

    if method == "GET" and path == stage + "/api/todos":
        return list_todos(event)

    if method == "POST" and path == stage + "/api/todos":
        return create_todo(event)

    if method == "DELETE" and path.startswith(stage + "/api/todos/"):
        return delete_todo(event)

    return {
        "statusCode": 402,
        "body": "Not Found"
    }
