provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
  alias = "awsus"
}

data "aws_iam_policy_document" "bucket" {
  statement {
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.domain_name}/*",
    ]

    principals {
      type = "AWS"
      identifiers = ["*"]
    }

    condition {
      test = "StringEquals"
      variable = "aws:UserAgent"
      values = ["${var.secret}"]
    }
  }
}

data "aws_iam_policy_document" "deploy" {
  statement {
    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "${aws_s3_bucket.static_site.arn}"
    ]
  }

  statement {
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      "${aws_s3_bucket.static_site.arn}/*"
    ]
  }

  statement {
    actions = [
      "cloudfront:CreateInvalidation"
    ]

    resources = [
      "*" # A specific resource cannot be specified here, unfortunately.
    ]
  }
}

resource "aws_s3_bucket" "static_site" {
  bucket = "${var.domain_name}"
}

resource "aws_s3_bucket_policy" "static_site_policy" {
  bucket = aws_s3_bucket.static_site.id
  policy = data.aws_iam_policy_document.bucket.json
}

resource "aws_s3_bucket_website_configuration" "static_site" {
  bucket = aws_s3_bucket.static_site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket" "redirect" {
  bucket = local.www_domain
}

resource "aws_s3_bucket_website_configuration" "redirect" {
    bucket = aws_s3_bucket.redirect.id
    redirect_all_requests_to {
      host_name = aws_s3_bucket.static_site.id
      protocol = "https"
    }
}