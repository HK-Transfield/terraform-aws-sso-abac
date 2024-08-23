provider "aws" {
  region = local.region
}

data "aws_ssoadmin_instances" "this" {}

locals {
  region = "ap-southeast-2"
}


################################################################################
# Supporting Resources
################################################################################

locals {
  attributes = {
    "CostCenter"   = "$${path:enterprise.costCenter}"
    "Organization" = "$${path:enterprise.organization}"
    "Division"     = "$${path:enterprise.division}"
  }
}

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

module "ec2_abac" {
  source              = "../.."
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