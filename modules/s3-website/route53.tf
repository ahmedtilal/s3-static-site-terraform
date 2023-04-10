
data "aws_route53_zone" "zone" {
  name  = var.route53_zone_name
  private_zone = false
}

resource "aws_cloudfront_distribution" "cdn" {
  count = "${length(local.domains)}"
  enabled = true
  http_version = "http2"
  aliases = ["${element(local.domains, count.index)}"]
  is_ipv6_enabled = true

  origin {
    domain_name = "${element(local.endpoints, count.index)}"
    origin_id = "S3-${element(local.domains, count.index)}"

    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = "80"
      https_port             = "443"
      origin_ssl_protocols = ["TLSv1"]
    }

    custom_header {
      name  = "User-Agent"
      value = var.secret
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.cert[0].certificate_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${element(local.domains, count.index)}"
    compress = "true"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }
}

resource "aws_route53_record" "static_site" {
  count   = length(local.domains)
  zone_id = data.aws_route53_zone.zone.id
  name    = element(local.domains, count.index)
  type    = "A"

  alias {
    name                   = element(aws_cloudfront_distribution.cdn.*.domain_name, count.index)
    zone_id                = element(aws_cloudfront_distribution.cdn.*.hosted_zone_id, count.index)
    evaluate_target_health = false
  }
}

// AWS Record validation
resource "aws_route53_record" "validation" {
  count   = length(local.domains)
  allow_overwrite = true
  
  name            = element(aws_acm_certificate.cert[0].domain_validation_options.*.resource_record_name, count.index)
  records         = [ element(aws_acm_certificate.cert[0].domain_validation_options.*.resource_record_value, count.index) ]
  ttl             = 300
  type            = element(aws_acm_certificate.cert[0].domain_validation_options.*.resource_record_type, count.index)
  zone_id         = data.aws_route53_zone.zone.zone_id

  depends_on = [aws_acm_certificate.cert]
  provider = aws.awsus
}

locals {
    main_acm_domain_validation_option_length = length(aws_acm_certificate.cert[0].domain_validation_options)

    www_domain = "www.${var.domain_name}"
    domains = [
        var.domain_name,
        local.www_domain
    ]

    endpoints = [
    aws_s3_bucket_website_configuration.static_site.website_endpoint,
    aws_s3_bucket_website_configuration.redirect.website_endpoint
  ]
}

resource "aws_acm_certificate" "cert" {
  count   = var.route53_zone_name != "" ? 1 : 0
  domain_name       = var.domain_name
  subject_alternative_names = [local.www_domain]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
    provider = aws.awsus
}

resource "aws_acm_certificate_validation" "cert" {
    count   = var.route53_zone_name != "" ? 1 : 0
    certificate_arn         = aws_acm_certificate.cert[0].arn
    validation_record_fqdns = aws_route53_record.validation.*.fqdn
    provider = aws.awsus
}

resource "aws_iam_user" "deploy" {
  name = "${var.domain_name}-deploy"
  path = "/"
}

resource "aws_iam_access_key" "deploy" {
  user = aws_iam_user.deploy.name
}

resource "aws_iam_user_policy" "deploy" {
  name = "deploy"
  user = aws_iam_user.deploy.name
  policy = data.aws_iam_policy_document.deploy.json
}
