################################################################################
# title: AWS IAM Identity Center with ABAC Access
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
# IAM Policies and SSO Permission Sets
################################################################################

data "aws_iam_policy_document" "this" {
  # Actions allowed regardless of tags
  statement {
    sid       = "ReadOnlyAccess"
    effect    = "Allow"
    actions   = var.actions_readonly
    resources = var.resources_readonly
  }

  # Actions allowed when tags match
  statement {
    sid       = "ConditionalAccess"
    effect    = "Allow"
    actions   = var.actions_conditional
    resources = var.resources_conditional

    dynamic "condition" {
      for_each = var.attributes

      content {
        test     = "StringEquals"
        variable = "aws:ResourceTag/${condition.key}"
        values   = ["$${aws:PrincipalTag/${condition.key}}"]
      }
    }
  }
}

data "aws_ssoadmin_permission_set" "this" {
  instance_arn = local.sso_instance_arn
  name         = var.permission_set_name
  depends_on   = [aws_ssoadmin_permission_set.this]
}

resource "aws_ssoadmin_permission_set" "this" {
  name             = var.permission_set_name
  description      = var.permission_set_desc != "" ? var.permission_set_desc : var.permission_set_name
  instance_arn     = local.sso_instance_arn
  session_duration = var.session_duration
}

resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
  inline_policy      = data.aws_iam_policy_document.this.json
}

################################################################################
# IAM Identity Center
################################################################################

data "aws_identitystore_user" "this" {
  count             = strcontains(var.principal_type, "USER") ? 1 : 0
  identity_store_id = local.sso_instance_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = var.principal_name != "" ? var.principal_name : var.permission_set_name
    }
  }
}

data "aws_identitystore_group" "this" {
  count             = strcontains(var.principal_type, "GROUP") ? 1 : 0
  identity_store_id = local.sso_instance_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = var.principal_name != "" ? var.principal_name : var.permission_set_name
    }
  }
}

locals {
  user_id      = length(data.aws_identitystore_user.this) > 0 ? data.aws_identitystore_user.this[0].id : null
  group_id     = length(data.aws_identitystore_group.this) > 0 ? data.aws_identitystore_group.this[0].id : null
  principal_id = coalesce(local.user_id, local.group_id)
}

resource "aws_ssoadmin_account_assignment" "this" {
  for_each           = toset(var.account_identifiers)
  principal_id       = local.principal_id
  permission_set_arn = data.aws_ssoadmin_permission_set.this.arn
  instance_arn       = local.sso_instance_arn
  principal_type     = var.principal_type
  target_id          = each.value
  target_type        = "AWS_ACCOUNT"
}
