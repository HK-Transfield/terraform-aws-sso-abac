provider "aws" {
  region = local.region
}

data "aws_ssoadmin_instances" "this" {}

locals {
  region = "ap-southeast-2"
  attributes = {
    "CostCenter"   = "$${path:enterprise.costCenter}"
    "Organization" = "$${path:enterprise.organization}"
    "Division"     = "$${path:enterprise.division}"
  }
}

################################################################################
# IAM Identity Center ABAC Attributes
################################################################################

module "ec2_abac_attributes" {
  source     = "../../modules/abac-attributes"
  attributes = local.attributes
}

################################################################################
# IAM Identity Center ABAC Permission Sets
################################################################################

module "ec2_abac_permissions" {
  source              = "../../modules/abac-permissions"
  permission_set_name = "EC2AllowAccessEngineers"
  principal_name      = "MyPrincipalName"
  principal_type      = "GROUP"
  account_identifiers = ["123456789012"] # Replace with your own AWS Account IDs
  attributes          = local.attributes

  actions_readonly = [
    "ec2:DescribeInstances",
  ]

  actions_conditional = [
    "ec2:StartInstances",
    "ec2:StopInstances"
  ]
}