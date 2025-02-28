

resource "aws_cloudfront_distribution" "my_distribution" {
  origin {
    domain_name = aws_s3_bucket.eks_s3_bucket.bucket_regional_domain_name
    origin_id   = "eks-s3-bucket"
    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/E1QF4KUIH"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    viewer_protocol_policy = "allow-all"
    allowed_methods {
      items = ["GET", "HEAD"]
    }
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_100"
}
