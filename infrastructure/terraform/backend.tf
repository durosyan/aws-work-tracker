terraform {
  required_version = ">= 0.12"
  
  backend "s3" {
    bucket         = "<YOUR_STATE_BUCKET_NAME>"
    key            = "terraform.tfstate"
    region         = "<YOUR_AWS_REGION>"
    dynamodb_table = "<YOUR_DYNAMODB_TABLE_NAME>" # optional, for state locking
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}