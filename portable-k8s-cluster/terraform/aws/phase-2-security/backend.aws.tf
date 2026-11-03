terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    key          = "aws/security/terraform.tfstate"
    region       = "us-west-2"
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-west-2"
}