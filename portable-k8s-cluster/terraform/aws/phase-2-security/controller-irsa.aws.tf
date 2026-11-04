# AWS Load Balancer Controller IRSA Trust Policy
data "aws_iam_policy_document" "controller_irsa_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.terraform_remote_state.phase1.outputs.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }

    principals {
      type        = "Federated"
      identifiers = [data.terraform_remote_state.phase1.outputs.oidc_provider_arn]
    }
  }
}

# IAM Role for the AWS Load Balancer Controller
resource "aws_iam_role" "controller_irsa_role" {
  name               = "portable-k8s-controller-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.controller_irsa_trust.json
}

resource "aws_iam_policy" "controller_iam_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy-Portable-K8s"
  description = "IAM policy for the AWS Load Balancer Controller"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:CreateServiceLinkedRole",
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeAddresses",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeVpcs",
          "ec2:DescribeVpcPeeringConnections",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeInstances",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeTags",
          "ec2:DescribeClassicLinkInstances",
          "ec2:DescribeRouteTables",
          "ec2:DescribeLoadBalancers",
          "ec2:DescribeLoadBalancerAttributes",
          "ec2:DescribeListeners",
          "ec2:DescribeListenerCertificates",
          "ec2:DescribeRules",
          "ec2:DescribeTargetGroups",
          "ec2:DescribeTargetGroupAttributes",
          "ec2:DescribeTargetHealth",
          "ec2:DescribeSSLCertificates",
          "ec2:CreateLoadBalancer",
          "ec2:DeleteLoadBalancer",
          "ec2:ModifyLoadBalancerAttributes",
          "ec2:SetSubnets",
          "ec2:SetSecurityGroups",
          "ec2:SetIpAddressType",
          "ec2:CreateTargetGroup",
          "ec2:DeleteTargetGroup",
          "ec2:ModifyTargetGroup",
          "ec2:ModifyTargetGroupAttributes",
          "ec2:RegisterTargets",
          "ec2:DeregisterTargets",
          "ec2:CreateListener",
          "ec2:DeleteListener",
          "ec2:ModifyListener",
          "ec2:CreateRule",
          "ec2:DeleteRule",
          "ec2:ModifyRule",
          "ec2:AddTags",
          "ec2:RemoveTags",
          "cognito-idp:DescribeUserPoolClient",
          "acm:ListCertificates",
          "acm:DescribeCertificate",
          "iam:GetServerCertificate",
          "iam:ListServerCertificates",
          "elasticloadbalancing:*",
          "wafv2:*",
          "shield:GetSubscriptionState",
          "waf-regional:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to the controller IRSA role
resource "aws_iam_role_policy_attachment" "controller_attach" {
  role       = aws_iam_role.controller_irsa_role.name
  policy_arn = aws_iam_policy.controller_iam_policy.arn
}