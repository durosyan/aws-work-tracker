output "state_bucket_name" {
  value = aws_s3_bucket.tf_state.id
}

output "role_arn" {
  value = aws_iam_role.github_actions.arn
}
