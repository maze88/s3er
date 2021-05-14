# S3er mock app chart for demoing AWS IAM Roles for K8s ServiceAccounts via OIDC

## About
This helm chart is for a mock application which interacts with AWS, for a demo project about granting AWS IAM roles to Kubernetes Pods using ServiceAccounts and OIDC (OpenID Connect). The application uploads and deletes mock files from an S3 bucket every several seconds, logging each iteration and listing the bucket contents.

## Cloud prerequisites (and creation instructions/references)
- AWS S3 bucket - can be created with `aws s3 mb s3://my-demo-bucket --region eu-west-2`.
- AWS IAM role with attached policy granting permissions to act in above bucket - TBD: `aws TBD`.
- AWS EKS cluster - TBD: <portfolio/terraform/eks-spot-cluster>.
- AWS IAM OIDC Identity provider - see branch `oidc` in above repository.

## Architecture
- An AWS IAM role (and attached policy) must exist. They define the permitted actions (such as with an S3 bucket).
- A Kubernetes ServiceAccount is created and associated with the IAM role via an annotation in its metadata.
- An AWS IAM Identity provider (of type OIDC) must exist. This creates a trust relationship between the cluster and AWS.
- The ServiceAccount is attached to a Pod, granting it the AWS permissions defined in the IAM role.

## AWS documentation link
https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
