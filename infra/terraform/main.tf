resource "google_service_account" "backend_sa" {
  account_id   = "backend-sa"
  display_name = "VM Service Account"
}

resource "google_project_iam_member" "sa_artifact_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.backend_sa.email}"
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-8080"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "backend_vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params { image = "debian-cloud/debian-12" }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    container_image = var.image_uri
  }

  service_account {
    email  = google_service_account.backend_sa.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata_startup_script = file("${path.module}/../scripts/startup.sh")
}
