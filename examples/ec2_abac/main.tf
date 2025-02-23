data "aws_region" "current" {}
data "aws_ssoadmin_instances" "this" {}

provider "aws" {
  region = data.aws_region.current.name
  alias  = "member_account"

  assume_role {
    role_arn = "arn:aws:iam::${var.account_ids[0]}:role/OrganizationAccountAccessRole"
  }
}

################################################################################
# EC2 Instances
################################################################################

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "heart" {
  provider      = aws.member_account
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"

  tags = {
    Name         = "heart-instance"
    CostCenter   = "123456"
    Organization = "MyOrg"
    Division     = "eng"
    Department   = "heart"
  }
}

resource "aws_instance" "diamond" {
  provider      = aws.member_account
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"

  tags = {
    Name         = "diamond-instance"
    CostCenter   = "654321"
    Organization = "MyOrg"
    Division     = "eng"
    Department   = "diamond"
  }
}
################################################################################
# IAM Identity Center ABAC Attributes
################################################################################

module "ec2_abac_attributes" {
  source = "../../modules/abac-attributes"
  attributes = {
    "CostCenter"   = "$${path:enterprise.costCenter}"
    "Organization" = "$${path:enterprise.organization}"
    "Division"     = "$${path:enterprise.division}"
    "Department"   = "$${path:enterprise.department}"
  }
}

################################################################################
# IAM Identity Center ABAC Permission Sets
################################################################################

module "ec2_abac_permissions" {
  source              = "../../modules/abac-permissions"
  permission_set_name = "EC2AllowAccessEngineers"
  principal_name      = "engineering-division"
  principal_type      = "GROUP"
  account_identifiers = var.account_ids
  attributes = {
    "Division"   = "$${path:enterprise.division}"
    "Department" = "$${path:enterprise.department}"
  }

  actions_readonly = [
    "ec2:DescribeInstances",
  ]

  actions_conditional = [
    "ec2:StartInstances",
    "ec2:StopInstances"
  ]
}