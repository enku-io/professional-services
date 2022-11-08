# Docs: 
# Feature store: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/vertex_ai_featurestore
# Entity Type: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/vertex_ai_featurestore_entitytype
# Feature: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/vertex_ai_featurestore_entitytype_feature

# Basic online serving Featurestore
resource "google_vertex_ai_featurestore" "featurestore" {
  provider = google-beta
  name     = "terraform_fs_example"
  labels = {
    foo = "bar"
  }
  region   = "us-central1"
  online_serving_config {
    fixed_node_count = 2 #Enables online serving 
  }
}

# EntityType monitoring the Featurestore
resource "google_vertex_ai_featurestore_entitytype" "entity" {
  provider = google-beta
  name     = "terraform_et_example"
  labels = {
    foo = "bar"
  }
  featurestore = google_vertex_ai_featurestore.featurestore.id
  monitoring_config {
    snapshot_analysis {
      disabled = false
      monitoring_interval = "86400s"
    }
  }
}

# Feature Integer sitting inside the EntityType
resource "google_vertex_ai_featurestore_entitytype_feature" "feature" {
  provider = google-beta
  name     = "terraform_f_example"
  labels = {
    foo = "bar"
  }
  entitytype = google_vertex_ai_featurestore_entitytype.entity.id

  value_type = "INT64_ARRAY"
}
