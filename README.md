<!-- BEGIN_TF_DOCS -->
# AWS Static Website Terraform Deployment

A Terraform definition to deploy your static website on AWS.

## Prerequisites

1. [AWS CLI](https://aws.amazon.com/cli/) connected to an [AWS account](https://aws.amazon.com/resources/create-account/).
2. [Terraform CLI](https://developer.hashicorp.com/terraform/cli).
3. [A hosted zone in AWS Route53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html) with the domain name you want to use.

## Usage

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
---

## Requirements

No requirements.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_cloudfront_distribution.cdn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_iam_access_key.deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_route53_record.static_site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.static_site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.static_site_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_website_configuration.redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_s3_bucket_website_configuration.static_site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | DNS name of the website. | `any` | n/a | yes |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | Route53 zone name to use. | `any` | n/a | yes |
| <a name="input_secret"></a> [secret](#input\_secret) | Secret key | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_website_domain_name"></a> [website\_domain\_name](#output\_website\_domain\_name) | The public url of this website. |
| <a name="output_website_endpoint"></a> [website\_endpoint](#output\_website\_endpoint) | The public url of this website in AWS s3. |

---

<span style="color:red">NOTE:</span> Manual changes to the README will be overwritten when the documentation is updated. To update the documentation, run `terraform-docs -c ./.config/terraform-docs.yml ./modules/s3-website/ && mv ./modules/s3-website/README.md .`
<!-- END_TF_DOCS -->