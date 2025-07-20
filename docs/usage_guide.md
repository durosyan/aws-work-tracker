## Requirements

- AWS Account
- Route53 hosted zone with domain
- IAM Role with required permissions

## Setup terraform remote state S3 bucket

1. Get some access keys from the admin role
2. Setup AWS CLI to use the correct thing
3. Run `terraform init` in infrastructure/bootstrap (comment out the backend configuration in backend.tf for this)
4. uncomment backend and then run `terraform init -migrate-state`