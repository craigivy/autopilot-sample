terraform {

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=3.80.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.80.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

provider "google-beta" {
  project = var.project
  region  = var.region
}

resource "google_project_service" "container_googleapis_com" {
  service = "container.googleapis.com"
}

resource "google_container_cluster" "devcluster" {
  provider         = google-beta
  name             = "devcluster"
  location         = var.region
  enable_autopilot = true
  depends_on = [
    google_project_service.container_googleapis_com,
  ]
}