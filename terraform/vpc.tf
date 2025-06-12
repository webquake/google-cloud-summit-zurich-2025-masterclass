resource "google_compute_network" "my_network" {
  name                    = var.network_name
  auto_create_subnetworks = true
  project                 = var.project_id
}
