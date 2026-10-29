# Multi-Cloud Infrastructure (GCP & AWS)

[![Project Status: In Progress](https://img.shields.io/badge/status-in_progress-yellow.svg)](#)

> **Work in Progress:** This repository contains an ongoing multi-cloud infrastructure deployment utilizing **Terraform** to provision and configure decoupled, production-grade Kubernetes environments across **Google Cloud Platform (GCP)** and **Amazon Web Services (AWS)**.

---

## Architecture Overview

This repository is constructed in a way that thed execution phases (using remote state references) are decoupled to ensure clear separation of concerns, basic security boundaries, and modular lifecycle management:

- **Phase 1: Foundation**
  - **GCP:** VPC creation, custom subnets, secondary IP ranges, and GKE cluster provisioning.
  - **AWS:** VPC networking, subnets, routing, and EKS cluster provisioning.
- **Phase 2: Security & Identity** *(Upcoming)*
  - **GCP:** Google Service Accounts (GSA) and Workload Identity IAM bindings (`roles/iam.workloadIdentityUser`).
  - **AWS:** IAM Roles for Service Accounts (IRSA) and OIDC federated trust policies.
- **Phase 3: Workloads & Networking** *(Upcoming)*
  - Cross-cluster networking, ingress routing, and workload deployments.

---

## Backend & State Architecture

- **Partial Configurations:** Terraform backends are decoupled using `backend.hcl` files per phase/cloud provider.
- **Naming Conventions & Isolation:**
  - GCP State Prefix: `gcp/foundation`, `gcp/security`
  - AWS State Prefix: `aws/foundation`, `aws/security`

---

## Deployment & Verification

### Phase 1 Initializations
```bash
# GCP Foundation
cd terraform/gcp/phase-1
terraform init -backend-config=backend.hcl
terraform plan -var="project_id=YOUR_PROJECT_ID"
terraform apply -var="project_id=YOUR_PROJECT_ID"

# AWS Foundation
cd terraform/aws/phase-1
terraform init -backend-config=backend.hcl
terraform plan
terraform apply