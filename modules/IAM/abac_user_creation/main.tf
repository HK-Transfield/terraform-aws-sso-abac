resource "aws_iam_user" "this" {
  name = "access-Arnav-peg-eng"
  path = "/"

  tags = var.tags
}

resource "aws_iam_user_login_profile" "this" {
  user = aws_iam_user.this.name
}

resource "aws_iam_user_group_membership" "this" {
  user   = aws_iam_user.this.name
  groups = [aws_iam_group.this.name]
}