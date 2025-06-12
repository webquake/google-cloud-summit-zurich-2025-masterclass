resource "google_project_service" "compute_api" {
  project = var.project_id
  service = "compute.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "aiplatform_api" {
  project = var.project_id
  service = "aiplatform.googleapis.com"

  disable_on_destroy = false
  depends_on         = [google_project_service.compute_api]
}

# Colab Enterprise is part of Vertex AI
resource "google_project_service" "notebooks_api" {
  project = var.project_id
  service = "notebooks.googleapis.com"

  disable_on_destroy = false
  depends_on         = [google_project_service.aiplatform_api]
}
