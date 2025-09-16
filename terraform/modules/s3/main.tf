locals {
  prefix_name     = "${var.application}-${var.environment}"
  app_name        = "${var.module_name}-${var.environment}"
  s3_name         = "${local.prefix_name}-S3"
  cloudfront_name = "${local.prefix_name}-cloudfront"
  bucket_name     = "${local.prefix_name}-${var.bucket_name}"
}


resource "aws_s3_bucket" "root_bucket" {
  bucket = local.bucket_name
  acl    = "private"

  versioning {
    enabled = false
  }

  website {
    index_document = "index.html"
  }

  tags = merge(
    tomap({ "Service" = "S3" }),
    tomap({ "Name" = local.s3_name })
  )
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "S3-.${local.bucket_name}"
}

resource "aws_cloudfront_distribution" "root_s3_distribution" {

  origin {
    domain_name = aws_s3_bucket.root_bucket.bucket_regional_domain_name
    origin_id   = "S3-.${local.bucket_name}"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = var.api_endpoint
    origin_id   = "apigw"

    custom_origin_config {
      http_port              = var.http_port
      https_port             = var.https_port
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }


  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["${local.app_name}.${var.domain_address}"]

  custom_error_response {
    error_caching_min_ttl = 86400
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-.${local.bucket_name}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  ordered_cache_behavior {
    path_pattern     = "/api*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "apigw"

    default_ttl = 0
    min_ttl     = 0
    max_ttl     = 0

    forwarded_values {
      query_string = true
      headers      = ["*"]
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.tsl_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  tags = merge(
    tomap({ "Service" = "Cloudfront" }),
    tomap({ "Name" = local.cloudfront_name })
  )
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "arn:aws:s3:::${local.bucket_name}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}",
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "root_bucket" {
  bucket = aws_s3_bucket.root_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket_public_access_block" "root_bucket" {
  bucket = aws_s3_bucket.root_bucket.id

  block_public_acls   = true
  block_public_policy = true
}
