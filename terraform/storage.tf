resource "google_storage_bucket" "notebook_bucket" {
  name                        = var.notebook_bucket_name
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
}

# Upload Lab Setup notebook
resource "google_storage_bucket_object" "lab_setup_notebook" {
  name   = "notebooks/Lab Setup.ipynb"
  source = "${path.module}/../notebooks/Lab Setup.ipynb"
  bucket = google_storage_bucket.notebook_bucket.name
}

# Upload Lab 1 notebook
resource "google_storage_bucket_object" "lab1_notebook" {
  name   = "notebooks/Lab 1 - Multimodal Data Enrichment.ipynb"
  source = "${path.module}/../notebooks/Lab 1 - Multimodal Data Enrichment.ipynb"
  bucket = google_storage_bucket.notebook_bucket.name
}

# Upload Lab 2 notebook
resource "google_storage_bucket_object" "lab2_notebook" {
  name   = "notebooks/Lab 2 - Building a SQL-Powered RAG Pipeline.ipynb"
  source = "${path.module}/../notebooks/Lab 2 - Building a SQL-Powered RAG Pipeline.ipynb"
  bucket = google_storage_bucket.notebook_bucket.name
}
