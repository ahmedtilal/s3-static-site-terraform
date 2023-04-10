data "external" "env_vars" {
  program = ["${path.module}/env.sh"]
}

module "datakaizen" {
  source = "../../modules/s3-website"

  domain_name = "datakaizen.art"
  route53_zone_name = "datakaizen.art"
  secret = data.external.env_vars.result["secret"]
}

output "website_endpoint" {
  value = module.datakaizen.website_endpoint
}

output "website_domain_name" {
  value = module.datakaizen.website_domain_name
}
