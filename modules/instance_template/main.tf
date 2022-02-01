resource "google_compute_instance_template" "wp-inst-tp" {
  name        = var.template-name
  description = var.template-desc

  metadata = {
    startup-script = var.startup-script
  }

  instance_description = "wp instance"
  machine_type         = var.machine-size
  can_ip_forward       = false

  disk {
    source_image      = "debian-cloud/debian-10"
    auto_delete       = true
    boot              = true
    disk_type         = "pd-ssd"
    disk_size_gb      = var.disk-size
  }

  scheduling {
    automatic_restart   = "false"
    on_host_maintenance = "MIGRATE"
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
  }

  service_account {
    email  = var.service-acc
    scopes = ["cloud-platform"]
  }
}