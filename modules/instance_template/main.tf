resource "google_compute_instance_template" "wp-inst-tp" {
  name        = "wp-inst-tp"
  description = "template for wordpress instance."

  metadata = {
    startup-script = file("${path.module}/startup.sh")
  }

  instance_description = "wp instance"
  machine_type         = "e2-micro"
  can_ip_forward       = false

  disk {
    source_image      = "debian-cloud/debian-10"
    auto_delete       = true
    boot              = true
    disk_type         = "pd-ssd"
    disk_size_gb      = "10"
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