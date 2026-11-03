# IRSA Trust Policy
data "aws_iam_policy_document" "sample_irsa_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.terraform_remote_state.phase1.outputs.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:sample-app-sa"]
    }

    principals {
      type        = "Federated"
      identifiers = [data.terraform_remote_state.phase1.outputs.oidc_provider_arn]
    }
  }
}

# IAM Role for Kubernetes Service Account
resource "aws_iam_role" "sample_irsa_role" {
  name               = "multi-cloud-eks-sample-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.sample_irsa_trust.json
}