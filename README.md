# S3er mock app chart for demoing AWS IAM Roles for K8s ServiceAccounts via OIDC

## About
This helm chart is for a mock application which interacts with AWS, for a demo project about granting AWS IAM roles to Kubernetes Pods using ServiceAccounts and OIDC. The application uploads and deletes mock files from an S3 bucket every several seconds, logging each iteration and listing the bucket contents.

## AWS documentation link
https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
