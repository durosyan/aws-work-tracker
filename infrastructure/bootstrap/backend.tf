terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket       = "aws-work-tracker-tf-state"
    key          = "bootstrap/terraform.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
    encrypt      = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}