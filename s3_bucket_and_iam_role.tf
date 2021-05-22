terraform {
  required_version = ">= 0.13"
}

provider "aws" {
  version = ">= 2.28.1"
  profile = "default"
  region  = "eu-west-2"
}

resource "aws_s3_bucket" "demo_bucket" {
  // CHANGEME!
  bucket = "mz-demo-bucket-tf"
}

resource "aws_s3_bucket_public_access_block" "demo_bucket" {
  bucket                  = aws_s3_bucket.demo_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_policy" "ls_bucket_and_all_object_actions" {
  name   = "demo-eks-oidc-s3-bucket-accesser-tf"
  path   = "/"
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action   = [
          "s3:ListBucket",
          "s3:*Object"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.demo_bucket.id}",
          "arn:aws:s3:::${aws_s3_bucket.demo_bucket.id}/*"
        ]
      },
    ]
  })
}

resource "aws_iam_role" "demo_eks_oidc_s3_bucket_accesser" {
  name               = aws_iam_policy.ls_bucket_and_all_object_actions.name
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRoleWithWebIdentity"
        Effect    = "Allow"
        Principal = {
          // CHANGEME! (account number, region, id)
          "Federated" = "arn:aws:iam::291615460784:oidc-provider/oidc.eks.eu-west-2.amazonaws.com/id/71E28602A1EF7B2894FBD143868BDC38"
        }
        Condition = {
          StringEquals = {
            // CHANGEME! (account number, region, id)
            "oidc.eks.eu-west-2.amazonaws.com/id/71E28602A1EF7B2894FBD143868BDC38:sub" = "system:serviceaccount:default:demo-s3er"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "demo_eks_oidc_s3_bucket_accesser" {
  policy_arn = aws_iam_policy.ls_bucket_and_all_object_actions.arn
  role       = aws_iam_role.demo_eks_oidc_s3_bucket_accesser.name
}
