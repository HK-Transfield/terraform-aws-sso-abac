data "aws_ssoadmin_instances" "this" {} # need to grab the sso instance data

module "network_account_assignment" {
  source                 = "./modules/account_assignment"
  aws_account_identifier = "211125790048"

  aws_identitystore_groups = {
    (data.aws_identitystore_group.AWS-Administrator.group_id)         = (data.aws_ssoadmin_permission_set.AWS-Administrator.arn)
    (data.aws_identitystore_group.AWS-Billing-Administrator.group_id) = (data.aws_ssoadmin_permission_set.AWS-Billing-Administrator.arn)
  }
}