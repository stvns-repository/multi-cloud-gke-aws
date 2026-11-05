# Reference Phase 1 remote state for VPC and cluster configuration
data "terraform_remote_state" "phase1" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "aws/foundation/terraform.tfstate"
    region = "us-west-2"
  }
}

# Reference Phase 2 remote state for the pre-built IRSA role ARN
data "terraform_remote_state" "phase2" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "aws/security/terraform.tfstate"
    region = "us-west-2"
  }
}

# Helm release for the AWS Load Balancer Controller using the Phase 2 IRSA role
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.6.0"

  set {
    name  = "clusterName"
    value = "portable-k8s-cluster"
  }
  
  set {
    name  = "region"
    value = "us-west-2"
  }

  set {
    name  = "vpcId"
    value = data.aws_vpc.vpc.id
  }
  
  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = data.terraform_remote_state.phase2.outputs.controller_irsa_role_arn
  }
}