################################################################################
# IAM Identity Center Access Control Attributes
################################################################################
data "aws_ssoadmin_instances" "this" {}

locals {
  sso_instance_arns = tolist(data.aws_ssoadmin_instances.this.arns)
  sso_instance_arn  = length(local.sso_instance_arns) > 0 ? local.sso_instance_arns[0] : ""
}

resource "aws_ssoadmin_instance_access_control_attributes" "this" {
  count        = length(keys(var.attributes)) > 0 ? 1 : 0
  instance_arn = local.sso_instance_arn

  dynamic "attribute" {
    for_each = var.attributes
    content {
      key = attribute.key
      value {
        source = [attribute.value]
      }
    }
  }

  lifecycle {
    precondition {
      condition     = local.sso_instance_arn != ""
      error_message = "No AWS IAM Identity Center instances found. Ensure IAM Identity Center is enabled."
    }
  }
}