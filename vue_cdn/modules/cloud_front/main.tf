data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "caching_disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "all_viewer_except_host" {
  name = "Managed-AllViewerExceptHostHeader"
}


resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${var.project_name}-cf-oac"
  description                       = "OAC for private S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


resource "aws_cloudfront_distribution" "this" {
  enabled = true
  default_root_object = "index.html"

  
  # --- Origin 1: S3 (靜態網頁) ---
  origin {
    domain_name = var.bucket_domain_name
    origin_id   = "origin-s3-${var.project_name}"
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  # 預設 Behavior (S3 靜態網頁)
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "origin-s3-${var.project_name}"

    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id = data.aws_cloudfront_cache_policy.caching_optimized.id # AWS managed: CachingOptimized
  }

  # --- Origin 2: API Gateway ---
  origin {
    domain_name = var.api_gateway_domain_name
    origin_id   = "origin-api-${var.project_name}"

  custom_header {
    name  = "x-from-cdn"
    value = "jlkdjjfpsjap;odj"
  }

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  ordered_cache_behavior {
    path_pattern     = "/api/*"
    target_origin_id = "origin-api-${var.project_name}"

    # API 通常允許所有動態方法
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]

    viewer_protocol_policy = "redirect-to-https"

    # API 通常「不應該」快取，否則會抓到舊資料
    # 使用 AWS Managed Policy: CachingDisabled
    cache_policy_id = data.aws_cloudfront_cache_policy.caching_disabled.id
    
    # 必須轉發 Header 與 QueryString 給 API Gateway，否則 API 會失效
    # 使用 AWS Managed Policy: AllViewerExceptHostHeader (推薦用於 API Gateway)
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

    
}