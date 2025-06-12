# Fixing Argolis Org Policies

resource "google_project_organization_policy" "shielded_vm_policy" {
  project    = var.project_id
  constraint = "constraints/compute.requireShieldedVm"

  restore_policy {
    default = true
  }
}

resource "google_project_organization_policy" "vm_external_ip_access_policy" {
  project    = var.project_id
  constraint = "constraints/compute.vmExternalIpAccess"

  restore_policy {
    default = true
  }
}
