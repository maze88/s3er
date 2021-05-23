terraform {
  required_version = ">= 0.13"
}

provider "aws" {
  version = ">= 2.28.1"
  profile = "default"
  region  = "eu-west-2"
}
