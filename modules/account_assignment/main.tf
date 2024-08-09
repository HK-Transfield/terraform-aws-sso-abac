/*
This module assigns AWS accounts permission sets by adding them to the appropriate
IAM Identity Center group.
*/
data "aws_region" "this" {}
data "aws_ssoadmin_instances" "this" {}

# Assign permission set to accounts
resource "aws_ssoadmin_account_assignment" "this" {
  for_each           = var.aws_identitystore_groups # Keeping for_each as it's the only way I can think of assigning multiple Psets
  principal_id       = each.key
  permission_set_arn = each.value
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  principal_type     = var.principal_type
  target_id          = var.aws_account_identifier
  target_type        = "AWS_ACCOUNT" # Keep entity type for which the assignment will be created as is
}

