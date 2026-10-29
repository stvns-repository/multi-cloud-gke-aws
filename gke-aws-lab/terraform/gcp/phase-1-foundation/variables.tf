variable "project_id" {
  type        = string
  description = "Your Google Cloud Project ID"
}

# Equivalent of us-west-2/Oregon region in AWS 
variable "region" {
  type        = string
  default     = "us-west1"
  description = "Target GCP region"
}

variable "cluster_name" {
  type        = string
  default     = "multi-cloud-cluster"
  description = "Name of the GKE cluster"
}