################################################################################
# title: AWS IAM Identity Center with ABAC Access
# contributors: HK Transfield
#
# This module helps with configuration tasks necessary to prepare AWS 
# resources and to set up IAM Identity Center for ABAC access.
################################################################################

data "aws_ssoadmin_instances" "this" {} # need to grab the sso instance data

locals {
  sso_instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  sso_instance_id  = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

################################################################################
# Attributes for Access Control
################################################################################

# resource "aws_ssoadmin_instance_access_control_attributes" "example" {
#   instance_arn = local.sso_instance_arn
#   attribute {
#     key = "CotCenter"
#     value {
#       source = ["$${path:enterprise.cotCenter}"]
#     }
#   }
#   attribute {
#     key = "Oganization"
#     value {
#       source = ["$${path:enterprise.oganization}"]
#     }
#   }
# }

################################################################################
# Policies and Permission Sets
################################################################################

data "aws_ssoadmin_permission_set" "this" {
  instance_arn = local.sso_instance_arn
  name         = var.policy_name
  depends_on   = [aws_ssoadmin_permission_set.this]
}

resource "aws_ssoadmin_permission_set" "this" {
  name             = var.policy_name
  description      = var.policy_desc != "" ? var.policy_desc : var.policy_name
  instance_arn     = local.sso_instance_arn
  session_duration = var.session_duration
  tags             = var.tags
}

resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
  inline_policy      = var.policy_json
}

################################################################################
# IAM Identity Center
################################################################################

data "aws_identitystore_group" "this" {
  identity_store_id = local.sso_instance_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = var.policy_name
    }
  }
}

resource "aws_ssoadmin_account_assignment" "this" {
  principal_id       = data.aws_identitystore_group.this.id
  permission_set_arn = data.aws_ssoadmin_permission_set.this.arn
  instance_arn       = local.sso_instance_arn
  principal_type     = var.principal_type
  target_id          = var.aws_account_identifier
  target_type        = "AWS_ACCOUNT" # Keep entity type for which the assignment will be created as is
}

