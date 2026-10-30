data "terraform_remote_state" "phase1" {
  backend = "s3"

  config = {
    bucket = var.bucket_name
    key    = "aws/foundation/terraform.tfstate"
    region = "us-west-2"
  }
}

data "aws_caller_identity" "current" {}