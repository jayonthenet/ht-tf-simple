variable "humanitec_organization" {}
variable "humanitec_token" {}
variable "region" {}
variable "access_key" {}
variable "secret_key" {}
variable "app_name" {}

terraform {
  required_providers {
    humanitec = {
      source = "humanitec/humanitec"
    }
  }
}

provider "humanitec" {
  org_id = var.humanitec_organization
  token  = var.humanitec_token
}

resource "humanitec_resource_definition" "aws_terraform_resource_s3_bucket" {
  driver_type = "${var.humanitec_organization}/terraform"
  id          = "${var.app_name}-aws-terrafom-s3-bucket"
  name        = "${var.app_name}-aws-terrafom-s3-bucket"
  type        = "s3"

  criteria = [
    {
      app_id = humanitec_application.app.id
    }
  ]

  driver_inputs = {
    secrets = {
      variables = jsonencode({
        access_key = var.access_key
        secret_key = var.secret_key
      })
    },
    values = {
      "source" = jsonencode(
        {
          path = "s3/terraform/bucket/"
          rev  = "refs/heads/main"
          url  = "https://github.com/jayonthenet/ht-tf-simple.git"
        }
      )
      "variables" = jsonencode(
        {
          region          = var.region,
          bucket          = "simple-bucket-$${context.app.id}-$${context.env.id}",
        }
      )
    }
  }

}
