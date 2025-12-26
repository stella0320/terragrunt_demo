import os
import boto3
import json
import socket
def lambda_handler(event, context):
    
    ### Access S3 Bucket ###
    print("STEP 1: lambda started")
    print("S3 Bucket started")
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
        print("STEP 2: Send Message to SQS Queue")
        
        # 印出 10.x.x.x → Private DNS 有效，走 VPC Endpoint
        # 印出 52.x.x.x → 還在走公網（Private DNS 沒開或有衝突）
        print("DNS sqs:", socket.gethostbyname("sqs.ap-northeast-1.amazonaws.com"))
        ### Send Message to SQS Queue ###
        sqs = boto3.client("sqs")

        response = sqs.send_message(
            QueueUrl=os.environ["QUEUE_URL"],
            MessageBody="hello from lambda via vpc endpoint"
        )
        print("SQS send message success:{}".format(response["MessageId"]))
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
    