# Doc: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/vertex_ai_metadata_store

# Basic Metadata Store
resource "google_vertex_ai_metadata_store" "store" {
  name          = "default"
  description   = "Store to test the terraform module"
  region        = "us-central1"
  provider      = google-beta
}