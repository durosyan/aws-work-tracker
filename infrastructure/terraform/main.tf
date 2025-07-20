provider "aws" {
  region = var.aws_region
}

data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_s3_bucket" "static_site" {
  bucket = "${var.website_subdomain}.${var.domain_name}"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  force_destroy = true

  tags = {
    Name = "StaticSiteBucket"
  }
}

resource "aws_s3_bucket_public_access_block" "static_site" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "static_site" {
  bucket = aws_s3_bucket.static_site.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.static_site.arn}/*"
      }
    ]
  })
}

resource "aws_route53_record" "static_site" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.website_subdomain}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_s3_bucket.static_site.website_domain
    zone_id                = "Z3AQBSTGFYJSTF" # S3 website endpoint for eu-west-1
    evaluate_target_health = false
  }
}