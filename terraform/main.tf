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

# # data "google_project" "project" {
# }

resource "google_project_service" "sqladmin_googleapis_com" {
  service = "sqladmin.googleapis.com"
}

resource "google_sql_database_instance" "instance" {
  name                = "my-instance"
  database_version    = "POSTGRES_13"
  deletion_protection = false

  settings {
    tier = "db-f1-micro"
  }

  depends_on = [
    google_project_service.sqladmin_googleapis_com,
  ]
}

resource "google_sql_database" "database" {
  name     = "my-database"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "dbuser" {
  name     = "dbuser"
  instance = google_sql_database_instance.instance.name
  password = "changeme"
}

resource "google_project_service" "container_googleapis_com" {
  service = "container.googleapis.com"
}

resource "google_container_cluster" "devcluster" {
  provider         = google-beta
  name             = "devcluster"
  location         = var.region
  enable_autopilot = true

  # workload_identity_config {
  #   identity_namespace = "${data.google_project.project.project_id}.svc.id.goog"
  # }

  depends_on = [
    google_project_service.container_googleapis_com,
  ]
}

resource "google_project_service" "iam_googleapis_com" {
  service = "iam.googleapis.com"
}

resource "google_service_account" "kube_sa" {
  account_id   = "sqlproxy-kube"
  display_name = "kube service account"
}

resource "google_project_iam_member" "kube-iam" {
  role   = "roles/cloudsql.client"
  member = "serviceAccount:${google_service_account.kube_sa.email}"

  depends_on = [
    google_project_service.iam_googleapis_com
  ]
}

resource "google_project_service" "serviceusage_googleapis_com" {
  service = "serviceusage.googleapis.com"
}

resource "google_project_service" "cloudbuild_googleapis_com" {
  service = "cloudbuild.googleapis.com"
}

 # ERROR: (gcloud.builds.submit) INVALID_ARGUMENT: could not resolve source: googleapi: Error 403: 134687027673@cloudbuild.gserviceaccount.com does not have storage.objects.get access to the Google Cloud Storage object., forbidden
