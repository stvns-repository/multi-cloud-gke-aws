resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = "us-west1-b"

  remove_default_node_pool = true
  initial_node_count       = 1
  
  deletion_protection      = false

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  depends_on = [
    google_project_service.container,
    google_project_service.iam
  ]
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = "us-west1-b"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}