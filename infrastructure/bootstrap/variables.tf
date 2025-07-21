variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "state_bucket_name" {
  description = "Name for the S3 bucket to store Terraform state"
  type        = string
}

# OIDC provider for GitHub Actions

variable "role_name" {
  type        = string
  description = "Name of the IAM role for GitHub Actions"
}

variable "repo_owner" {
  type        = string
  description = "GitHub repository owner"
}

variable "repo_name" {
  type        = string
  description = "GitHub repository name"
}

variable "branch" {
  type        = string
  description = "Branch to allow in the trust relationship"
  default     = "main"
}

# this is entirely optional and it says that AWS will pull it automatically..
# variable "thumbprint" {
#   type        = string
#   description = "TLS thumbprint of GitHub's OIDC provider"
#   # default     = "6938fd4d98bab03faadb97b34396831e3780aea1" # GitHub's OIDC thumbprint
#   # 7560d6f40fa55195f740ee2b1b7c0b4836cbe103 <- manual check outputs this?
# }
