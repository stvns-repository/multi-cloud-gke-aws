# Wait for webhook
resource "null_resource" "wait_for_webhook" {
  depends_on = [helm_release.aws_load_balancer_controller]

  triggers = {
    controller_version = helm_release.aws_load_balancer_controller.version
  }

  provisioner "local-exec" {
    command = "sleep 120"
  }
}

# Create security group for the ALB, allowing port 80 inbound
resource "aws_security_group" "alb_sg" {
  name        = "portable-k8s-alb-sg"
  description = "Security group for external ALB ingress"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "Allow public HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "portable-k8s-alb-sg"
  }
}

# Attach the ingress rule to the EKS cluster SG allowing traffic from the ALB SG
resource "aws_security_group_rule" "eks_node_ingress_from_alb" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = data.aws_security_group.cluster_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
  description              = "Allow inbound traffic from ALB into EKS worker nodes"
}

# Argo CD Ingress
resource "kubernetes_ingress_v1" "argocd_ingress" {
  depends_on = [
    null_resource.wait_for_webhook,
    aws_security_group_rule.eks_node_ingress_from_alb
  ]

  metadata {
    name      = "argocd-ingress"
    namespace = "argocd"
    annotations = {
      "kubernetes.io/ingress.class"                         = "alb"
      "alb.ingress.kubernetes.io/scheme"                    = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"               = "ip"
      "alb.ingress.kubernetes.io/listen-ports"              = jsonencode([{ "HTTP" = 80 }])
      "alb.ingress.kubernetes.io/subnets"                   = join(",", data.aws_subnets.public.ids)
      "alb.ingress.kubernetes.io/security-groups"           = aws_security_group.alb_sg.id
      "alb.ingress.kubernetes.io/healthcheck-path"          = "/healthz"
      "alb.ingress.kubernetes.io/healthcheck-port"          = "8080"
      "alb.ingress.kubernetes.io/healthcheck-protocol"      = "HTTP"
      "alb.ingress.kubernetes.io/backend-protocol"          = "HTTP"
      "alb.ingress.kubernetes.io/target-group-attributes" = "stickiness.enabled=false"
    }
  }

  spec {
    rule {
      http {
        path {
          path      = "/argocd"
          path_type = "Prefix"
          backend {
            service {
              name = "argocd-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

output "alb_dns_name" {
  value       = try(kubernetes_ingress_v1.argocd_ingress.status[0].load_balancer[0].ingress[0].hostname, "Pending ALB provisioning...")
  description = "The public DNS endpoint for accessing Argo CD."
}