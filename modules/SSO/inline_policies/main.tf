/**
This module contains all the permission sets for a project
It will define individual permission sets as inline policies 
Either replication or defined as customer policies. 
Included in that is a variable for a tag that will only allow access to resources with the same tag

Update tag for a new set of rules
*/
data "aws_ssoadmin_instances" "this" {} # need to grab the sso instance data

data "aws_identitystore_group" "this" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = var.inline_policy_name
    }
  }
}

# Define the inline policy permission sets
resource "aws_ssoadmin_permission_set" "this" {
  name             = var.inline_policy_name
  description      = var.inline_policy_desc != "" ? var.inline_policy_desc : var.inline_policy_name
  instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  session_duration = var.session_duration
  tags = {
    filter = var.project_tag_value
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
  inline_policy      = var.policy_json
}

data "aws_ssoadmin_permission_set" "this" {
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  name         = var.inline_policy_name
  depends_on   = [aws_ssoadmin_permission_set.this]
}