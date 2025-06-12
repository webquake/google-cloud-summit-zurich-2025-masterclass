output "colab_enterprise_console_url" {
  description = "URL to access Colab Enterprise in Google Cloud Console"
  value       = "https://console.cloud.google.com/vertex-ai/colab/runtimes?project=${var.project_id}"
}

output "bigquery_console_url" {
  description = "URL to access BigQuery in Google Cloud Console"
  value       = "https://console.cloud.google.com/bigquery?project=${var.project_id}"
}
