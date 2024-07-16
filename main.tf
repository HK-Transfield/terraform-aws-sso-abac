# Can remove for_each loop to make assignment easier
resource "aws_ssoadmin_account_assignment" "AWS-Administrator" {
  for_each = {
    (data.aws_identitystore_group.AWS-Administrator.group_id) = (data.aws_ssoadmin_permission_set.AWS-Administrator.arn)
  }

  instance_arn       = data.aws_ssoadmin_instances.my_sso_instances.arns[0]
  permission_set_arn = each.value
  principal_id       = each.key
  principal_type     = "GROUP"
  target_id          = "008582684493" # Make this a variable as well
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "AWS-Database-Administrator" {
  for_each = {
    (data.aws_identitystore_group.AWS-Administrator.group_id) = (data.aws_ssoadmin_permission_set.AWS-Database-Administrator.arn)
  }

  instance_arn       = data.aws_ssoadmin_instances.my_sso_instances.arns[0]
  permission_set_arn = each.value
  principal_id       = each.key
  principal_type     = "GROUP"
  target_id          = "008582684493"
  target_type        = "AWS_ACCOUNT"
}
