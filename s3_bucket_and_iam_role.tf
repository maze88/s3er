provider "aws" {
  region = "eu-west-2"
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "mz-demo-bucket"
}

resource "aws_s3_bucket_public_access_block" "demo_bucket" {
  bucket                  = aws_s3_bucket.demo_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_policy" "ls_bucket_and_all_object_actions" {
  name   = "${aws_iam_role.demo_eks_oidc_s3_bucket_accesser.name}"
  path   = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "LsBucketAndAllObjectActions",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:*Object"
      ],
      "Resource": [
        "arn:aws:s3:::mz-demo-bucket",
        "arn:aws:s3:::mz-demo-bucket/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "demo_eks_oidc_s3_bucket_accesser" {
  name               = "demo-eks-oidc-s3-bucket-accesser"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::291615460784:oidc-provider/oidc.eks.eu-west-2.amazonaws.com/id/71E28602A1EF7B2894FBD143868BDC38"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.eu-west-2.amazonaws.com/id/71E28602A1EF7B2894FBD143868BDC38:sub": "system:serviceaccount:default:demo-s3er"
        }
      }
    }
  ]
}
EOF
  max_session_duration = 3600
  tags {
    owner = "Michael Zeevi"
  }
}
