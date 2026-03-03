provider "google" {
  project = "ensai-2026"
  region  = var.region
  zone    = var.zone
}

resource "google_service_account" "vm_sa" {
  account_id   = "christophe-vm-sa"
  display_name = "Christophe VM Service Account"
}

resource "google_project_iam_member" "ar_reader" {
  project = "ensai-2026"
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.vm_sa.email}"
}

resource "google_compute_address" "ip_address" {
  name = "christophe-vm-ip"
}

resource "google_compute_instance" "default" {
  name         = "christophe-vm"
  machine_type = "n2-standard-2"
  zone         = var.zone
  tags         = ["http-server"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.ip_address.address
    }
  }

  metadata = {
    gce-container-declaration = <<-EOT
      spec:
        containers:
          - image: europe-docker.pkg.dev/ensai-2026/christophe/prenoms-api:latest
            name: prenoms-api
            ports:
              - containerPort: 8000
                hostPort: 80
                protocol: TCP
        restartPolicy: Always
    EOT
  }

  service_account {
    email  = google_service_account.vm_sa.email
    scopes = ["cloud-platform"]
  }
}

output "instance_ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}
