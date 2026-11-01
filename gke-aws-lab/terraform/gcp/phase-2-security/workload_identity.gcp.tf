# 1. Create a Google Service Account (GSA)
resource "google_service_account" "sample_gsa" {
  account_id   = "gke-sample-app-sa"
  display_name = "GKE Sample App Workload Identity SA"
}

# 2. Allow Kubernetes Service Account (KSA) to assume the GSA
resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = google_service_account.sample_gsa.name
  role               = "roles/iam.workloadIdentityUser"
  member = "serviceAccount:${var.project_id}.svc.id.goog[default/sample-app-sa]"
}