# Doc: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/notebooks_instance

# Basic Notebook
resource "google_notebooks_instance" "basic_nb" {
  name = "basic-notebooks-instance"
  location = "us-central1-a"
  machine_type = "e2-medium"
  vm_image {
    project      = "deeplearning-platform-release"
    image_family = "tf-latest-cpu"
  }
}

# Container Notebook
resource "google_notebooks_instance" "container_nb" {
  name = "container-notebooks-instance"
  location = "us-central1-a"
  machine_type = "e2-medium"
  metadata = {
    proxy-mode = "service_account"
    terraform  = "true"
  }
  container_image {
    repository = "gcr.io/deeplearning-platform-release/base-cpu"
    tag = "latest"
  }
}

# GPU Notebook
resource "google_notebooks_instance" "gpu_nb" {
  name = "gpu-notebooks-instance"
  location = "us-central1-a"
  machine_type = "n1-standard-1" // can't be e2 because of accelerator

  install_gpu_driver = true
  accelerator_config {
    type         = "NVIDIA_TESLA_T4"
    core_count   = 1
  }
  vm_image {
    project      = "deeplearning-platform-release"
    image_family = "tf-latest-gpu"
  }
}

# Notebook with more parameters example
resource "google_notebooks_instance" "full_nb" {
  name = "full-notebooks-instance"
  location = "us-central1-a"
  machine_type = "e2-medium"

  vm_image {
    project      = "deeplearning-platform-release"
    image_family = "tf-latest-cpu"
  }

  instance_owners = ["exampleowner@google.com"]
  service_account = "project-service-account@exampleowner.iam.gserviceaccount.com"

  install_gpu_driver = true
  boot_disk_type = "PD_SSD"
  boot_disk_size_gb = 110

  no_public_ip = true
  no_proxy_access = true

  network = data.google_compute_network.my_network.id
  subnet = data.google_compute_subnetwork.my_subnetwork.id

  labels = {
    k = "val"
  }

  metadata = {
    terraform = "true"
  }
}

data "google_compute_network" "my_network" {
  name = "default"
}

data "google_compute_subnetwork" "my_subnetwork" {
  name   = "default"
  region = "us-central1"
}
