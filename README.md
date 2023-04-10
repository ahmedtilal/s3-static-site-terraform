# AWS Static Website Terraform Deployment

A Terraform definition to deploy your static website on AWS.

## Prerequisites

---

1. [AWS CLI](https://aws.amazon.com/cli/) connected to an [AWS account](https://aws.amazon.com/resources/create-account/).
2. [Terraform CLI](https://developer.hashicorp.com/terraform/cli).
3. [A hosted zone in AWS Route53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html) with the domain name you want to use.

## Usage

---

Create a folder inside the `live` directory and create a new main.tf file with the following:

```
module "###YOUR_MODULE_NAME###" {
  source = "../../modules/s3-website"

  domain_name = "###YOUR_DOMAIN_NAME###"
  route53_zone_name = "###YOUR_ROUTE53_ZONE_NAME###"
  secret = "###YOUR_SECRET_KEY###"
}

output "website_endpoint" {
  value = module.###YOUR_MODULE_NAME###.website_endpoint
}

output "website_domain_name" {
  value = module.###YOUR_MODULE_NAME###.website_domain_name
}
```

