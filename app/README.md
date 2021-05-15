# S3er mock/demo app

## About
This is a mock application I wrote for a demo project (about granting AWS IAM roles to Kubernetes Pods using ServiceAccounts and OIDC). The application uploads and deletes mock files from an S3 bucket every several seconds, logging each iteration and listing the bucket contents.

## Configuration

### AWS
* The _boto3_ Python package is used to interact with AWS. See its documentation on ways to configure: https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html#configuration

### Application
The application reads its configuration from environment variables:
* `BUCKET_NAME` - The name of an existing S3 bucket to work with (**REQUIRED**).
* `SLEEP_SECONDS_OVERRIDE` - Overrides the default value (8) of seconds to wait between each iteration (OPTIONAL).

