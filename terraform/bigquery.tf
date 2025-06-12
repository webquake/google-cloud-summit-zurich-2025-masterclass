resource "google_bigquery_connection" "connection" {
  connection_id = "masterclass"
  location      = "US"
  description   = "A connection to Vertex AI resources"
  cloud_resource {}
}
