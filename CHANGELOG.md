[2026-10-29] - Initial Phase & Core Infrastructure Completion
Added
GCP Phase 1 (Foundation): Successfully provisioned core VPC networking, subnets, and GKE control plane/node pools from a clean state.

AWS Phase 1 (Foundation): Validated baseline VPC and EKS infrastructure state.

Trivy (Security): Scan files for any misconfiguration and vulnerabilities.

[2026-10-30]

AWS Phase 2 (Security): Deployed IRSA (IAM Role for Service Accounts). 

AWS Phase 3 (Workload): 
    - Introduced GitHub workflow for the CI/CD portion of phase 3, and succeeding phases.
    - Deployed app/ that contains the Docker components. This is further pushed to AWS ECR via GitHub actions.
    - Deployed the Kubernetes manifests/ file (locally) and validated through a quick simulation. 