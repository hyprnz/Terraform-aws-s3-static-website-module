module "static_website_example" {
  source = "../../"

  providers = {
    aws = aws
  }

  site_name = "frontend"
  namespace = var.namespace

  url             = var.url
  certificate_arn = var.certificate_arn

  site_config_values = {
    "auth_url"    = "www.google.com"
    "backend_url" = "www.aws.com"
    "version"     = "1.1.0"
  }

  cloudfront_custom_errors = [
    {
      error_caching_min_ttl = 300
      error_code            = 404
      response_code         = 200
      response_page_path    = "/index.html"
  }]

  cors_allowed_origins = ["*"]
  cors_allowed_headers = [""]

  module_tags     = merge(map("Environment", "test"), map("env", "test"))
  s3_tags         = map("s3-example", "true")
  cloudfront_tags = map("cloudfront-example", "true")

  wait_for_deployment = false

  comment = "Example static website cloudfront distribution"
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  default = "ap-southeast-2"
}
variable "url" {}
variable "certificate_arn" {}
variable "namespace" {}

output "website_domain" {
  value = module.static_website_example.s3_bucket_website_domain
}

output "website_endpoint" {
  value = module.static_website_example.s3_bucket_website_endpoint
}

output "website_hosted_id" {
  value = module.static_website_example.s3_bucket_hosted_id
}

output "cloudfront_url" {
  value = module.static_website_example.cloudfront_url
}

output "cloudfront_hosted_zone" {
  value = module.static_website_example.cloudfront_hosted_zone
}
