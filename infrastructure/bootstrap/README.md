- [github.com | oidc to aws](https://docs.github.com/en/actions/how-tos/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
- [aws.com | oidc from github](https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/)
- [github.blog | oidc confusion](https://github.blog/changelog/2022-01-13-github-actions-update-on-oidc-based-deployments-to-aws/)
- [github.com | terraform module](https://github.com/terraform-module/terraform-aws-github-oidc-provider/tree/master)

Honestly, the amount of information on this is alot, I've got the jist of the whole thing, but the details are elusive, I'm trying to verify what I can;

## Manually checking OIDC fingerprint

```bash
openssl s_client -servername token.actions.githubusercontent.com -connect token.actions.githubusercontent.com:443 < /dev/null 2> /dev/null \
  | openssl x509 -fingerprint -noout \
  | cut -d '=' -f 2 \
  | tr -d ':' \
  | tr '[:upper:]' '[:lower:]'
```

## 🔄 How the Authentication Flow Works

Here’s a simplified breakdown of how GitHub Actions authenticates with AWS using OIDC:

```mermaid
flowchart TD
  A[GitHub Action starts] --> B[OIDC Token Requested]
  B --> C[GitHub OIDC Provider issues JWT]
  C --> D[JWT includes claims: sub, aud, iss]
  D --> E[AWS IAM Role Trust Policy checks JWT]
  E --> F[Thumbprint of GitHub TLS cert (SHA-1) validated]
  F --> G[GitHub Action assumes IAM Role via sts:AssumeRoleWithWebIdentity]
  G --> H[Temporary AWS credentials issued]
  H --> I[Terraform Plan executed with AWS access]
```

## 🧠 Summary of Key Steps

- **GitHub** generates a short-lived **JWT** via its OIDC provider (`token.actions.githubusercontent.com`)
- The JWT includes claims like `sub` (subject), which must match the trust policy in AWS
- AWS uses the **SHA-1 thumbprint** to verify GitHub’s TLS certificate
- If everything checks out, AWS issues temporary credentials to the GitHub Action