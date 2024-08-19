provider "aws" {
  region = local.region
}

locals {
  region = "ap-southeast-2"
}


################################################################################
# SSO ABAC Module
################################################################################

locals {
  attributes            = ["CostCenter", "Organization", "Division"]
  actions_no_tags       = ["ec2:DescribeInstances"]
  actions_matching_tags = ["ec2:StartInstances", "ec2:StopInstances"]
}

module "ec2_abac" {
  source                 = "../.."
  policy_name            = "Tempest-Engineers"
  aws_account_identifier = var.account_id
  attributes             = local.attributes
  actions_no_tags        = local.actions_no_tags
  actions_matching_tags  = local.actions_matching_tags
}