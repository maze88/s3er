# S3er mock app chart for demoing AWS IAM Roles for Kubernetes ServiceAccounts via OIDC

## About
This helm chart is for a mock application which interacts with AWS, for a demo project about granting AWS IAM roles to Kubernetes Pods using ServiceAccounts and OIDC (OpenID Connect). The application (included under `app/`) uploads and deletes mock files from an S3 bucket every several seconds, see `app/README.md` for more information about it.

## Cloud prerequisites (and creation instructions/references)
- AWS S3 bucket - can be created with `aws s3 mb s3://your-demo-bucket --region eu-west-2` (replace with your bucket name and region of choice).
- AWS IAM role with attached policy granting permissions to act in above bucket - TBD: `aws TBD`.
- AWS EKS cluster - can be created using my repository [TBD:eks-spot-cluster](../eks-spot-cluster).
- AWS IAM OIDC Identity provider - see branch `oidc` in above repository.

## Architecture
- An AWS IAM role (and attached policy) must exist. They define the permitted actions on AWS.
- A Kubernetes ServiceAccount is created and annotated with the IAM role in its metadata. This allows Kubernetes to generate OIDC tokens for AWS.
- The ServiceAccount is attached to a Pod, providing the pod with the permissioned defined in it (`sts:AssumeRoleWithWebIdentity`).
- An AWS IAM Identity provider (of type OIDC) must exist for the cluster. This allows validation of the OIDC tokens, hence creating a trust relationship between AWS and the Kubernetes cluster.

More [info about IAM roles for ServiceAccounts can be found in the AWS documentation](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html).
