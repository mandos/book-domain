resource "aws_cloudfront_origin_access_identity" "web_pages" {
  comment = "web_pages_storage"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${var.s3_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.web_pages.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "web_pages" {
  bucket = var.s3_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_cloudfront_distribution" "web_pages_provider" {
  origin {
    domain_name = var.s3_bucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.web_pages.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "Some comment"
  default_root_object = "index.html"

  price_class = "PriceClass_100"

  # lambda_function_association {
  #   event_type   = "origin-request"
  #   lambda_arn   = aws_lambda_function.example.qualified_arn
  #   include_body = false
  # }

  # aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
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
