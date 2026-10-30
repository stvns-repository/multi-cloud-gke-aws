# Portable Kubernetes Infrastructure (AWS EKS and GCP GKE)

[![Project Status: In Progress](https://img.shields.io/badge/status-in_progress-yellow.svg)](#)

> **Work in Progress:** This repository contains an ongoing portable infrastructure deployment utilizing **Terraform** to provision and configure decoupled, Kubernetes environments on **Google Cloud Platform (GCP)** and **Amazon Web Services (AWS)** respectively.

---

## Architecture Overview

This repository is constructed in a way that the execution phases (using remote state references) are decoupled to ensure clear separation of concerns, basic security boundaries, and modular lifecycle management:

- **Phase 1: Foundation**
  - **GCP:** VPC creation, custom subnets, secondary IP ranges, and GKE cluster provisioning.
  - **AWS:** VPC networking, subnets, routing, and EKS cluster provisioning.
- **Phase 2: Security & Identity** 
  - **GCP:** Google Service Accounts (GSA) and Workload Identity IAM bindings (`roles/iam.workloadIdentityUser`). *(Upcoming)*
  - **AWS:** IAM Roles for Service Accounts (IRSA) and OIDC federated trust policies.
- **Phase 3: Workloads & Initial Kubernetes components (with testing)** 
  - **GCP:** *(Upcoming)*
  - **AWS:** Deploy a containerized multi-component app stack that simulates an active workload via GitOps. 
             Deploy a pre-defined Kubernetes manifests, and validate.
- **Phase 4: ArgoCD and Observability** *(Upcoming)*

---

## Backend & State Architecture

- **Partial Configurations:** Terraform backends are decoupled using `backend.hcl` files per phase/cloud provider.
- **Naming Conventions & Isolation:**
  - GCP State Prefix: `gcp/foundation`, `gcp/security`
  - AWS State Prefix: `aws/foundation`, `aws/security`

---
## Security & Governance

To maintain standards across the files for this specific project, I decided to integrate **Trivy** for automated security scanning.
You are free to remove the trivy.yml from the .github/workflows directory.

---
## Deployment & Verification

### Phase 1 Initializations
```bash
# GCP Foundation
cd terraform/gcp/phase-1-foundation
terraform init -backend-config=backend.hcl
terraform plan -var="project_id=YOUR_PROJECT_ID"
terraform apply -var="project_id=YOUR_PROJECT_ID"

# AWS Foundation
cd terraform/aws/phase-1-foundation
terraform init -backend-config=backend.hcl
terraform plan
terraform apply

### Phase 2 Initialization
*(Upcoming)*

### Phase 3 Initializatio
*(Upcoming)*