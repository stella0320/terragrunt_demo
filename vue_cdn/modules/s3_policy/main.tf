
data "aws_caller_identity" "current" {}
resource "aws_s3_bucket_policy" "this" {
  bucket = var.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # -------------------------------------------------
      # 1️⃣ CloudFront 只能讀取物件
      # -------------------------------------------------
      {
        Sid    = "AllowCloudFrontOnly"
        Effect = "Allow"

        Principal = {
          Service = "cloudfront.amazonaws.com"
        }

        Action   = "s3:GetObject"
        Resource = "${var.s3_bucket_arn}/*"

        Condition = {
          StringEquals = {
            "AWS:SourceArn" = var.cloudfront_arn
          }
        }
      },

      # -------------------------------------------------
      # 2️⃣ Dev / 手動讀取（範例）
      # -------------------------------------------------
      {
        Sid    = "DevReadS3StaticSite"
        Effect = "Allow"
        Principal = {
          AWS = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
                # "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/ann"
          ]
        }
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]

        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}
