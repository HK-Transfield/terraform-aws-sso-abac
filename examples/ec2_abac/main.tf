provider "aws" {
  region = local.region
}

data "aws_ssoadmin_instances" "this" {}

locals {
  region = "ap-southeast-2"
}

locals {
  attributes = {
    "CostCenter"   = "$${path:enterprise.costCenter}"
    "Organization" = "$${path:enterprise.organization}"
    "Division"     = "$${path:enterprise.division}"
  }
}

################################################################################
# Supporting Resources
################################################################################

resource "aws_ssoadmin_instance_access_control_attributes" "this" {
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]

  dynamic "attribute" {
    for_each = local.attributes
    content {
      key = attribute.key
      value {
        source = [attribute.value]
      }
    }
  }
}

################################################################################
# SSO ABAC Module
################################################################################

locals {
  actions_allowed_nonconditional = ["ec2:DescribeInstances"]
  actions_allowed_matching_tags  = ["ec2:StartInstances", "ec2:StopInstances"]
}

module "ec2_abac_tempest" {
  source                         = "../.."
  policy_name                    = "AllowEC2Engineers"
  account_identifiers            = ["123456789012", "210987654321"] # Replace with your own AWS Account IDs
  attributes                     = local.attributes
  actions_allowed_nonconditional = local.actions_allowed_nonconditional
  actions_allowed_matching_tags  = local.actions_allowed_matching_tags
}