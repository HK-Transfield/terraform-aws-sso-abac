
resource "aws_iam_user" "this" {
  name = var.name
  path = var.path

  tags = var.tags
}

resource "aws_iam_user_login_profile" "this" {
  user = aws_iam_user.this.name
}

resource "aws_iam_user_group_membership" "this" {
  user   = aws_iam_user.this.name
  groups = var.groups
}