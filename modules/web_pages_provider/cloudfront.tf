resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "web_pages_storage"
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = var.s3_bucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "DomainSwitcher Service"
  default_root_object = "index.html"

  price_class = "PriceClass_100"

  # Have to be set automatically
  # aliases = [
  #   "foo1.boo.pl",
  #   "foo2.boo.pl",
  #   "moo.pl"
  # ]

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

    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = aws_lambda_function.edge_lambda.qualified_arn
      include_body = false
    }

    viewer_protocol_policy = "allow-all"
    # For testing purpose
    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
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
