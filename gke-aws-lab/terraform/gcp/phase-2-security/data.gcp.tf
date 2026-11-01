data "terraform_remote_state" "phase1" {
  backend = "gcs"

  config = {
    bucket = var.bucket_name
    prefix = "gcp/foundation" # Match whatever your Phase 1 prefix was
  }
}