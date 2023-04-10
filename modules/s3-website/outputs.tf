output "website_endpoint" {
  description = "The public url of this website in AWS s3."
  value = "${aws_s3_bucket_website_configuration.static_site.website_endpoint}"
}

output "website_domain_name" {
  description = "The public url of this website."
  value = "https://${var.domain_name}"
}