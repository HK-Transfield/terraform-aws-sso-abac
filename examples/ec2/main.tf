provider "aws" {
  region = local.region
}

locals {
  region = "ap-southeast-2"
}

################################################################################
# ABAC Policy
################################################################################

data "aws_iam_policy_document" "access_same_project_team" {

  # Actions allowed regardless of tags
  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeInstances"]
    resources = ["*"]
  }

  # Actions allowed when tags match
  statement {
    effect = "Allow"
    actions = [
      "ec2:StartInstances",
      "ec2:StopInstances"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/CostCenter"
      values   = ["$${aws:PrincipalTag/CostCenter}"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Organization"
      values   = ["$${aws:PrincipalTag/Organization}"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Division"
      values   = ["$${aws:PrincipalTag/Division}"]
    }
  }
}

################################################################################
# SSO ABAC Module
################################################################################
module "sso_abac" {
  source                 = "../.."
  policy_name            = "Tempest-Engineers"
  policy_json            = data.aws_iam_policy_document.access_same_project_team.json
  aws_account_identifier = var.account_id
}