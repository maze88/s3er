data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "ls_bucket_and_all_object_actions" {
  name   = "demo-eks-oidc-s3-bucket-accesser"
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
          "Federated" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.oidc_provider}"
        }
        Condition = {
          StringEquals = {
            "${var.oidc_provider}:sub" = "system:serviceaccount:${var.service_account_namespace}:${var.service_account_name}"
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
