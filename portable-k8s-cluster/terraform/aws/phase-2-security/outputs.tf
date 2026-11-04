output "controller_irsa_role_arn" {
  value       = aws_iam_role.controller_irsa_role.arn
  description = "ARN of the IAM role for the AWS LB Controller for Phase 5"
}