variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "state_bucket_name" {
  description = "Name for the S3 bucket to store Terraform state"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name for the DynamoDB table for state locking"
  type        = string
}