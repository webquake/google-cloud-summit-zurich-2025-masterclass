resource "google_colab_runtime_template" "default_runtime_template" {
  name         = var.runtime_template_name
  display_name = var.runtime_template_display_name
  location     = var.region

  machine_spec {
    machine_type = var.machine_type
  }

  network_spec {
    enable_internet_access = true
  }

  depends_on = [
    google_project_service.compute_api,
    google_project_service.aiplatform_api,
    google_project_service.notebooks_api,
    google_compute_network.my_network
  ]
}

## Colab Notebook Executions

resource "google_colab_notebook_execution" "lab_setup_execution" {
  display_name = "Lab Setup"
  location     = var.region

  gcs_notebook_source {
    uri = "gs://${google_storage_bucket.notebook_bucket.name}/notebooks/Lab Setup.ipynb"
  }
  gcs_output_uri = "gs://${google_storage_bucket.notebook_bucket.name}/output"

  notebook_runtime_template_resource_name = google_colab_runtime_template.default_runtime_template.id
  execution_user                          = var.runtime_owner

  depends_on = [
    google_colab_runtime_template.default_runtime_template,
    google_storage_bucket.notebook_bucket,
    google_storage_bucket_object.lab_setup_notebook
  ]
}