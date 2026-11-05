# Dynamically locate your Phase-1 VPC by its exact name. 
# If you tagged the VPC and subnets on phase-1-foundation/vpc.aws.tf, you can use it instead of the hard-coded name approach I used.
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["portable-k8s-aws-vpc"]
  }
}

# Fetch the public subnets inside this VPC
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name   = "tag:Name" # Matches standard public subnet tagging conventions from phase-1
    values = ["portable-k8s-public-*"]

  }
}

data "aws_security_group" "cluster_sg" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["eks-cluster-sg-portable-k8s-cluster-*"]
  }
}