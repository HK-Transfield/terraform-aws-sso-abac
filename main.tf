data "aws_ssoadmin_instances" "this" {} # need to grab the sso instance data

module "network_account_assignment" {
  source                 = "./modules/account_assignment"
  aws_account_identifier = "XXXXXXXXXXXX"

  aws_identitystore_groups = {
    (data.aws_identitystore_group.AWS-Administrator.group_id)         = (data.aws_ssoadmin_permission_set.AWS-Administrator.arn)
    (data.aws_identitystore_group.AWS-Billing-Administrator.group_id) = (data.aws_ssoadmin_permission_set.AWS-Billing-Administrator.arn)
  }
}

# Can remove for_each loop to make assignment easier
# resource "aws_ssoadmin_account_assignment" "AWS-Administrator" {
#   for_each = {
#     (data.aws_identitystore_group.AWS-Administrator.group_id) = (data.aws_ssoadmin_permission_set.AWS-Administrator.arn)
#   }

#   instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   permission_set_arn = each.value
#   principal_id       = each.key
#   principal_type     = "GROUP"
#   target_id          = "XXXXXXXXXXXX" # Make this a variable as well
#   target_type        = "AWS_ACCOUNT"
# }