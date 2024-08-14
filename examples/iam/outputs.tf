output "Arnav_psswrd" {
  value = module.Arnav.password
}

output "Mary_psswrd" {
  value = aws_iam_user_login_profile.Mary.password
}

output "Saanvi_psswrd" {
  value = aws_iam_user_login_profile.Saanvi.password
}

output "Carlos_psswrd" {
  value = aws_iam_user_login_profile.Carlos.password
}