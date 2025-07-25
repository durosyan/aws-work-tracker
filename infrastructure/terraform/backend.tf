terraform {
  required_version = ">= 1.12.0"

  backend "s3" {
    bucket       = "aws-work-tracker-tf-state"
    key          = "terraform.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
    encrypt      = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.81.0"
    }
  }
}