variable "bucket_name" {
  type        = string
  description = "The GCS bucket name for remote state"
}

variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "region" {
  type        = string
  description = "The GCP region"
}