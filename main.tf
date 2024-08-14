/**
This module contains all the permission sets for a project
It will define individual permission sets as inline policies 
Either replication or defined as customer policies. 
Included in that is a variable for a tag that will only 
allow access to resources with the same tag

Update tag for a new set of rules

This module assigns AWS accounts permission sets by adding them to the appropriate
IAM Identity Center group.
*/
data "aws_ssoadmin_instances" "this" {} # need to grab the sso instance data

locals {
  aws_ssoadmin_instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

################################################################################
# ABAC Policies and Permission Sets
################################################################################

resource "aws_ssoadmin_permission_set" "this" {
  name             = var.policy_name
  description      = var.policy_desc != "" ? var.policy_desc : var.policy_name
  instance_arn     = local.aws_ssoadmin_instance_arn
  session_duration = var.session_duration
  tags             = var.tags
}

resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  instance_arn       = local.aws_ssoadmin_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
  inline_policy      = var.policy_json
}

data "aws_ssoadmin_permission_set" "this" {
  instance_arn = local.aws_ssoadmin_instance_arn
  name         = var.policy_name
  depends_on   = [aws_ssoadmin_permission_set.this]
}

################################################################################
# IAM Identity Center
################################################################################

data "aws_identitystore_group" "this" {
  identity_store_id = local.aws_ssoadmin_instance_arn

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = var.group
    }
  }
}

resource "aws_ssoadmin_account_assignment" "this" {
  for_each           = var.aws_identitystore_groups # Keeping for_each as it's the only way I can think of assigning multiple Psets
  principal_id       = each.key
  permission_set_arn = each.value
  instance_arn       = local.aws_ssoadmin_instance_arn
  principal_type     = var.principal_type
  target_id          = var.aws_account_identifier
  target_type        = "AWS_ACCOUNT" # Keep entity type for which the assignment will be created as is
}

