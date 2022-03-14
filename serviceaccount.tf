#net1
resource "google_service_account" "serviceaccount_1" {
  account_id   = "serviceaccount-1"
  display_name = "serviceaccount-1"
}
resource "google_project_iam_member" "project-network1" {
  project = "gcp-ngt-training"
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.serviceaccount_1.email}"

}
#net2
resource "google_service_account" "serviceaccount_2" {
  account_id   = "serviceaccount-2"
  display_name = "serviceaccount-2"
}

resource "google_project_iam_member" "project-network2" {
  project = "gcp-ngt-training"
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.serviceaccount_2.email}"

}
