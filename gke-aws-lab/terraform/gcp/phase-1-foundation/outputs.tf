output "cluster_endpoint" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE cluster endpoint"
}

output "workload_identity_pool" {
  value       = google_container_cluster.primary.workload_identity_config[0].workload_pool
  description = "Workload Identity pool"
}

output "issuer_url" {
  value       = "https://container.googleapis.com/v1/projects/${var.project_id}/locations/${var.region}/clusters/${var.cluster_name}"
  description = "GKE OIDC Issuer URL. We'll use this for the AWS trust relationship later on"
}