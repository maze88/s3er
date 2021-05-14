# S3er mock app chart for demoing AWS IAM Roles for K8s ServiceAccounts via OIDC

## About
This helm chart is for a mock application which interacts with AWS, for a demo project about granting AWS IAM roles to Kubernetes Pods using ServiceAccounts and OIDC (OpenID Connect). The application uploads and deletes mock files from an S3 bucket every several seconds, logging each iteration and listing the bucket contents.

## Architecture
- An AWS IAM role (and attached policy) must exist. They define the permitted actions (such as with an S3 bucket).
- A Kubernetes ServiceAccount is created and associated with the IAM role via an annotation in its metadata.
- An AWS IAM Identity provider (of type OIDC) must exist. This creates a trust relationship between the cluster and AWS.
- The ServiceAccount is attached to a Pod, granting it the AWS permissions defined in the IAM role.

## AWS documentation link
https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
