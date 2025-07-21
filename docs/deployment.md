# Deployment Instructions

## Lambda/API Deployment

1. Ensure you have bootstrapped the backend (S3/DynamoDB) using the `infrastructure/bootstrap` Terraform.
2. Deploy the main infrastructure (Lambdas, API Gateway, DynamoDB) using the Terraform in `infrastructure/terraform`.
3. After `terraform apply`, note the API Gateway endpoint output.

## Frontend Deployment

1. Set the API base URL in `frontend/src/index.html` (replace `<PASTE_API_GATEWAY_URL_HERE>` with the output from Terraform).
2. Build the frontend:
   ```sh
   cd frontend
   npm ci
   npm run build
   ```
3. Deploy the build to S3:
   ```sh
   aws s3 sync dist s3://<your-frontend-bucket>/ --delete
   ```

## CI/CD

- The GitHub Actions workflow `.github/workflows/deploy-frontend.yml` will build and deploy the frontend to S3 on every push to `main`.
- Set the following GitHub repository secrets:
  - `AWS_GITHUB_ROLE_ARN`: The ARN of the IAM role for GitHub Actions
  - `AWS_REGION`: The AWS region
  - `S3_BUCKET_NAME`: The name of your frontend S3 bucket

## Notes
- Update IAM policies as needed for new AWS resources.
- See `README.md` and `docs/architecture.md` for more details.
