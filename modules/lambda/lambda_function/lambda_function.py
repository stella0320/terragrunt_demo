import os
import boto3
import json

def lambda_handler(event, context):
    bucket_name = os.environ.get("BUCKET_NAME")

    s3 = boto3.client("s3")

    try:
        response = s3.list_objects_v2(Bucket=bucket_name)

        objects = []
        if "Contents" in response:
            for obj in response["Contents"]:
                objects.append(obj["Key"])

        result = {
            "bucket": bucket_name,
            "object_count": len(objects),
            "objects": objects
        }

        print("S3 access success:")
        print(json.dumps(result, indent=2))

        return {
            "statusCode": 200,
            "body": result
        }

    except Exception as e:
        print("S3 access failed:")
        print(str(e))

        return {
            "statusCode": 500,
            "body": str(e)
        }
