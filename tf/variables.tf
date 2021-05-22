variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket to create"
  default     = "mz-demo-bucket"
}

variable "oidc_provider" {
  type        = string
  description = "The OIDC provider URL"
  default     = "oidc.eks.eu-west-2.amazonaws.com/id/CHANGEME12345678"
}

variable "service_account_namespace" {
  type        = string
  description = "The namespace of the Kubernetes ServiceAccount"
  default     = "default"
}

variable "service_account_name" {
  type        = string
  description = "The name of the Kubernetes ServiceAccount"
  default     = "demo-s3er"
}
