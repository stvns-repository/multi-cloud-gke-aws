# GCP Backend configuration. The 'actual bucket name' is on the backend.hcl file
terraform {
  backend "gcs" {
    prefix = "gcp/foundation"
  }
}