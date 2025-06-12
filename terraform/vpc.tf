# Use a data source to reference an existing VPC network
data "google_compute_network" "existing_network" {
  name    = var.network_name
  project = var.project_id
}

# Only create the network if it doesn't exist and create_network is true
resource "google_compute_network" "my_network" {
  count                   = var.create_network ? 1 : 0
  name                    = var.network_name
  auto_create_subnetworks = true
  project                 = var.project_id
}
